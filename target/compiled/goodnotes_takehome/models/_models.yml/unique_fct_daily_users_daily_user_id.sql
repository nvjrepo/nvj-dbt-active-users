
    
    

select
    daily_user_id as unique_field,
    count(*) as n_records

from DATAMARTS_DEV.james_nguyen.fct_daily_users
where daily_user_id is not null
group by daily_user_id
having count(*) > 1


