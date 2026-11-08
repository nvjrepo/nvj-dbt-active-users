-- Example: View events for user '0002511D96A94E1F94F636B200B29554'
with events as (
    select
        user_id,
        event_date,
        event_name,
        lead(event_date) over (partition by user_id order by event_date) as next_event_date
    from "quillpad"."dev"."stg_user_activities"
    where user_id = '0002511D96A94E1F94F636B200B29554'
)

select
    *,
    
        (date_diff('day', event_date::timestamp, next_event_date::timestamp ))
     as days_to_next_event
from events
order by event_date;