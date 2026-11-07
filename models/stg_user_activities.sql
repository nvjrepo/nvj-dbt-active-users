select distinct
    {{ dbt_utils.generate_surrogate_key([
        "user_id",
        "event_date",
        "event_name"
    ]) }} as unique_id,
    user_id,
    event_date,
    event_name
from {{ source('source', 'user_activities') }}
