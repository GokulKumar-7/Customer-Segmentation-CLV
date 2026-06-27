CREATE TABLE raw_transactions (
    invoice       TEXT,
    stock_code    TEXT,
    description   TEXT,
    quantity      INTEGER,
    invoice_date  TEXT,
    price         NUMERIC,
    customer_id   NUMERIC,
    country       TEXT
);
COPY raw_transactions
FROM '/Users/gokulkumar/Documents/customer-segmentation-clv/data/online_retail_II.csv'
WITH (FORMAT csv, HEADER true);
SELECT COUNT(*) FROM raw_transactions;

SELECT COUNT(*) AS missing_customer_id
FROM raw_transactions
WHERE customer_id IS NULL;

SELECT COUNT(*) AS cancellations
FROM raw_transactions
WHERE invoice LIKE 'C%';

SELECT COUNT(*) AS bad_quantity_or_price
FROM raw_transactions
WHERE quantity <= 0 OR price <= 0;

SELECT
    MIN(invoice_date) AS earliest,
    MAX(invoice_date) AS latest,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    COUNT(DISTINCT country)     AS distinct_countries
FROM raw_transactions;

SELECT
    segment,
    COUNT(*) AS customers,
    ROUND(AVG(recency))      AS avg_recency,
    ROUND(AVG(frequency), 1) AS avg_frequency,
    ROUND(AVG(monetary), 2)  AS avg_monetary
FROM customer_segments
GROUP BY segment
ORDER BY avg_monetary DESC;






