--1.Cleaning 'transaction_id'
TRUNCATE analytics.retail_clean;

INSERT INTO analytics.retail_clean (transaction_id)
SELECT CAST(CAST(transaction_id AS NUMERIC) AS BIGINT)::TEXT
FROM staging.retail_raw
WHERE transaction_id IS NOT NULL
    AND transaction_id <> '';




--2.Cleaning 'customer_id'
SELECT COUNT (*)
FROMCVEFVE staging.retail_raw
WHERE customer_id IS NULL OR customer_id = '';
----308 
---Profiling for duplicates
SELECT COUNT(*) AS total_ids,
       COUNT(DISTINCT customer_id) AS unique_ids
FROM staging.retail_raw;
----total_ids=30,2010 and unique_ids=86,766 

INSERT INTO analytics.retail_clean (customer_id)
SELECT
    CAST(
        REGEXP_REPLACE(TRIM(customer_id), '\.0[\s\r\n]*$', '')
        AS BIGINT
    )::TEXT
FROM staging.retail_raw
WHERE customer_id IS NOT NULL
  AND TRIM(customer_id) <> '';




--3.Cleaning 'name'
INSERT INTO analytics.retail_clean (name)
SELECT
    INITCAP(
        TRIM(
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    name,
                    '^(mr|mrs|ms|dr|miss|prof)\.?\s+',
                    '',
                    'i'
                ),
                '\s*(phd|md|dds|jr|sr)\.?$',
                '',
                'i'
            )
        )
    ) AS clean_name
FROM staging.retail_raw
WHERE name IS NOT NULL
  AND TRIM(name) <> '';



--4.Cleaning 'email'
INSERT INTO analytics.retail_clean (email)
SELECT
    CASE
        WHEN email IS NULL OR TRIM(email)='' THEN NULL
        WHEN TRIM(email)~'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN LOWER(TRIM(email))
        ELSE NULL
    END AS CLEAN_EMAIL  
FROM staging.retail_raw
WHERE email IS NOT NULL
AND TRIM(email)<>'';


--5.Cleaning 'phone'
INSERT INTO analytics.retail_clean (phone)
SELECT 
    TRIM(
        REGEXP_REPLACE(REGEXP_REPLACE(phone,'\.0$',''),'[^0-9]','','g'))::TEXT
FROM staging.retail_raw
WHERE phone IS NOT NULL
    AND TRIM(phone) <> ''
    AND LENGTH(REGEXP_REPLACE(phone, '[^0-9]', '', 'g')) BETWEEN 10 AND 15;

--6.Cleaning 'address'
INSERT INTO analytics.retail_clean (address)
SELECT
    INITCAP(TRIM(REGEXP_REPLACE(REGEXP_REPLACE(address,'[,\.]+$','','g'),'\s+$','','g')))
FROM   staging.retail_raw
WHERE address IS NOT NULL
AND TRIM(ADDRESS)<>'';

--7.Cleaning 'city'
INSERT INTO analytics.retail_clean (city)
SELECT
    INITCAP(
        TRIM(
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(city,'[,\.]','','g'),
                        '\s+$','','g'),'\s+',' ','g')))
FROM staging.retail_raw
WHERE city IS NOT NULL
AND TRIM(city)<>'';

--8.Cleaning 'state'
INSERT INTO analytics.retail_clean (state)
SELECT
    INITCAP(
        TRIM(
            REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(state,'[,\.]','','g'),
                        '\s+$','','g'),'\s+',' ','g')))
FROM staging.retail_raw
WHERE state IS NOT NULL
AND TRIM(state)<>'';

--9.Cleaning 'zip code'
INSERT INTO analytics.retail_clean(zipcode)
SELECT
    TRIM(REGEXP_REPLACE(REGEXP_REPLACE(zipcode::TEXT,'\.0$','','g'),'\s+$','','g'))
FROM
    staging.retail_raw
WHERE zipcode IS NOT NULL 
AND TRIM(zipcode)<>'';

--10.Cleaning 'country'
INSERT INTO analytics.retail_clean(country)
SELECT
    TRIM(UPPER(
                REGEXP_REPLACE
                    (REGEXP_REPLACE(
                            REGEXP_REPLACE(country,'[,\.]','','g'),
                                '\s+$','','g'),
                                    '\s+',' ','g')
                
    )
)
FROM staging.retail_raw
WHERE country IS NOT NULL 
AND TRIM(country)<>'';

