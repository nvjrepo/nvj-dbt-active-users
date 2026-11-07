
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  







select *
from (
    with pruned_rows as (
      select
        transition_id
      from DATAMARTS_DEV.james_nguyen.fct_user_monthly_transitions
      
        where transition_id is not null
        limit 1
      
    )
    select
        
        
      
      count(transition_id) as filler_column

    from pruned_rows

    

    having count(transition_id) = 0

) validation_errors


  
  
      
    ) dbt_internal_test