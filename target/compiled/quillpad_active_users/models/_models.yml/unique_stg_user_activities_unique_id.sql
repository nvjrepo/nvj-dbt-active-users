
    
    

select
    unique_id as unique_field,
    count(*) as n_records

from "active_users"."main"."stg_user_activities"
where unique_id is not null
group by unique_id
having count(*) > 1


