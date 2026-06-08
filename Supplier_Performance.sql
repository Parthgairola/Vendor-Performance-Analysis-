-- Base Table
SELECT*
FROM procurement


												--	DATA Cleaning and PRE-CHECKS


														
UPDATE procurement
SET supplier = REPLACE(supplier, '_', ' ');


										
-- No Duplicates Found

SELECT *, COUNT(*)
FROM procurement
GROUP BY 
po_id, supplier, order_date, delivery_date, item_category,
order_status, quantity, unit_price,
negotiated_price, defective_units, compliance
HAVING COUNT(*) > 1;


-- 87 Missing values in delivery_date_ , 136 Missings values in defective_units
SELECT
COUNT(*) FILTER (WHERE po_id IS NULL) AS po_id_nulls,
COUNT(*) FILTER (WHERE supplier IS NULL) AS supplier_nulls,
COUNT(*) FILTER (WHERE order_date IS NULL) AS order_date_nulls,
COUNT(*) FILTER (WHERE delivery_date IS NULL) AS delivery_date_nulls,
COUNT(*) FILTER (WHERE item_category IS NULL) AS item_category_nulls,
COUNT(*) FILTER (WHERE order_status IS NULL) AS order_status_nulls,
COUNT(*) FILTER (WHERE quantity IS NULL) AS quantity_nulls,
COUNT(*) FILTER (WHERE unit_price IS NULL) AS unit_price_nulls,
COUNT(*) FILTER (WHERE negotiated_price IS NULL) AS negotiated_price_nulls,
COUNT(*) FILTER (WHERE defective_units IS NULL) AS defective_units_nulls,
COUNT(*) FILTER (WHERE compliance IS NULL) AS compliance_nulls
FROM procurement;



														-- DATA ANALYSIS

SELECT*
FROM procurement


-- Calculated KPI's


CREATE VIEW vw_kpi AS (
SELECT 
	order_date,
	COALESCE(SUM(negotiated_price * quantity), 0) AS total_spend,
	COALESCE(SUM(defective_units), 0) / SUM(quantity) AS avg_defect_rate,
	COALESCE(AVG(delivery_date - order_date), 0) AS avg_lead_time,
	COALESCE(SUM(unit_price * quantity) - SUM(negotiated_price * quantity), 0) AS total_savings,
	COALESCE(SUM(CASE WHEN compliance = 'Yes' THEN 1 ELSE 0 END)::NUMERIC / NULLIF(COUNT(*), 0), 0) AS compliance_rate
FROM procurement
WHERE order_status = 'Delivered' AND delivery_date IS NOT NULL
GROUP BY order_date
)


-- Calculated category wise quality (defect_rate) performance of suppliers


CREATE VIEW vw_supplier_category_performance AS (
SELECT 
	order_date,
	supplier,
	item_category,
	COALESCE(SUM(defective_units), 0) / SUM(quantity) AS defect_rate
FROM procurement
WHERE order_status = 'Delivered' AND delivery_date IS NOT NULL
GROUP BY order_date,supplier , item_category
)




CREATE VIEW vw_supplier_scorecard AS (

WITH supplier_metrics AS (
SELECT 
	supplier,
	order_date,
	COALESCE(SUM(negotiated_price * quantity), 0) AS total_spend,
	COALESCE(SUM(defective_units), 0) / SUM(quantity) AS defect_rate,
	COALESCE(AVG(delivery_date - order_date), 0) AS avg_lead_time,
	COALESCE((SUM(unit_price * quantity) - SUM(negotiated_price * quantity)) / NULLIF(SUM(unit_price * quantity), 0), 0) AS savings_percent,
	COALESCE(SUM(CASE WHEN compliance = 'Yes' THEN 1 ELSE 0 END)::NUMERIC / NULLIF(COUNT(*), 0), 0) AS compliance_rate
FROM procurement
WHERE order_status = 'Delivered' AND delivery_date IS NOT NULL
GROUP BY supplier , order_date

)
,

--Normalized Scores to get same scale
normalized_scores AS (
SELECT 
	order_date,
	supplier,
	total_spend,
	defect_rate,
	avg_lead_time,
	savings_percent,
	compliance_rate,
	(MAX(defect_rate) OVER() - defect_rate) / (MAX(defect_rate) OVER() - MIN(defect_rate) OVER()) AS defect_score,
	(MAX(avg_lead_time) OVER() - avg_lead_time) / (MAX(avg_lead_time) OVER() - MIN(avg_lead_time) OVER()) AS lead_time_score,
	(savings_percent - MIN(savings_percent) OVER()) / (MAX(savings_percent) OVER() - MIN(savings_percent) OVER()) AS savings_score,
	(compliance_rate - MIN(compliance_rate) OVER()) / (MAX(compliance_rate) OVER() - MIN(compliance_rate) OVER()) AS compliance_score
	
FROM supplier_metrics
)


-- Given weights to scores as not all parameters are equally important


SELECT 
	order_date,
	supplier,
	total_spend,
	defect_rate,
	avg_lead_time,
	savings_percent,
	compliance_rate,
	((defect_score * 0.35) + (lead_time_score*0.25) + (savings_score*0.20)+(compliance_score*0.20)) *100 AS overall_score
FROM normalized_scores

)


-- FINAL Views

SELECT*
FROM vw_kpi


SELECT*
FROM vw_supplier_category_performance


SELECT*
FROM vw_supplier_scorecard


