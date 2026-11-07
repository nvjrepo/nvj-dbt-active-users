
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select unique_id
from DATAMARTS_DEV.james_nguyen.stg_user_activities
where unique_id is null



  
  
      
    ) dbt_internal_test