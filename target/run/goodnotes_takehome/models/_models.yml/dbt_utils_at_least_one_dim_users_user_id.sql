
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  







select *
from (
    with pruned_rows as (
      select
        user_id
      from DATAMARTS_DEV.james_nguyen.dim_users
      
        where user_id is not null
        limit 1
      
    )
    select
        
        
      
      count(user_id) as filler_column

    from pruned_rows

    

    having count(user_id) = 0

) validation_errors


  
  
      
    ) dbt_internal_test