# Olist E-commerce Data Analysis (SQL Project)

# PROBLEM STATEMENT
To analyze customer behavior regarding purchases, satisfaction, and logistics quality within the Brazilian e-commerce platform Olist, identifying churn patterns, delivery bottlenecks, and other factors that may reveal opportunities for improvement.

# DATA SET UP
- Table creation and values assignamentation. *Date columns assigned as Varchar to prevent issues when loading data*.
- Load data to existing tables using load data infile while ensuring data compatibility on large datasets

# DATA CLEANING & TRANSFORMATION
- Validation of null values and uniqueness of potential primary keys
- Converting date variables from  Var to Datetime and applying  *if filter* as needed
- The columns customer_id, order_id, product_id and seller_id were selected as PK of the tables customers,orders, products and sellers respectively
- *Creation of auto-incrementing columns as Primary keys* for tables order_items, order_payments and order_reviews.
- Orphan records that prevented the creation of integrity constraints were identified and removed. This process was critical to ensuring that every transaction had a valid source:
*order_items → products*: Removal of records with product_ids that did not exist in the master catalog.

*order_items → sellers*: Removal of references to unregistered sellers.

*order_payments → orders*: Correction of discrepancies where payment records existed without an associated parent order.

## DATA ANALYSIS
# Logistics Performance and Potential Revenue Leakage

-To streamline data extraction regarding logistics performance and potential revenue leakage, a SQL database view was implemented to consolidate key columns from the `order_items` and `products` tables. 
- Subsequently, a JOIN operation was executed between this view and the `orders` table to retrieve the specific target metrics. 
- To ensure data integrity, conditional logic (using an `IF`/`CASE WHEN` statement) was applied to the `avg_delivery_delay` calculation. This logic filters the data to exclusively aggregate records where the actual `order_delivered_customer_date` exceeded the `order_estimated_delivery_date`. 
- This structural adjustment guarantees that early or on-time deliveries are treated as zero delay, thereby ensuring that the calculated `criticality_score` (Average Freight Cost × Average Delivery Delay) accurately flags genuine operational bottlenecks.

# Customer Retention & Churn Risk Analysis

- By executing a JOIN between the `orders` and `customers` tables, I aggregated the data to identify each customer's last purchase date, the overall maximum purchase date in the dataset, and their individual purchase frequency (based on distinct order IDs).
- I utilized a window function (`MAX() OVER ()`) within the inner subquery to dynamically capture the platform's absolute maximum timestamp, which served as our temporal anchor point.
- From this baseline, a derived table was used to compute the 'Recency' metric, calculating the exact number of days elapsed between each customer's last transaction and the platform's final recorded date.
- In the final outer layer, I implemented conditional classification logic (`CASE WHEN`) to segment the user base according to their Recency and Frequency profiles, assigning strategic business labels that enable marketing teams to instantly prioritize high-value retention campaigns.

# Seller Performance & Order Cancellation Risk

Tdo analyze seller cancellation rates and net revenue. The technical core of this analysis relies on conditional aggregation combined with the `COUNT(DISTINCT)` function, intentionally omitting the `ELSE` clause to force a `NULL` output for non-matching states; this mechanism ensures that on-time and canceled workflows are strictly segregated and that the final `cancelation_rate` reflects accurate operational realities instead of counting logical binary states. Additionally, a `HAVING` clause was implemented to filter the dataset at a threshold of `>= 50` total attempted orders, establishing a baseline of statistical relevance that eliminates low-volume noise and highlights long-term, systemic merchant behavior across the platform.

# Customer Dissatisfaction Drivers

- To diagnose the core drivers behind customer dissatisfaction, a database view (`Dissatisfaction_view`) was created to map product categories to their respective order items, which was subsequently joined with the `order_reviews` and `orders` tables. The analytical architecture utilizes conditional aggregation to isolate severe detractors (review scores of 1 and 2) against total distinct product reviews to calculate a precise dissatisfaction rate (`detractors_rate`). Furthermore, a conditional `AVG(IF(...))` statement was integrated to measure the exact average delivery delay exclusively for orders that breached their delivery dates; a `HAVING` clause filtering for categories with `>= 100` total reviews was applied to guarantee statistical significance, eliminating operational anomalies from low-volume segments.

# FinOps Analysis

- A financial operational analysis was built by executing an INNER JOIN between the `order_payments` and `orders` tables, grouping the metrics by `payment_type` to map transaction performance. The query utilizes conditional aggregation to break down total revenue into three distinct corporate buckets: historical dead capital (`confirmed_loss`), operational cash flow in transit (`rev_at_risk`), and net settled income (`net_liquid_rev`). By removing row-limiting restrictions and calculating a financial leakage rate against the total volume, the script provides a bulletproof sanity check regarding payment integrity and credit distribution across the marketplace ecosystem.


