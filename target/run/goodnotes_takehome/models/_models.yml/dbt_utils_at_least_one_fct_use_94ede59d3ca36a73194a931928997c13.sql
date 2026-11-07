
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  







select *
from (
    with pruned_rows as (
      select
        user_event_date_id
      from DATAMARTS_DEV.james_nguyen.fct_users_activities_date_aggregated
      
        where user_event_date_id is not null
        limit 1
      
    )
    select
        
        
      
      count(user_event_date_id) as filler_column

    from pruned_rows

    

    having count(user_event_date_id) = 0

) validation_errors


  
  
      
    ) dbt_internal_test