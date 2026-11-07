{# /* 3 month from last event date */ #}
{%- set reporting_date = '2024-08-31' -%}

with base as (
    select
        user_id,
        min(event_date) as first_event_date,
        max(event_date) as last_event_date
    from {{ ref('fct_users_activities_date_aggregated') }}
    group by 1
)

select
    user_id,
    first_event_date,
    last_event_date,
    datediff('day', first_event_date, '{{ reporting_date }}'::date) as user_tenure_days,

    {{ dbt.date_trunc('month', 'first_event_date') }} as cohort_month

from base
