
  
    

create or replace transient table DATAMARTS_DEV.james_nguyen.stg_user_activities
    
    
    
    as (select distinct
    md5(cast(coalesce(cast(user_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(event_date as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(event_name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as unique_id,
    user_id,
    event_date,
    event_name
from DATAMARTS_DEV.james_nguyen.user_activities
    )
;


  