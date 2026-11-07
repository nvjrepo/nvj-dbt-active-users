with monthly_status as (
    select
        user_id,
        date_month,
        has_active_days,
        lag(has_active_days) over (partition by user_id order by date_month) as prev_month_active
    from DATAMARTS_DEV.james_nguyen.fct_monthly_users
)

select
    md5(cast(coalesce(cast(user_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(date_month as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as transition_id,
    user_id,
    date_month,
    has_active_days as is_active_this_month,
    prev_month_active as was_active_previous_month,

    case
        when prev_month_active is null and has_active_days then 'New'
        when prev_month_active and has_active_days then 'Retained'
        when prev_month_active and not has_active_days then 'Churned'
        when not coalesce(prev_month_active, false) and has_active_days then 'Reactivated'
        else 'Inactive'
    end as transition_type

from monthly_status