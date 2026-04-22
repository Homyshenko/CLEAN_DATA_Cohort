WITH prepared_users AS (
    SELECT 
        user_id,
        promo_signup_flag,
        REGEXP_REPLACE(SPLIT_PART(TRIM(signup_datetime), ' ', 1), '[./]', '-', 'g') AS clean_date_str
    FROM cohort_users_raw
),
date_conversion_users AS (
    SELECT 
        *,
        CASE 
            WHEN clean_date_str ~ '^\d{1,2}-\d{1,2}-\d{4}$' 
            	THEN TO_DATE(clean_date_str, 'DD-MM-YYYY')
            WHEN clean_date_str ~ '^\d{1,2}-\d{1,2}-\d{2}$' 
            	THEN TO_DATE(clean_date_str, 'DD-MM-YY')
            ELSE NULL 
        END::timestamp AS signup_at_clean
    FROM prepared_users
),
prepared_events AS (
    SELECT 
        user_id,
        event_type,
        REGEXP_REPLACE(SPLIT_PART(TRIM(event_datetime), ' ', 1), '[./]', '-', 'g') AS clean_event_date_str
    FROM cohort_events_raw
    WHERE event_id IS NOT NULL 
      AND event_type != 'test_event' AND event_type IS NOT NULL  
),
date_conversion_events AS (
    SELECT 
        *,
        CASE 
            WHEN clean_event_date_str ~ '^\d{1,2}-\d{1,2}-\d{4}$' 
            	THEN TO_DATE(clean_event_date_str, 'DD-MM-YYYY')
            WHEN clean_event_date_str ~ '^\d{1,2}-\d{1,2}-\d{2}$' 
            	THEN TO_DATE(clean_event_date_str, 'DD-MM-YY')
            ELSE NULL 
        END::timestamp AS event_at_clean
    FROM prepared_events
),
joined_data AS(
SELECT 
    e.user_id,
	e.event_type,
	u.promo_signup_flag,
	e.event_at_clean,
	TO_CHAR(u.signup_at_clean, 'YYYY-MM-01') AS cohort_month,
    TO_CHAR(e.event_at_clean, 'YYYY-MM-01') AS event_month,
    (EXTRACT(YEAR FROM e.event_at_clean) - EXTRACT(YEAR FROM u.signup_at_clean)) * 12 +
    (EXTRACT(MONTH FROM e.event_at_clean) - EXTRACT(MONTH FROM u.signup_at_clean)) AS month_offset
FROM date_conversion_events e
INNER JOIN date_conversion_users u ON e.user_id = u.user_id
WHERE u.signup_at_clean IS NOT NULL 
	AND e.event_at_clean IS NOT null
)
SELECT 
    promo_signup_flag,
    cohort_month,
    month_offset,
    COUNT(DISTINCT user_id)
FROM joined_data
WHERE event_at_clean >= '2025-01-01' AND event_at_clean <= '2025-06-30'
GROUP BY promo_signup_flag, cohort_month, month_offset
ORDER BY promo_signup_flag, cohort_month, month_offset;


