
    
    

select
    date_day as unique_field,
    count(*) as n_records

from DATAMARTS_DEV.james_nguyen.dim_dates
where date_day is not null
group by date_day
having count(*) > 1


