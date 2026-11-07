with monthly_aggregated as (
    select
        date_trunc('month', date_day) as date_month,
        user_id,
        sum(case when is_active then 1 else 0 end) as active_days_count,
        sum(case when not is_active then 1 else 0 end) as inactive_days_count,
        sum(case when is_active then 1 else 0 end) > 0 as has_active_days,
        sum(case when not is_active then 1 else 0 end) > 0 as has_inactive_days,
        sum(number_of_events) as number_of_events
    from DATAMARTS_DEV.james_nguyen.fct_daily_users
    group by 1,2
),

with_previous_month as (
    select
        *,
        lag(has_active_days) over (partition by user_id order by date_month) as was_active_previous_month
    from monthly_aggregated
),

user_first_month as (
    select
        user_id,
        min(date_month) as first_month
    from monthly_aggregated
    where has_active_days
    group by 1
)

select
    ma.date_month,
    ma.user_id,
    ma.active_days_count,
    ma.inactive_days_count,
    ma.has_active_days,
    ma.has_inactive_days,
    ma.number_of_events,
    ufm.first_month as user_first_month,

    coalesce(wpm.was_active_previous_month, false) as was_active_previous_month,
    case when ufm.first_month = ma.date_month then true else false end as is_new_user,

    -- Transition type logic
    case
        when wpm.was_active_previous_month is null and ma.has_active_days then 'New'
        when wpm.was_active_previous_month and ma.has_active_days then 'Retained'
        when wpm.was_active_previous_month and not ma.has_active_days then 'Churned'
        when not coalesce(wpm.was_active_previous_month, false) and ma.has_active_days then 'Reactivated'
        else 'Inactive'
    end as transition_type,

    md5(cast(coalesce(cast(ma.date_month as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(ma.user_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as monthly_user_id

from monthly_aggregated ma
left join with_previous_month wpm
    on ma.user_id = wpm.user_id
    and ma.date_month = wpm.date_month
left join user_first_month ufm
    on ma.user_id = ufm.user_id