--11.Cleaning 'age'
INSERT INTO analytics.retail_clean (age)
SELECT
    CAST(
        REGEXP_REPLACE(
            REGEXP_REPLACE(age::TEXT, '\.0$', '', 'g'),
            '\s+$', '', 'g'
        ) AS INTEGER
    ) AS clean_age
FROM staging.retail_raw
WHERE age IS NOT NULL
  AND TRIM(age::TEXT) <> ''
  AND CAST(REGEXP_REPLACE(age::TEXT, '\.0$', '', 'g') AS INTEGER) BETWEEN 0 AND 120;

--12.Cleaning 'gender'
INSERT INTO analytics.retail_clean (gender)
SELECT
    INITCAP(
        TRIM(
            (REGEXP_REPLACE(gender,'\s+',' ','g')
)))
FROM staging.retail_raw
WHERE gender IS NOT NULL
    AND TRIM(gender)<>''
    AND INITCAP(TRIM(gender)) IN ('Male', 'Female');


--13.Cleaning 'income'
INSERT INTO analytics.retail_clean (income)
SELECT
    INITCAP(
        TRIM(
            REGEXP_REPLACE(income,'\s+',' ','g')
                    )
)
FROM staging.retail_raw
WHERE income IS NOT NULL
    AND TRIM(income)<>''
    AND INITCAP(TRIM(income)) IN ('Low', 'Medium', 'High');

--14.Cleaning 'customer_segment'
INSERT INTO analytics.retail_clean (customer_segment)
SELECT
INITCAP(
    TRIM(
        REGEXP_REPLACE(customer_segment,'\s+',' ','g')
    )
)
FROM staging.retail_raw
WHERE customer_segment IS NOT NULL
    AND TRIM(customer_segment)<>''
    AND INITCAP(TRIM(customer_segment)) IN ('New', 'Premium', 'Regular');

--15.Cleaning 'date'
INSERT INTO analytics.retail_clean (date)
SELECT
    TO_DATE(TRIM(date), 'MM/DD/YYYY')
FROM staging.retail_raw
WHERE date IS NOT NULL
  AND TRIM(date) <> ''

--16.Cleaning 'year'
INSERT INTO analytics.retail_clean ("year")
SELECT
    CAST(
        TRIM(
            REGEXP_REPLACE("year"::TEXT, '\.0$', '', 'g')
        ) AS INTEGER
    ) AS clean_year
FROM staging.retail_raw
WHERE "year" IS NOT NULL
  AND TRIM("year"::TEXT) <> '';

--17.Cleaning 'month'
INSERT INTO analytics.retail_clean(month)
SELECT
    INITCAP(
        TRIM(month)
)
FROM staging.retail_raw
WHERE month IS NOT NULL
  AND TRIM(month) <> ''
  AND INITCAP(TRIM(month)) IN
      ('January','February','March','April','May','June',
       'July','August','September','October','November','December');

--18.Cleaning 'time'
INSERT INTO analytics.retail_clean (time)
SELECT
    TO_CHAR(
        TO_TIMESTAMP(TRIM(time), 'HH24:MI:SS'),
        'HH24:MI:SS'
    )::TIME AS clean_time
FROM staging.retail_raw
WHERE time IS NOT NULL
  AND TRIM(time) <> ''
  AND TRIM(time) ~ '^\d{1,2}:\d{2}:\d{2}$';


--19.Cleaning 'total_purchases'
INSERT INTO analytics.retail_clean (total_purchases)
SELECT
    TRIM(
        REGEXP_REPLACE(total_purchases::TEXT, '\.0$', '', 'g')
) 
FROM staging.retail_raw
WHERE total_purchases IS NOT NULL
  AND total_purchases<> ''
  AND total_purchases::TEXT ~ '^[0-9]+(\.0)?$';

--20. Cleaning 'amount'
INSERT INTO analytics.retail_clean (amount)
SELECT
    TRIM(
        TO_CHAR(ROUND(CAST(amount AS NUMERIC), 2), 'FM999999999.00')
    ) AS clean_amount
