
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select user_event_date_id
from DATAMARTS_DEV.james_nguyen.fct_users_activities_date_aggregated
where user_event_date_id is null



  
  
      
    ) dbt_internal_test