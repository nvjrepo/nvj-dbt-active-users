
    

    create  table
      "quillpad"."dev"."dim_users__dbt_tmp"
  
    
    as (
      with base as (
    select
        user_id,
        min(event_date) as first_event_date,
        max(event_date) as last_event_date,
        max(active_end_date) as last_active_end_date
    from "quillpad"."dev"."fct_users_activities_date_aggregated"
    group by 1
)

select
    user_id,
    first_event_date,
    last_event_date,
    last_active_end_date,

    -- Last day the daily spine should cover for this user:
    --   * past last_event_date, so the final 28-day active window is kept
    --   * plus the whole following calendar month, so the month the user drops out gets a row (-> 'Churned')
    --   * never past the last date in the data, where activity is unknown
    least(
        cast(cast(
        

    (

    (date_trunc('month', 

    (last_active_end_date + cast(1 as bigint) * interval 1 month)) + cast(1 as bigint) * interval 1 month) + cast(-1 as bigint) * interval 1 day)
        as date) as date),
        max(last_event_date) over ()
    ) as spine_end_date,

    
        (date_diff('day', first_event_date::timestamp, cast('2024-08-31' as date)::timestamp ))
     as user_tenure_days,

    cast(date_trunc('month', first_event_date) as date) as cohort_month

from base
    );
    
  