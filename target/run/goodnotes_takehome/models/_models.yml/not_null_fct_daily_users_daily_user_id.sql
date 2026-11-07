
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select daily_user_id
from DATAMARTS_DEV.james_nguyen.fct_daily_users
where daily_user_id is null



  
  
      
    ) dbt_internal_test