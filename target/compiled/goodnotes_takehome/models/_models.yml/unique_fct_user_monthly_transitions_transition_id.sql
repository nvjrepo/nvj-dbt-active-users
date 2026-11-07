
    
    

select
    transition_id as unique_field,
    count(*) as n_records

from DATAMARTS_DEV.james_nguyen.fct_user_monthly_transitions
where transition_id is not null
group by transition_id
having count(*) > 1


