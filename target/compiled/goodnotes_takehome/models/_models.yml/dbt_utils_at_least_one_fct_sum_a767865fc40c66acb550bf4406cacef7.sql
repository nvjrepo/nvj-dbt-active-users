







select *
from (
    with pruned_rows as (
      select
        cohort_performance_id
      from DATAMARTS_DEV.james_nguyen.fct_summary_monthly_cohort_performance
      
        where cohort_performance_id is not null
        limit 1
      
    )
    select
        
        
      
      count(cohort_performance_id) as filler_column

    from pruned_rows

    

    having count(cohort_performance_id) = 0

) validation_errors

