
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select cohort_performance_id
from DATAMARTS_DEV.james_nguyen.fct_summary_monthly_cohort_performance
where cohort_performance_id is null



  
  
      
    ) dbt_internal_test