
    
    

select
    cohort_performance_id as unique_field,
    count(*) as n_records

from DATAMARTS_DEV.james_nguyen.fct_summary_monthly_cohort_performance
where cohort_performance_id is not null
group by cohort_performance_id
having count(*) > 1


