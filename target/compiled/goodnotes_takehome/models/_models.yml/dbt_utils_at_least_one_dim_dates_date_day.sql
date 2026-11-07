







select *
from (
    with pruned_rows as (
      select
        date_day
      from DATAMARTS_DEV.james_nguyen.dim_dates
      
        where date_day is not null
        limit 1
      
    )
    select
        
        
      
      count(date_day) as filler_column

    from pruned_rows

    

    having count(date_day) = 0

) validation_errors