## INSIGHTS
# Logistics Performance and Potential Revenue Leakage

- **Top 5 Critical Categories Identified:** The analysis revealed that *eletrodomesticos_2*, *moveis_escritorio*, *pcs*, *moveis_sala*, and *artigos_de_natal* represent the highest risk profiles. These specific segments combine prolonged shipping delays with elevated freight costs, making them the primary drivers of potential customer churn and logistics dissatisfaction.

- **The Volume vs. Delay Paradox (High-Impact Segments):** While categories like *eletrodomesticos_2* and *pcs* exhibit high financial friction per order due to expensive freight, high-volume categories like *moveis_escritorio* scale this risk exponentially. A high delivery delay applied to a massive volume of orders heavily damages overall brand equity and triggers a substantial amount of customer service overhead.Although the Delivery Delay for *moveis_escritorio* is less than a day, the volume of orders *(1668)* in this category magnifies the negative impact. In aggregate metrics, small deviations in high-volume categories have a much greater financial and operational impact than longer delays in low-volume categories.

- **Strategic Recommendations:**
  - **Carrier Renegotiation:** Since these 5 categories suffer from high freight costs *and* poor SLA fulfillment, supply chain teams should audit the specific carriers assigned to these product dimensions (especially heavy/bulk items like furniture and electronics).
  - **Expectation Management:** Marketing and operations should adjust the estimated delivery windows shown to users for these categories on the front-end platform to minimize customer frustration while logistics are optimized.

  # Customer Retention & Churn Risk Analysis

- The segmentation reveals a massive operational opportunity concentrated in the *'At Churn Risk'* segment, which captures *19.26% of the total customer base (18,510 users)*. This specific group represents the highest return on investment (ROI) for retention efforts, as they are qualified historical buyers whose recent inactivity suggests early signs of disengagement; deploying a targeted, budget-conscious win-back campaign for this 20% is highly recommended. Conversely, 
- **Strategic Recommendations:**
Data exposes a critical structural vulnerability: *'Lost Customers'* account for a staggering *68.87% of the entire database (66,183 users)* who have been inactive for over 180 days. From a strategic and financial standpoint, marketing teams should strictly avoid allocating budget or launching reactivation campaigns toward this defunct 70%, as the customer acquisition cost (CAC) required to resurrect dead leads is statistically inefficient. 

# Seller Performance & Order Cancellation Risk

The query reveals an *exceptionally healthy merchant ecosystem*, as the maximum cancellation rate among statistically significant merchants peaks at *a minor ~5.6% (representing a baseline of 50 delivered orders against only 3 cancellations)*. From a risk-management perspective, this tightly controlled variance proves that Olist’s merchant screening and operational Service Level Agreements (SLAs) are highly effective at mitigating large-scale vendor friction before it impacts overall platform equity. 

# Customer Dissatisfaction Drivers

-The *fashion_roupa_masculina* segment leads the platform's friction with a staggering 26.12% detractor rate, despite maintaining a relatively low delivery delay of 0.51 days. This specific gap proves that customer dissatisfaction in apparel is driven by product quality, sizing issues, or catalog mismatches rather than supply chain failures.
- Segments like *moveis_escritorio* (22.76% detractors / 0.89 days delay) and *casa_conforto* (19.34% detractors / 1.19 days delay) show a direct, severe correlation between poor delivery logistics and negative reviews, with *casa_conforto* dangerously approaching the platform's historical delay ceiling. 

# FinOps Analysis

- Credit cards are the engine of Olist’s growth, anchoring *81.7% of total processed transactions (76,794 payments) and driving over 12.1 million reales in net liquid revenue*. Granular distribution metrics reveal a structural reliance on short-to-medium-term consumer financing rather than long-term credit, as evidenced by an average of *~4 installments, with 37% of all credit card transactions requiring 4 or more payment splits.* This behavior proves that while extreme credit horizons (such as 12 or 24 installments) are statistical outliers representing negligible volume, the availability of mid-term installment plans remains a critical conversion driver for the mid-market consumer base. While core channels maintain a healthy leakage rate below 1%, *vouchers* present a operational anomaly with a staggering 6.76% financial leakage rate.

## Olist FinOps Dashboard

-If you, dear reader, have Power BI deskop installed in your device, I kindly invite you to download the dashboard from this link conteined in my One Drive (https://drive.google.com/file/d/16SjWIeif5cLL3Sf7iwherKQ7ndyAowVH/view?usp=drive_link)
