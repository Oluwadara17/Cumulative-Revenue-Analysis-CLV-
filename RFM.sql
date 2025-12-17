WITH
  -- Step 1: Calculate RFM Values
  fre_and_mon AS (
    SELECT
      CustomerID,
      MAX(CAST(InvoiceDate AS date)) AS last_purchase_date,
      COUNT(DISTINCT InvoiceNo) AS frequency,
      SUM(COALESCE(Quantity, 0) * COALESCE(UnitPrice, 0)) AS monetary
    FROM
      `tc-da-1.turing_data_analytics.rfm`
    WHERE
      CAST(InvoiceDate AS date) BETWEEN '2010-12-01' AND '2011-12-01'
      AND CustomerID IS NOT NULL  -- Filter out rows with NULL CustomerID
      AND InvoiceNo IS NOT NULL   -- Filter out rows with NULL InvoiceNo
      AND Quantity IS NOT NULL    -- Filter out rows with NULL Quantity
      AND UnitPrice IS NOT NULL   -- Filter out rows with NULL UnitPrice
    GROUP BY
      CustomerID
  ),

  -- Step 2: Calculate Recency for each customer
  rfm_values AS (
    SELECT *,
      DATE_DIFF(DATE '2011-12-01', last_purchase_date, DAY) AS recency
    FROM fre_and_mon
    WHERE DATE_DIFF(DATE '2011-12-01', last_purchase_date, DAY) IS NOT NULL  -- Ensure recency is not NULL
  ),

  -- Step 3: Calculate RFM Quantiles (25th, 50th, and 75th percentiles)
  rfm_quantiles AS (
    SELECT
      APPROX_QUANTILES(COALESCE(monetary, 0), 4)[OFFSET(1)] AS m25,
      APPROX_QUANTILES(COALESCE(monetary, 0), 4)[OFFSET(2)] AS m50,
      APPROX_QUANTILES(COALESCE(monetary, 0), 4)[OFFSET(3)] AS m75,
      APPROX_QUANTILES(COALESCE(frequency, 0), 4)[OFFSET(1)] AS f25,
      APPROX_QUANTILES(COALESCE(frequency, 0), 4)[OFFSET(2)] AS f50,
      APPROX_QUANTILES(COALESCE(frequency, 0), 4)[OFFSET(3)] AS f75,
      APPROX_QUANTILES(COALESCE(recency, 0), 4)[OFFSET(1)] AS r25,
      APPROX_QUANTILES(COALESCE(recency, 0), 4)[OFFSET(2)] AS r50,
      APPROX_QUANTILES(COALESCE(recency, 0), 4)[OFFSET(3)] AS r75
    FROM rfm_values
  ),

  -- Step 4: Assign RFM Scores
  rfm_score AS (
    SELECT 
      CustomerID,
      recency,
      frequency, 
      monetary,
      r_score,
      f_score,
      m_score,
      CAST(ROUND((f_score + m_score) / 2.0) AS INT64) AS fm_score
    FROM (
      SELECT 
        rv.*,
        CASE 
          WHEN COALESCE(monetary, 0) <= q.m25 THEN 1
          WHEN COALESCE(monetary, 0) > q.m25 AND COALESCE(monetary, 0) <= q.m50 THEN 2
          WHEN COALESCE(monetary, 0) > q.m50 AND COALESCE(monetary, 0) <= q.m75 THEN 3
          WHEN COALESCE(monetary, 0) > q.m75 THEN 4
        END AS m_score,

        CASE 
          WHEN COALESCE(frequency, 0) <= q.f25 THEN 1
          WHEN COALESCE(frequency, 0) > q.f25 AND COALESCE(frequency, 0) <= q.f50 THEN 2
          WHEN COALESCE(frequency, 0) > q.f50 AND COALESCE(frequency, 0) <= q.f75 THEN 3
          WHEN COALESCE(frequency, 0) > q.f75 THEN 4
        END AS f_score,

        CASE 
          WHEN COALESCE(recency, 0) <= q.r25 THEN 4
          WHEN COALESCE(recency, 0) > q.r25 AND COALESCE(recency, 0) <= q.r50 THEN 3
          WHEN COALESCE(recency, 0) > q.r50 AND COALESCE(recency, 0) <= q.r75 THEN 2
          WHEN COALESCE(recency, 0) > q.r75 THEN 1
        END AS r_score
      FROM 
        rfm_values AS rv,
        rfm_quantiles AS q
    )
  )

-- Step 5: Segment customers based on their RFM scores
SELECT 
  CustomerID, 
  recency,
  frequency, 
  monetary,
  r_score,
  f_score,
  m_score,
  fm_score,
  CASE 
    WHEN (r_score = 4 AND fm_score = 4) THEN 'Champions'
    WHEN (r_score IN (3, 4) AND fm_score = 3) THEN 'Loyal Customers'
    WHEN (r_score = 4 AND fm_score IN (2, 3)) THEN 'Potential Loyalists'
    WHEN (r_score = 4 AND fm_score = 1) THEN 'Recent Customers'
    WHEN (r_score = 3 AND fm_score IN (2, 3)) THEN 'Promising'
    WHEN (r_score = 3 AND fm_score = 4) THEN 'High-Value, Recently Active'  -- Add this line
    WHEN (r_score = 2 AND fm_score IN (2, 3)) OR (r_score = 3 AND fm_score = 1) THEN 'Customers Needing Attention'
    WHEN (r_score = 2 AND fm_score = 1) THEN 'About to Sleep'
    WHEN (r_score = 2 AND fm_score = 4) OR (r_score = 1 AND fm_score = 3) THEN 'At Risk'
    WHEN (r_score = 1 AND fm_score = 4) THEN 'Cant Lose Them'
    WHEN (r_score = 1 AND fm_score IN (1, 2)) THEN 'Hibernating'
    WHEN (r_score = 1 AND fm_score = 1) THEN 'Lost'
  END AS rfm_segment 
FROM rfm_score
ORDER BY rfm_segment;
