# Supplier Performance Analysis

## Business Problem
A company buys materials from different suppliers, but it is difficult to evaluate and compare their performance across multiple parameters. Suppliers are assessed using factors such as Quality, Cost, Delivery, and Compliance, making it challenging to identify which suppliers perform best overall. In this Project my main objective was to evaluate suppliers based on these factors and create a Supplier Performance Scorecard that helps manager identify top-performing and underperforming suppliers and make better procurement decisions.

## Dashboard Preview
<img width="1282" height="719" alt="image" src="https://github.com/user-attachments/assets/f29de5a9-114c-44bf-8b44-daad12a7338a" />

## Dataset Used
[Procurement KPI Analysis Dataset](https://www.kaggle.com/datasets/shahriarkabir/procurement-kpi-analysis-dataset)

## Assumptions
1. I filtered the data to only include completed transactions where **status = delivered**. Pending and cancelled orders were excluded since the delivery process had not been fully completed.
2. Orders with missing delivery dates were excluded from the analysis because delivery performance could not be calculated accurately for those records. This ensured that average lead time metrics were based only on valid delivery information.
3. I didn't treat all metrics the same when calculating the supplier score. Since product quality is most important for the business, I gave it a weight of **35%**. Delivery performance was given **25%**, while **Savings** and **Compliance** were given **20% each**. This helped create a score that better reflects overall supplier performance.

## Insights
1. **Alpha Inc** is currently our top-performing vendor with an overall score of **70**. They maintain the lowest defect rate (**1.7%**) across the network while delivering solid **cost savings** of **8.0%**.
2. **Epsilon Group** is a close second at **69**, standing out as our fastest supplier with a **10-day lead time** and a near-perfect compliance rate of **98%**.
3. **Delta Logistics** is our weakest link with a score of **48**. Their performance is heavily dragged down by a high **10.1%** overall defect rate and a poor compliance record of just **61%**.
4. A closer look at the categories shows that Delta's quality issues are highly concentrated, spiking at a brutal **13.8%** defect rate in **Office Supplies** and **10.5%** in **Raw Materials**.

## Final Recommendations
1. We need to give more of our future orders to **Alpha Inc** and **Epsilon Group** because they are simply our most reliable partners when it comes to speed and overall quality.
2. We should put **Delta Logistics** on a strict performance review right away so they can figure out why they are facing so many delivery delays and mistakes.
3. To quickly save our inventory from bad quality, we should move the next **raw materials** orders from **Delta logistics** to **Epsilon Group**, and their **office supplies** orders to **Alpha Inc**. Both of these suppliers have almost zero quality issues in those categories.
