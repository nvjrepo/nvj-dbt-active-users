-- Example: View events for user '0002511D96A94E1F94F636B200B29554'
select
    user_id,
    event_date,
    event_name,
    lead(event_date) over (partition by user_id order by event_date) as next_event_date,
    datediff(day, event_date, next_event_date) as days_to_next_event
from james_nguyen.stg_user_activities
where user_id = '0002511D96A94E1F94F636B200B29554'
order by event_date;
