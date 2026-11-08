-- fixed denominator: every user in the cohort, whether or not they still have rows that month
with cohort_sizes as (
    select
        cohort_month,
        count(*) as cohort_size
    from "quillpad"."dev"."dim_users"
    group by 1
),

monthly as (
    select
        du.cohort_month,
        fm.date_month,

        count(distinct case when fm.has_active_days then fm.user_id end) as active_users,

        -- Engagement metrics (users with rows in the month)
        avg(fm.active_days_count) as avg_active_days,
        avg(
            case
                when (fm.active_days_count + fm.inactive_days_count) > 0
                then cast(fm.active_days_count as double) / (fm.active_days_count + fm.inactive_days_count)
                else 0
            end
        ) as avg_engagement_score

    from "quillpad"."dev"."fct_monthly_users" as fm
    inner join "quillpad"."dev"."dim_users" as du
        on fm.user_id = du.user_id
    group by 1,2
)

select
    md5(cast(coalesce(cast(monthly.cohort_month as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(monthly.date_month as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as cohort_performance_id,
    monthly.cohort_month,
    monthly.date_month,
    
        (date_diff('month', monthly.cohort_month::timestamp, monthly.date_month::timestamp ))
     as months_since_cohort,

    -- Counts
    monthly.active_users,
    cohort_sizes.cohort_size as total_cohort_users,

    monthly.avg_active_days,
    monthly.avg_engagement_score,

    -- Retention rate: active cohort users / full cohort size
    cast(monthly.active_users as double) / nullif(cohort_sizes.cohort_size, 0) as retention_rate

from monthly
inner join cohort_sizes
    on monthly.cohort_month = cohort_sizes.cohort_month