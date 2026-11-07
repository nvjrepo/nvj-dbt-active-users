
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    monthly_user_id as unique_field,
    count(*) as n_records

from DATAMARTS_DEV.james_nguyen.fct_monthly_users
where monthly_user_id is not null
group by monthly_user_id
having count(*) > 1



  
  
      
    ) dbt_internal_test