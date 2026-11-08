
    
    

select
    monthly_user_id as unique_field,
    count(*) as n_records

from "quillpad"."dev"."fct_monthly_users"
where monthly_user_id is not null
group by monthly_user_id
having count(*) > 1


