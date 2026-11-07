
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select monthly_user_id
from DATAMARTS_DEV.james_nguyen.fct_monthly_users
where monthly_user_id is null



  
  
      
    ) dbt_internal_test