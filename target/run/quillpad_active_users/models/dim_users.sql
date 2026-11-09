
    

    create  table
      "active_users"."main"."dim_users__dbt_tmp"
  
    
    as (
      with base as (
    select
        user_id,
        min(event_date) as first_event_date,
        max(event_date) as last_event_date,
        max(active_end_date) as last_active_end_date
    from "active_users"."main"."fct_users_activities_date_aggregated"
    group by 1
)

select
    user_id,
    first_event_date,
    last_event_date,
    last_active_end_date,

    
        (date_diff('day', first_event_date::timestamp, cast('2024-06-30' as date)::timestamp ))
     as user_tenure_days,

    cast(date_trunc('month', first_event_date) as date) as cohort_month

from base
    );
    
  