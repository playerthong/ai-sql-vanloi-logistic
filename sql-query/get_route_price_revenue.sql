-- Query to get route price revenue matching the template
-- Columns mapped:
-- ID bảng giá -> revenue.id
-- Tên bảng giá -> revenue.name
-- Giá xăng dầu -> revenue.gas_price
-- Start_date -> revenue.start_time
-- End_date -> revenue.end_time
-- company_external_id -> revenue.company_customer_external_id (Customer)
-- route_external_id -> route.external_id
-- ma_project -> project.code
-- ten_du_an -> project.name
-- tuyen -> route.name
-- ma_tuyen -> route.code
-- miền -> project.region
-- phan_loai_tuyen -> route.type
-- Prices -> Pivoted from erp_route_customer_price based on model_group name

SELECT
    revenue.external_id AS "ID",
    revenue.name AS "Name",
    revenue.gas_price AS "Gas price",
    revenue.start_time AS "Start_date",
    revenue.end_time AS "End_date",
    -- Correctly map Company (Internal) fields based on Project
    company.external_id AS "company_external_id",
    route.external_id AS "route_external_id",
    company.code AS "company_code", 
    project.code AS "ma_project",
    company.name AS "company_name",
    project.name AS "ten_du_an",
    route.name AS "tuyen",
    route.code AS "ma_tuyen",
    project.region AS "mien",
    route.type AS "phan_loai_tuyen",
    
    -- Pivot Model Groups to Columns
    -- Note: Ensure model group names match these exactly (Case Insensitive check used)
    MAX(CASE WHEN UPPER(mg.name) = 'VAN' THEN price.price ELSE 0 END) AS "VAN",
    MAX(CASE WHEN UPPER(mg.name) = '2T' THEN price.price ELSE 0 END) AS "2T",
    MAX(CASE WHEN UPPER(mg.name) = '5T' THEN price.price ELSE 0 END) AS "5T",
    MAX(CASE WHEN UPPER(mg.name) = '8T' THEN price.price ELSE 0 END) AS "8T",
    MAX(CASE WHEN UPPER(mg.name) = '15T' THEN price.price ELSE 0 END) AS "15T",
    MAX(CASE WHEN UPPER(mg.name) = 'CONT' THEN price.price ELSE 0 END) AS "CONT",
    
    -- Note column mentioned in template
    'Lay cac external ID (chu y)' AS "Luu y"

FROM public.erp_company_customer_revenue revenue

-- Join to Link Table
JOIN public.erp_company_customer_route_price link ON revenue.external_id = link.company_customer_revenue_external_id AND link.is_deleted = false

-- Join to Route Info
JOIN public.erp_route route ON link.route_external_id = route.external_id AND route.is_deleted = false

-- Join to Project Info
LEFT JOIN public.erp_projects project ON route.project_external_id = project.external_id

-- Join to Internal Company Info
LEFT JOIN public.erp_company company ON project.company_external_id = company.external_id

-- Join to Prices (Left Join to show routes even if some prices are missing)
LEFT JOIN public.erp_route_customer_price price ON 
    link.external_id = price.company_customer_route_price_external_id 
    AND route.external_id = price.route_external_id 
    AND price.is_deleted = false

-- Join to Model Groups to identify vehicle types
LEFT JOIN public.erp_vehicle_model_group mg ON price.model_group_external_id = mg.external_id

WHERE revenue.is_deleted = false 
  -- Optional: Filter by specific price list ID or Date if needed
  -- AND revenue.id = ...

GROUP BY 
    revenue.external_id,
    revenue.name,
    revenue.gas_price,
    revenue.start_time,
    revenue.end_time,
    company.external_id,
    company.code,
    company.name,
    route.external_id,
    project.code,
    project.name,
    route.name,
    route.code,
    project.region,
    route.type
ORDER BY revenue.external_id, route.code;
