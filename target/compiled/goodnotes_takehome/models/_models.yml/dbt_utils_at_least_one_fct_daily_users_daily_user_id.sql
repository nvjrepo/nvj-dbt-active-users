







select *
from (
    with pruned_rows as (
      select
        daily_user_id
      from DATAMARTS_DEV.james_nguyen.fct_daily_users
      
        where daily_user_id is not null
        limit 1
      
    )
    select
        
        
      
      count(daily_user_id) as filler_column

    from pruned_rows

    

    having count(daily_user_id) = 0

) validation_errors

