# Customer Segmentation & Customer Lifetime Value — Online Retail II

**End-to-end customer analytics in PostgreSQL, Python & Power BI | UK Online Retailer | Dec 2009 – Dec 2011**

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-SQL-blue?logo=postgresql)
![Python](https://img.shields.io/badge/Python-3.x-blue?logo=python)
![scikit-learn](https://img.shields.io/badge/scikit--learn-KMeans-orange?logo=scikitlearn)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi)
![License](https://img.shields.io/badge/License-Educational-lightgrey)

---

## Overview

This project segments the customers of a UK-based online retailer to identify **where customer value is concentrated and how marketing should act on it**. More than 1.06 million transactions are cleaned and reduced to a customer-level view, segmented using the **RFM (Recency, Frequency, Monetary)** framework, independently validated with **K-Means clustering**, and assigned a projected **Customer Lifetime Value (CLV)**.

It is built deliberately across the three tools most used in business, marketing, and insight analytics roles — **SQL for data engineering, Python for modelling, and Power BI for the interactive dashboard** — to demonstrate the full analytical workflow from raw data to business recommendation.

---

## Business Questions

1. Which customer segments drive the most value for the retailer?
2. How do the purchasing behaviours of those segments differ?
3. Which customers are most at risk of being lost, and what is that worth in future profit?
4. What specific marketing action should be taken for each segment?

---

## Methodology

### Pipeline

| Stage | Tool | Output |
| --- | --- | --- |
| Load & stage raw data | PostgreSQL | `raw_transactions` (1,067,371 rows) |
| Data-quality profiling | PostgreSQL | Quantified missing IDs, cancellations, invalid rows |
| Cleaning | PostgreSQL | `clean_transactions` (805,549 valid sales lines) |
| RFM scoring & segmentation | PostgreSQL (`NTILE`, `CASE`) | `customer_segments` (5,878 customers) |
| Clustering & CLV modelling | Python (pandas, scikit-learn) | Validated segments + `customer_segments.csv` |
| Visualisation | Power BI | Interactive dashboard |

### Data Preparation

Three categories of records were removed before analysis, each a documented decision:

| Issue | Rows | Share | Action |
| --- | --- | --- | --- |
| Missing customer ID | 243,007 | 22.8% | Removed — cannot attribute to a customer |
| Cancellations (`invoice` starts with `C`) | 19,494 | 1.8% | Removed — not completed sales |
| Non-positive quantity or price | 25,700 | 2.4% | Removed — returns, adjustments, errors |

After cleaning, **805,549 valid sales lines** across **5,878 identifiable customers** remained.

### RFM Scoring

Each customer was scored 1–5 on Recency, Frequency, and Monetary value using SQL `NTILE(5)` window functions (recency reverse-scored), then mapped via a `CASE` expression to seven business-readable segments: *Champions, Loyal Customers, Potential Loyalists, New / Promising, At Risk, High-Value At Risk,* and *Hibernating.*

### Cluster Validation

An independent **K-Means** clustering (k = 4, chosen via the elbow method and silhouette score) was run in Python on log-transformed, standardised R/F/M values, then cross-tabulated against the rule-based segments to test whether the segmentation reflected genuine structure in the data.

### Customer Lifetime Value

A transparent CLV was estimated per customer as `average order value × annualised frequency × profit margin × expected lifespan`, using stated assumptions of a **20% profit margin** and a **3-year customer lifespan**.

---

## Dashboard

<img width="2074" height="1246" alt="Screenshot 2026-06-27 190650" src="https://github.com/user-attachments/assets/5596c44a-0113-47a2-8780-fca9950e9cc4" />


*Interactive Power BI dashboard: KPI summary, revenue / customers / CLV by segment, an RFM heatmap, and segment & cluster slicers for self-serve filtering.*

---

## Key Findings

### Value is highly concentrated

The **Champions** segment is ~25% of customers (1,478 of 5,878) but generates **~69% of revenue** (£12.3M of £17.74M). The top three segments together account for **~91% of revenue**. By contrast, *Hibernating* customers are the largest group by headcount (1,534) yet contribute only ~3% of revenue.

### A high-value segment is quietly disengaging

Ranked by **projected lifetime value**, the **High-Value At Risk** segment is second only to Champions (avg CLV £937), ahead of Loyal Customers — yet these 354 customers have not purchased in ~343 days. This represents approximately **£332,000 of future profit at risk**, and is the project's primary, most quantifiable opportunity.

### Two independent methods agree

K-Means independently reproduced the rule-based structure, with strong agreement at the extremes 1,067 of 1,478 Champions fell into the elite cluster, and 1,513 of 1,534 Hibernating customers into the lapsed cluster. Agreement loosened among mid-tier segments, as expected where the boundaries are genuinely gradual.

### A healthy RFM signature

The recency × frequency grid shows a clear diagonal: the two densest cells sit in opposite corners (567 customers high on both, 520 low on both), confirming that recency and frequency move together.

---

## Recommendations

| Segment | Recommended action | Priority |
| --- | --- | --- |
| High-Value At Risk | Urgent personalised win-back / reactivation offer | Urgent |
| Champions | VIP perks, early access, referral & review requests | Retain |
| Loyal Customers | Upsell / cross-sell, loyalty tiering | Grow |
| At Risk | Re-engagement reminders with a light incentive | Monitor |
| Potential Loyalists / New | Second-purchase incentive, onboarding journey | Develop |
| Hibernating | Low-cost reactivation only, or suppress to protect margin | Low |

---

## Data Source

**UCI Online Retail II** — all transactions for a UK-based, registered, non-store online giftware retailer (1 Dec 2009 – 9 Dec 2011).

- UCI Machine Learning Repository: https://archive.ics.uci.edu/dataset/502/online+retail+ii
- Kaggle mirror: https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci

> Note: The raw dataset is excluded from this repo via `.gitignore` due to size. The processed customer-level output, `reports/customer_segments.csv`, is included.

---

## Tech Stack

| Tool | Purpose |
| --- | --- |
| PostgreSQL / DBeaver | Data cleaning, RFM aggregation & scoring (SQL) |
| Python | Modelling environment |
| pandas / NumPy | Data manipulation |
| scikit-learn | K-Means clustering, scaling |
| Matplotlib | Elbow / silhouette diagnostics |
| Power BI | Interactive dashboard |

---

## Repository Structure

```
customer-segmentation-clv/
├── sql/
│   ├── 01_create_and_load.sql      # staging table + bulk load
│   ├── 02_exploration.sql          # data-quality profiling
│   ├── 03_clean.sql                # cleaned transactions table
│   └── 04_rfm.sql                  # RFM, NTILE scoring & named segments
├── notebooks/
│   ├── 00_prepare_data.ipynb       # merge Excel sheets → CSV
│   └── 01_segmentation_modelling.ipynb  # KMeans validation + CLV
├── reports/
│   └── customer_segments.csv       # customer-level output (dashboard source)
├── dashboard/
│   ├── customer-segmentation-clv.pbix
│   └── dashboard.png
├── report/
│   └── Customer_Segmentation_CLV.docx   # full written report
└── .gitignore
```

---

## Conclusion

This project converts more than a million raw transactions into a clear, defensible answer to a real business question. A quarter of customers drive roughly two-thirds of revenue; a small, historically valuable segment is disengaging and represents the single largest retention opportunity; and a differentiated, segment-specific marketing strategy is both justified by the data and reinforced by the agreement of two independent methods. The accompanying Power BI dashboard makes these segments monitorable on an ongoing basis.
