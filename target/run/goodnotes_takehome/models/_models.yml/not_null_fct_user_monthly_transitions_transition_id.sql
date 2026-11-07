
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select transition_id
from DATAMARTS_DEV.james_nguyen.fct_user_monthly_transitions
where transition_id is null



  
  
      
    ) dbt_internal_test