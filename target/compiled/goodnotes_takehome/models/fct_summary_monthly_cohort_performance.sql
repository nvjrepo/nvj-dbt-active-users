select
    md5(cast(coalesce(cast(cohort_month as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(fm.date_month as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as cohort_performance_id,
    date_trunc('month', du.first_event_date) as cohort_month,
    fm.date_month,
    datediff('month', date_trunc('month', du.first_event_date), fm.date_month) as months_since_cohort,

    -- Counts
    count(distinct case when fm.has_active_days then fm.user_id end) as active_users,
    count(distinct fm.user_id) as total_cohort_users,

    -- Engagement metrics
    avg(fm.active_days_count) as avg_active_days,
    avg(
        case
            when (fm.active_days_count + fm.inactive_days_count) > 0
            then fm.active_days_count::float / (fm.active_days_count + fm.inactive_days_count)
            else 0
        end
    ) as avg_engagement_score,

    -- Retention rate
    case
        when count(distinct fm.user_id) > 0
        then count(distinct case when fm.has_active_days then fm.user_id end)::float / count(distinct fm.user_id)
        else 0
    end as retention_rate,


from DATAMARTS_DEV.james_nguyen.fct_monthly_users fm
join DATAMARTS_DEV.james_nguyen.dim_users du on fm.user_id = du.user_id
group by 1,2,3,4