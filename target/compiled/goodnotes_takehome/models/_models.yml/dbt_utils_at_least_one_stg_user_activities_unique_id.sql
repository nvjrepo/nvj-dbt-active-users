







select *
from (
    with pruned_rows as (
      select
        unique_id
      from DATAMARTS_DEV.james_nguyen.stg_user_activities
      
        where unique_id is not null
        limit 1
      
    )
    select
        
        
      
      count(unique_id) as filler_column

    from pruned_rows

    

    having count(unique_id) = 0

) validation_errors

