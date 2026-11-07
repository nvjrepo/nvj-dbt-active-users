
    
    

select
    unique_id as unique_field,
    count(*) as n_records

from DATAMARTS_DEV.james_nguyen.stg_user_activities
where unique_id is not null
group by unique_id
having count(*) > 1


