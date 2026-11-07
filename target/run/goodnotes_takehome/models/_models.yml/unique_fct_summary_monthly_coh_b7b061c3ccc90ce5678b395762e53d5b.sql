
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    cohort_performance_id as unique_field,
    count(*) as n_records

from DATAMARTS_DEV.james_nguyen.fct_summary_monthly_cohort_performance
where cohort_performance_id is not null
group by cohort_performance_id
having count(*) > 1



  
  
      
    ) dbt_internal_test