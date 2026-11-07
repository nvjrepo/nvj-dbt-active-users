with base as (
    select
        user_id,
        min(event_date) as first_event_date,
        max(event_date) as last_event_date
    from DATAMARTS_DEV.james_nguyen.fct_users_activities_date_aggregated
    group by 1
)

select
    user_id,
    first_event_date,
    last_event_date,
    datediff('day', first_event_date, '2024-08-31'::date) as user_tenure_days,

    date_trunc('month', first_event_date) as cohort_month

from base