-- ============================================================
-- 🧾 FINAL DATA LOAD QUERY
-- Cleans, validates, and loads data from staging → analytics
-- ============================================================

WITH cleaned AS (
    SELECT
        -- === IDENTIFIERS ===
        CAST(REGEXP_REPLACE(transaction_id::TEXT, '\.0$', '', 'g') AS BIGINT)::TEXT AS transaction_id,
        CAST(REGEXP_REPLACE(customer_id::TEXT, '\.0$', '', 'g') AS BIGINT)::TEXT AS customer_id,

        -- === PERSONAL DETAILS ===
        INITCAP(
            TRIM(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(name,'^(mr|mrs|ms|dr|miss|prof)[\\.\s]+','','i'),
                    '[,\\s]*(phd|md|dds|jr|sr)\\.?$','','i'
                )
            )
        ) AS name,
        CASE
            WHEN TRIM(email) ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
            THEN LOWER(TRIM(email))
            ELSE NULL
        END AS email,
        TRIM(REGEXP_REPLACE(REGEXP_REPLACE(phone, '\.0$', ''), '[^0-9]', '', 'g')) AS phone,

        -- === LOCATION ===
        INITCAP(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(address, '[,\.]+$', '', 'g'), '\s+$', '', 'g'))) AS address,
        INITCAP(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(city, '[,\.]', '', 'g'), '\s+', ' ', 'g'))) AS city,
        INITCAP(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(state, '[,\.]', '', 'g'), '\s+', ' ', 'g'))) AS state,
        REGEXP_REPLACE(TRIM(zipcode::TEXT), '\.0$', '', 'g') AS zipcode,
        TRIM(UPPER(REGEXP_REPLACE(REGEXP_REPLACE(country, '[,\.]', '', 'g'), '\s+', ' ', 'g'))) AS country,

        -- === DEMOGRAPHICS ===
        CAST(REGEXP_REPLACE(age::TEXT, '\.0$', '', 'g') AS INTEGER) AS age,
        INITCAP(TRIM(gender)) AS gender,
        INITCAP(TRIM(income)) AS income,
        INITCAP(TRIM(customer_segment)) AS customer_segment,

        -- === TEMPORAL ===
        TO_DATE(TRIM(date), 'MM/DD/YYYY') AS date,
        CAST(REGEXP_REPLACE("year"::TEXT, '\.0$', '', 'g') AS INTEGER) AS "year",
        INITCAP(TRIM(month)) AS month,
        TO_CHAR(TO_TIMESTAMP(TRIM(time), 'HH24:MI:SS'), 'HH24:MI:SS')::TIME AS time,

        -- === FINANCIAL ===
        CAST(REGEXP_REPLACE(total_purchases::TEXT, '\.0$', '', 'g') AS INTEGER) AS total_purchases,
        TO_CHAR(ROUND(CAST(amount AS NUMERIC), 2), 'FM999999999.00') AS amount,
        TO_CHAR(ROUND(CAST(total_amount AS NUMERIC), 2), 'FM999999999.00') AS total_amount,

        -- === PRODUCT DETAILS ===
        INITCAP(TRIM(product_category)) AS product_category,
        INITCAP(TRIM(REGEXP_REPLACE(product_brand, '\s+', ' ', 'g'))) AS product_brand,
        INITCAP(TRIM(REGEXP_REPLACE(product_type, '\s+', ' ', 'g'))) AS product_type,
        INITCAP(TRIM(feedback)) AS feedback,
        INITCAP(TRIM(shipping_method)) AS shipping_method,
        INITCAP(TRIM(payment_method)) AS payment_method,
        INITCAP(TRIM(order_status)) AS order_status,
        CAST(REGEXP_REPLACE(ratings::TEXT, '\.0$', '', 'g') AS INTEGER) AS ratings,
        INITCAP(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(products, '[,\.]+$', '', 'g'), '\s+', ' ', 'g'))) AS products

    FROM staging.retail_raw
),

validated AS (
    SELECT *
    FROM cleaned
    WHERE transaction_id IS NOT NULL
      AND customer_id IS NOT NULL
      AND LENGTH(phone) BETWEEN 10 AND 15
      AND age BETWEEN 0 AND 120
      AND ratings BETWEEN 0 AND 5
      AND gender IN ('Male', 'Female')
      AND income IN ('Low', 'Medium', 'High')
      AND customer_segment IN ('New', 'Regular', 'Premium')
      AND product_category IN ('Books','Clothing','Electronics','Grocery','Home Decor')
      AND feedback IN ('Average', 'Bad', 'Excellent', 'Good')
      AND shipping_method IN ('Express', 'Same-Day', 'Standard')
      AND payment_method IN ('Cash','Credit Card','Debit Card','PayPal')
      AND order_status IN ('Delivered', 'Pending', 'Processing', 'Shipped')
      AND date BETWEEN '1999-01-01' AND '2025-12-31'
)

INSERT INTO analytics.retail_clean (
    transaction_id, customer_id, name, email, phone,
    address, city, state, zipcode, country,
    age, gender, income, customer_segment,
    date, "year", month, time,
    total_purchases, amount, total_amount,
    product_category, product_brand, product_type, feedback,
    shipping_method, payment_method, order_status,
    ratings, products
)
SELECT *
FROM validated;




