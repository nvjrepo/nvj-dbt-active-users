{%- set reporting_end_date = var('reporting_end_date') -%}

with base as (
    select
        user_id,
        min(event_date) as first_event_date,
        max(event_date) as last_event_date,
        max(active_end_date) as last_active_end_date
    from {{ ref('fct_users_activities_date_aggregated') }}
    group by 1
)

select
    user_id,
    first_event_date,
    last_event_date,
    last_active_end_date,

    {{ dbt.datediff('first_event_date', "cast('" ~ reporting_end_date ~ "' as date)", 'day') }} as user_tenure_days,

    cast({{ dbt.date_trunc('month', 'first_event_date') }} as date) as cohort_month

from base
