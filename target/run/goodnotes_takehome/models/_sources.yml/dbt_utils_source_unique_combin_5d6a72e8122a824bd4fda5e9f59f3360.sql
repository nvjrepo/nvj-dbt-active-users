
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        user_id, event_date, event_name
    from DATAMARTS_DEV.james_nguyen.user_activities
    group by user_id, event_date, event_name
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test