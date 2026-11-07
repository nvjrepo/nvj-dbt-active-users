
  
    

create or replace transient table DATAMARTS_DEV.james_nguyen.fct_users_activities_date_aggregated
    
    
    
    as (-- distinct table by user id and date
with activities as (
    select
       user_id,
       event_date,
       listagg(event_name, ', ') within group (order by event_name)  as event_names,
       count(*) as number_of_events,
       count(distinct event_name) as event_diversity

    from DATAMARTS_DEV.james_nguyen.stg_user_activities
    group by 1,2

),

-- find out active period
windowed as (
    select
        md5(cast(coalesce(cast(user_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(event_date as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as user_event_date_id,
        *,
        lead(event_date) over (partition by user_id order by event_date)  as next_date,
        case when next_date is null then 0 else datediff(day, event_date, next_date) end as diff,
        date(
            case
                when datediff(day, event_date, next_date) <= 28 then next_date
                when next_date is null then dateadd(day, 28, event_date)
                else dateadd(day, 28, event_date)
            end
        ) - 1 as active_end_date
   from activities
)

select
    user_event_date_id,
    user_id,
    event_date,
    event_names,
    number_of_events,
    event_diversity,
    next_date,
    diff,
    active_end_date,

    -- Event type flags for filtering
    case when event_names like '%login%' then true else false end as has_login_event,
    case when event_names like '%export%' then true else false end as has_export_event,
    case when event_names like '%share%' then true else false end as has_share_event

from windowed
    )
;


  