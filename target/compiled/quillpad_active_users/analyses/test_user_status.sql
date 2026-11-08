-- Test query to verify active/inactive logic for user 0002511D96A94E1F94F636B200B29554
-- This will show you day-by-day status using your current logic

with user_events as (
    -- Get all events for this specific user
    select
        user_id,
        event_date,
        event_name
    from "quillpad"."dev"."stg_user_activities"
    where user_id = '0002511D96A94E1F94F636B200B29554'
    order by event_date
),

activities_with_windows as (
    -- Calculate active_end_date using your existing logic
    select
        user_id,
        event_date,
        event_names,
        next_date,
        case when next_date is null then 0 else 
        (date_diff('day', event_date::timestamp, next_date::timestamp ))
     end as days_to_next_event,
        cast(
            case
                when 
        (date_diff('day', event_date::timestamp, next_date::timestamp ))
     <= 28 then next_date
                when next_date is null then cast('9999-12-31' as date)
                else 

    (event_date + cast(28 as bigint) * interval 1 day)
            end
        as date) - 1 as active_end_date
    from (
        select
            user_id,
            event_date,
            
    string_agg(
        event_name,
        ', '
        order by event_name
        ) as event_names,
            lead(event_date) over (partition by user_id order by event_date) as next_date
        from user_events
        group by user_id, event_date
    ) as daily_events
),

-- Generate a date spine for this user
date_spine as (
    select cast(date_day as date) as date_day
    from generate_series(
        (select min(event_date) from user_events)::timestamp,
        (select max(event_date) + 60 from user_events)::timestamp,  -- Go 60 days past last event
        interval 1 day
    ) as spine(date_day)
),

-- Check status for each day
daily_status as (
    select
        date_spine.date_day,
        -- Check if active (has event in prior 28 days)
        max(case
            when date_spine.date_day between aw.event_date and aw.active_end_date
            then 1 else 0
        end) as is_active,
        -- Check if inactive (28 days AFTER active period ends)
        max(case
            when date_spine.date_day between aw.active_end_date + 1
                                        and aw.active_end_date + 28
            then 1 else 0
        end) as is_inactive,
        -- Show which events contribute to active status
        string_agg(
            case
                when date_spine.date_day between aw.event_date and aw.active_end_date
                then aw.event_date::VARCHAR || ' (' || aw.event_names || ')'
                else null
            end,
            '; '
            order by aw.event_date
        ) as active_from_events,
        -- Show which events contribute to inactive status
        string_agg(
            case
                when date_spine.date_day between aw.active_end_date + 1
                                            and aw.active_end_date + 28
                then aw.event_date::VARCHAR || ' ended on ' || aw.active_end_date::VARCHAR
                else null
            end,
            '; '
            order by aw.event_date
        ) as inactive_from_events
    from date_spine
    cross join activities_with_windows aw
    group by date_spine.date_day
)

select
    date_day,
    strftime(date_day, '%a') as day_of_week,
    is_active::boolean as is_active,
    is_inactive::boolean as is_inactive,
    case
        when is_active = 1 then 'ACTIVE'
        when is_inactive = 1 then 'INACTIVE'
        else 'NEITHER'
    end as status,
    active_from_events,
    inactive_from_events
from daily_status
order by date_day;