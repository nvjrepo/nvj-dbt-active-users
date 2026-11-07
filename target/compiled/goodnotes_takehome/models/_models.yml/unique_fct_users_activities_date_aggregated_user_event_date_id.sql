
    
    

select
    user_event_date_id as unique_field,
    count(*) as n_records

from DATAMARTS_DEV.james_nguyen.fct_users_activities_date_aggregated
where user_event_date_id is not null
group by user_event_date_id
having count(*) > 1


