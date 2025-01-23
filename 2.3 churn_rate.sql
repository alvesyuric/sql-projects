WITH 

-- Define a list of months with their first and last days
months AS (
SELECT
    '2017-01-01' AS first_day,
    '2017-01-31' AS last_day
UNION
SELECT '2017-02-01', '2017-02-28'
UNION
SELECT '2017-03-01', '2017-03-31'
),

-- Create a cross join between subscriptions and months to generate all month combinations
cross_join AS (
SELECT *
FROM subscriptions
CROSS JOIN months
),

-- Determine subscription status for each month 
status AS (
SELECT
    id,
    segment,
    first_day AS month,
    CASE
        WHEN subscription_start < first_day THEN 1 ELSE 0 END AS is_active, 
    CASE
        WHEN subscription_start < first_day 
            AND subscription_end BETWEEN first_day AND last_day THEN 1 ELSE 0 
    END AS is_canceled
FROM cross_join
),

-- Calculate the churn rate for each segment and month
status_aggregate AS (
SELECT
    segment,
    month,
    ROUND(1.0 * SUM(is_canceled) / SUM(is_active), 2) AS churn_rate
FROM status
GROUP BY 1, 2
)

-- Select all columns from the final result
SELECT * FROM status_aggregate;