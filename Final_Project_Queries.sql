/***********************************************
** DATA ENGINEERING
** File:   Final_Project_Queries
** Desc:   Populating the Chicago Food Inspections Dimensional model
** Auth:   Stephanie Smithson
** Date:   11/26/2023
************************************************/

# Determine which facility type has the most failed inspections in 2023
SELECT 
	ft.facility_type_name, 
	COUNT(i.result) as '2023 Fail Count'
FROM inspection i
INNER JOIN facility f ON i.facility_id = f.facility_id
INNER JOIN facility_type ft ON f.facility_type_code = ft.facility_type_code
WHERE 
	i.result = 'Fail' 
    AND YEAR(i.inspection_date) = '2023'
GROUP BY ft.facility_type_name
ORDER BY 'Fail Count';

# Calculate average frequency of food inspections per business for 2023 by facility type
SELECT
	a.facility_type_name,
    a.inspection_year,
    AVG(a.inspection_count) AS average_inspection_count
FROM
	(SELECT
		ft.facility_type_name,
		f.facility_id,
		COUNT(i.inspection_id) AS inspection_count,
		YEAR(i.inspection_date) AS inspection_year
	FROM facility f
	INNER JOIN inspection i ON f.facility_id = i.facility_id
	INNER JOIN facility_type ft ON f.facility_type_code = ft.facility_type_code
	GROUP BY 
		f.facility_id, 
		inspection_year) a
WHERE inspection_year = '2023'
GROUP BY 
	a.facility_type_name, 
    a.inspection_year
ORDER BY average_inspection_count DESC;

# Which establishments have the most failed inspections in 2023?
SELECT
	f.familiar_name,
    a.address,
    ft.facility_type_name,
    SUM(CASE WHEN i.result = 'Fail' THEN 1 ELSE 0 END) AS fail_count
FROM facility f
INNER JOIN inspection i ON f.facility_id = i.facility_id
INNER JOIN facility_type ft ON f.facility_type_code = ft.facility_type_code
INNER JOIN address a ON f.address_id = a.address_id
WHERE YEAR(i.inspection_date) = '2023'
GROUP BY 
	f.familiar_name, 
	ft.facility_type_name, 
    a.address
HAVING fail_count > 0
ORDER BY fail_count DESC
LIMIT 25;

# Which establishments have been open the longest?
SELECT
	f.familiar_name,
    a.address,
    DATEDIFF(MIN(i.inspection_date), MAX(i.inspection_date))
FROM facility f
INNER JOIN address a ON f.address_id = f.address_id
INNER JOIN inspection i ON f.facility_id = i.facility_id
GROUP BY f.familiar_name, a.address;



