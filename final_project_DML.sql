/***********************************************
** DATA ENGINEERING
** File:   Final_Project_DML
** Desc:   Populating the Chicago Food Inspections Dimensional model
** Auth:   Stephanie Smithson
** Date:   11/26/2023
************************************************/

# SET UP ENVIRONMENT
USE final_project;
SET SQL_SAFE_UPDATES = 0;

# POPULATE RISK TABLE
INSERT INTO risk(risk_desc) VALUES 
('Risk 1 (High)'),('Risk 2 (Medium)'),('Risk 3 (Low)'),('All');

SELECT * FROM risk;

# POPULATE FACILITY_TYPE TABLE
INSERT INTO facility_type(facility_type_name) (
SELECT DISTINCT facility_type_name
FROM raw_data
ORDER BY facility_type_name);

SELECT * FROM facility_type;

# POPULATE INSPECTION_TYPE TABLE
INSERT INTO inspection_type(inspection_type_desc) (
SELECT DISTINCT inspection_type
FROM raw_data
ORDER BY inspection_type);

SELECT * FROM inspection_type;

# POPULATE ADDRESS TABLE
INSERT INTO address(address, city, state, zip_code, latitude, longitude) (
SELECT 
	address, 
    city, 
    state, 
	CASE WHEN zip_code IS NULL OR zip_code = 0 THEN NULL ELSE CAST(zip_code AS UNSIGNED) END AS zip_code,
    CASE WHEN latitude IS NULL THEN NULL ELSE CAST(latitude AS DECIMAL(16,14)) END AS latitude,
    CASE WHEN longitude IS NULL THEN NULL ELSE CAST(longitude AS DECIMAL(16,14)) END AS longitude
FROM raw_data
GROUP BY address, city, state, zip_code, latitude, longitude
ORDER BY address);

SELECT * FROM address;

# POPULATE FACILITY TABLE
INSERT INTO facility(business_name, familiar_name, facility_type_code, address_id) (
SELECT 
	raw.business_name, 
    raw.familiar_name,
	ft.facility_type_code, 
    a.address_id
FROM raw_data raw
INNER JOIN facility_type ft ON raw.facility_type_name = ft.facility_type_name
INNER JOIN address a ON a.address = raw.address
GROUP BY 
	raw.business_name, 
    raw.familiar_name, 
    ft.facility_type_code, 
    a.address_id
ORDER BY raw.business_name);

SELECT * FROM facility;

# POPULATE INSPECTION TABLE
INSERT INTO inspection(facility_id, license, risk_code, inspection_date,
inspection_type_code, result, violations) (
SELECT
	f.facility_id,
    CASE WHEN LENGTH(raw.license) < 1 THEN NULL ELSE raw.license END as license,
    risk.risk_code,
    STR_TO_DATE(inspection_date, '%m/%d/%Y') as inspection_date,
    it.inspection_type_code,
    raw.result,
    raw.violations
FROM raw_data raw
LEFT JOIN address a ON raw.address = a.address
LEFT JOIN facility f ON f.address_id = a.address_id AND f.business_name = raw.business_name
AND f.familiar_name = raw.familiar_name
INNER JOIN risk risk ON risk.risk_desc = raw.risk_desc
INNER JOIN inspection_type it ON it.inspection_type_desc = raw.inspection_type
ORDER BY f.facility_id);

SELECT * FROM inspection;

# CHECK DATA WITH JOINS FOR ACCURACY

SELECT * FROM inspection i
INNER JOIN facility f ON i.facility_id = f.facility_id
INNER JOIN facility_type ft ON f.facility_type_code = ft.facility_type_code
INNER JOIN risk r ON i.risk_code = r.risk_code
INNER JOIN address a ON f.address_id = a.address_id
INNER JOIN inspection_type it ON i.inspection_type_code = it.inspection_type_code;