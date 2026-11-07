{% docs event_date %}
Event Date - The ID of the event date
{% enddocs %}

{% docs user_id %}
The user ID which relates to this event
{% enddocs %}

{% docs event_name %}
The name of the event
{% enddocs %}

{% docs user_event_date_id %}
Unique identifier combining user_id and event_date
{% enddocs %}

{% docs active_days_count %}
Count of active days in the month. Aggregated from fct_daily_users where is_active = TRUE.
{% enddocs %}

{% docs inactive_days_count %}
Count of inactive days in the month. Aggregated from fct_daily_users where is_inactive = TRUE.
{% enddocs %}

{% docs has_active_days %}
Boolean flag indicating whether the user has at least one active day in the month. TRUE if active_days_count > 0.
{% enddocs %}

{% docs has_inactive_days %}
Boolean flag indicating whether the user has at least one inactive day in the month. TRUE if inactive_days_count > 0.
{% enddocs %}

{% docs number_of_events %}
Total count of events performed by the user during the specified time period. For daily records, this represents events on that specific date. For monthly records, this is the sum of all events across the month.
{% enddocs %}

{% docs monthly_user_id %}
Surrogate key generated from date_month and user_id for unique monthly user identification.
{% enddocs %}

{% docs user_tenure_days %}
Number of days since the user's first recorded event. Useful for understanding user maturity and segmenting by tenure.
{% enddocs %}

{% docs cohort_month %}
The month when the user first had any activity. Used for cohort analysis to track user groups over time.
{% enddocs %}

{% docs activity_frequency_bucket %}
Categorizes users by their monthly activity level:
- **Inactive**: 0 active days
- **1-5 days**: Light users
- **6-15 days**: Regular users
- **16-25 days**: Heavy users
- **26+ days**: Power users
{% enddocs %}

{% docs engagement_score %}
Ratio of active days to total days in the period (0-1 scale). Higher scores indicate more consistent engagement.
Formula: active_days_count / (active_days_count + inactive_days_count)
{% enddocs %}

{% docs transition_type %}
Type of user state transition from previous month to current month:
- **New**: First time appearing (no previous activity)
- **Retained**: Active in both previous and current month
- **Churned**: Was active previously, became inactive
- **Reactivated**: Was inactive previously, became active again
- **Inactive**: Continues to be inactive
{% enddocs %}

{% docs retention_rate %}
Percentage of users from a cohort who remained active in a given period.
Formula: active_users / total_cohort_users
{% enddocs %}
