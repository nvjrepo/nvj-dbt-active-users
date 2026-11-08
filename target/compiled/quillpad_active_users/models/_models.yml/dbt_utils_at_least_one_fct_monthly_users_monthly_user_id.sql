







select *
from (
    with pruned_rows as (
      select
        monthly_user_id
      from "quillpad"."dev"."fct_monthly_users"
      
        where monthly_user_id is not null
        limit 1
      
    )
    select
        
        
      
      count(monthly_user_id) as filler_column

    from pruned_rows

    

    having count(monthly_user_id) = 0

) validation_errors

