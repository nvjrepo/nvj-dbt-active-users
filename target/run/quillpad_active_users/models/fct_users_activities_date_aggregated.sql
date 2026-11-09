
    

    create  table
      "active_users"."main"."fct_users_activities_date_aggregated__dbt_tmp"
  
    
    as (
      -- distinct table by user id and date
with activities as (
    select
       user_id,
       event_date,
       
    string_agg(
        event_name,
        ', '
        order by event_name
        ) as event_names,
       count(*) as number_of_events

    from "active_users"."main"."stg_user_activities"
    group by 1,2

),

with_next_date as (
    select
        *,
        lead(event_date) over (partition by user_id order by event_date) as next_date
    from activities
),

-- find out active period
windowed as (
    select
        md5(cast(coalesce(cast(user_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(event_date as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as user_event_date_id,
        *,
        case when next_date is null then 0 else 
        (date_diff('day', event_date::timestamp, next_date::timestamp ))
     end as diff,
        cast(
            case
                when 
        (date_diff('day', event_date::timestamp, next_date::timestamp ))
     <= 28 then next_date
                else 

    (event_date + cast(28 as bigint) * interval 1 day)
            end
        as date) - 1 as active_end_date
   from with_next_date
)

select
    user_event_date_id,
    user_id,
    event_date,
    event_names,
    number_of_events,
    next_date,
    diff,
    active_end_date,

    -- Event type flags for filtering
    case when event_names like '%login%' then true else false end as has_login_event,
    case when event_names like '%export%' then true else false end as has_export_event,
    case when event_names like '%share%' then true else false end as has_share_event

from windowed
    );
    
  