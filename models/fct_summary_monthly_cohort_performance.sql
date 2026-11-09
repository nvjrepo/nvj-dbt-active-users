with cohort_sizes as (
    select
        cohort_month,
        count(*) as cohort_size
    from {{ ref('dim_users') }}
    group by 1
),

monthly as (
    select
        du.cohort_month,
        fm.date_month,

        count(distinct case when fm.has_active_days then fm.user_id end) as active_users,

        -- Engagement metrics (active users only)
        avg(case when fm.has_active_days then fm.active_days_count end) as avg_active_days,
        avg(
            case
                when fm.has_active_days
                then cast(fm.active_days_count as double) / (fm.active_days_count + fm.inactive_days_count)
            end
        ) as avg_engagement_score

    from {{ ref('fct_monthly_users') }} as fm
    inner join {{ ref('dim_users') }} as du
        on fm.user_id = du.user_id
    {{ dbt_utils.group_by(2) }}
)

select
    {{ dbt_utils.generate_surrogate_key(['monthly.cohort_month', 'monthly.date_month']) }} as cohort_performance_id,
    monthly.cohort_month,
    monthly.date_month,
    {{ dbt.datediff('monthly.cohort_month', 'monthly.date_month', 'month') }} as months_since_cohort,

    -- Counts
    monthly.active_users,
    cohort_sizes.cohort_size as total_cohort_users,

    monthly.avg_active_days,
    monthly.avg_engagement_score,

    -- Retention rate
    cast(monthly.active_users as double) / nullif(cohort_sizes.cohort_size, 0) as retention_rate

from monthly
inner join cohort_sizes
    on monthly.cohort_month = cohort_sizes.cohort_month
