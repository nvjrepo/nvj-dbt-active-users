
    

    create  table
      "active_users"."main"."stg_user_activities__dbt_tmp"
  
    
    as (
      select distinct
    md5(cast(coalesce(cast(user_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(event_date as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(event_name as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as unique_id,
    user_id,
    event_date,
    event_name
from "active_users"."raw"."user_activities"
    );
    
  