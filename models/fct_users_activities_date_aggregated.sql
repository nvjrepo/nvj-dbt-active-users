-- distinct table by user id and date
with activities as (
    select
       user_id,
       event_date,
       {{ dbt.listagg('event_name', "', '", 'order by event_name') }} as event_names,
       count(*) as number_of_events

    from {{ ref('stg_user_activities') }}
    {{ dbt_utils.group_by(2)}}

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
        {{ dbt_utils.generate_surrogate_key([
            "user_id",
            "event_date"
        ]) }} as user_event_date_id,
        *,
        case when next_date is null then 0 else {{ dbt.datediff('event_date', 'next_date', 'day') }} end as diff,
        cast(
            case
                when {{ dbt.datediff('event_date', 'next_date', 'day') }} <= 28 then next_date
                else {{ dbt.dateadd('day', 28, 'event_date') }}
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