FROM staging.retail_raw
WHERE amount IS NOT NULL
  AND TRIM(amount::TEXT) <> ''
  AND amount::TEXT ~ '^[0-9]+(\.[0-9]+)?$';

--21. Cleaning 'total_amount'
INSERT INTO analytics.retail_clean (total_amount)
SELECT
    TRIM(
        TO_CHAR(ROUND(CAST(total_amount AS NUMERIC), 2), 'FM999999999.00')
    )
FROM staging.retail_raw
WHERE total_amount IS NOT NULL
  AND TRIM(total_amount::TEXT) <> ''
  AND total_amount::TEXT ~ '^[0-9]+(\.[0-9]+)?$';

--22. Cleaning ‘product_category’
INSERT INTO analytics.retail_clean (product_category)
SELECT
    INITCAP(
        TRIM(product_category)
    )
FROM staging.retail_raw
WHERE product_category IS NOT NULL 
AND product_category<>''
AND INITCAP(TRIM(product_category)) IN ('Books','Clothing','Electronics','Grocery','Home Decor');

--23. Cleaning ‘product_brand’
INSERT INTO analytics.retail_clean (product_brand)
SELECT
    INITCAP(
        TRIM(REGEXP_REPLACE(product_brand,'\s+',' ','g'))
    )
FROM staging.retail_raw
WHERE product_brand IS NOT NULL 
AND product_brand<>'';

--23.2. Cleaning ‘product_type’
INITCAP(TRIM(REGEXP_REPLACE(product_type, '\s+', ' ', 'g'))) AS product_type,
FROM staging.retail_raw
WHERE product_type IS NOT NULL 
AND product_type<>'';

--24. Cleaning ‘feedback’
INSERT INTO analytics.retail_clean(feedback)
SELECT
    INITCAP(
        TRIM(feedback)
)
FROM staging.retail_raw
WHERE feedback IS NOT NULL
  AND TRIM(feedback) <> ''
  AND INITCAP(TRIM(feedback)) IN
      ('Average', 'Bad', 'Excellent', 'Good');

--25. Cleaning ‘shipping_method’
INSERT INTO analytics.retail_clean(shipping_method)
SELECT
    INITCAP(
        TRIM(shipping_method)
)
FROM staging.retail_raw
WHERE shipping_method IS NOT NULL
  AND TRIM(shipping_method) <> ''
  AND INITCAP(TRIM(shipping_method)) IN
      ('Express', 'Same-Day', 'Standard');

--26. Cleaning ‘payment_method’
INSERT INTO analytics.retail_clean(payment_method)
SELECT
    INITCAP(
        TRIM(payment_method)
)
FROM staging.retail_raw
WHERE payment_method IS NOT NULL
  AND TRIM(payment_method) <> ''
  AND INITCAP(TRIM(payment_method)) IN
      ('Cash', 'Credit Card', 'Debit Card', 'PayPal');

--27. Cleaning ‘order_status’
INSERT INTO analytics.retail_clean(order_status)
SELECT
    INITCAP(
        TRIM(order_status)
)
FROM staging.retail_raw
WHERE order_status IS NOT NULL
  AND TRIM(order_status) <> ''
  AND INITCAP(TRIM(order_status)) IN
      ('Delivered', 'Pending', 'Processing', 'Shipped');

--28. Cleaning ‘ratings’      
INSERT INTO analytics.retail_clean (ratings)
SELECT
    CAST(
        REGEXP_REPLACE(ratings::TEXT, '\.0$', '', 'g') AS INTEGER
    ) AS clean_rating
FROM staging.retail_raw
WHERE ratings IS NOT NULL
  AND TRIM(ratings::TEXT) <> ''
  AND ratings::TEXT ~ '^[0-5]+(\.0)?$'
  AND CAST(REGEXP_REPLACE(ratings::TEXT, '\.0$', '', 'g') AS NUMERIC) BETWEEN 0 AND 5;

--29. Cleaning ‘products’
INSERT INTO analytics.retail_clean (products)
SELECT
    INITCAP(
        TRIM(
            REGEXP_REPLACE(
                REGEXP_REPLACE(products, '[,\.]+$', '', 'g'),
                '\s+', ' ', 'g'
            )
        )
    ) AS clean_product
FROM staging.retail_raw
WHERE products IS NOT NULL
  AND TRIM(products) <> '';



