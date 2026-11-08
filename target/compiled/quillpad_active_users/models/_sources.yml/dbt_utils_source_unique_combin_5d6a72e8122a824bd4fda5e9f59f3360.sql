





with validation_errors as (

    select
        user_id, event_date, event_name
    from read_csv('seeds/user_activities.csv', header=true, types=['DATE','VARCHAR','VARCHAR'])
    group by user_id, event_date, event_name
    having count(*) > 1

)

select *
from validation_errors


