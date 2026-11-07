select
    date_day,
    user_id,
    is_active,
    case
        when is_active then 'ACTIVE'
        when not is_active then 'INACTIVE'
        else 'NEITHER'
    end as user_status
from james_nguyen.fct_daily_users
where user_id = '0002511D96A94E1F94F636B200B29554'
order by date_day;
