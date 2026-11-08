
    

    create  table
      "quillpad"."dev"."fct_daily_users__dbt_tmp"
  
    
    as (
      -- cross join user and date
with dates as (
    select
        dates.date_day,
        users.user_id,
        md5(cast(coalesce(cast(dates.date_day as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(users.user_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as daily_user_id

    from "quillpad"."dev"."dim_dates" as dates
    cross join "quillpad"."dev"."dim_users" as users
    where dates.date_day between users.first_event_date and users.spine_end_date
)

select
    dates.*,
    active_check.user_id is not null as is_active,
    coalesce(event_data.number_of_events, 0) as number_of_events

from dates
left join "quillpad"."dev"."fct_users_activities_date_aggregated" as active_check
    on dates.date_day between active_check.event_date and active_check.active_end_date
        and dates.user_id = active_check.user_id
left join "quillpad"."dev"."fct_users_activities_date_aggregated" as event_data
    on dates.date_day = event_data.event_date
        and dates.user_id = event_data.user_id
    );
    
  