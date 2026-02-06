-- Query to get Revenue per Trip (Route)
-- Consistent with get_driver_salary_per_route.sql

SELECT
    ROW_NUMBER() OVER(ORDER BY s.start_time DESC) AS "STT",
    COALESCE(dispatcher.last_name || ' ' || dispatcher.first_name, dispatcher.first_name) AS "Dieu_phoi",
    CASE 
        WHEN dispatcher.region = 'southern' THEN 'Miền Nam' 
        WHEN dispatcher.region = 'northern' THEN 'Miền Bắc' 
        ELSE dispatcher.region 
    END AS "Nhan_su_mien",
    company.name AS "Ten_khach_hang",
    project.name AS "Du_an",
    CASE 
        WHEN project.region = 'southern' THEN 'Miền Nam' 
        WHEN project.region = 'northern' THEN 'Miền Bắc' 
        ELSE project.region 
    END AS "Mien_du_an",    
    route.name AS "Tuyen",
    s.code AS "Ma_ke_hoach",
    (s.start_time + INTERVAL '7 hours')::date AS "Ngay_bat_dau",
    s.start_time + INTERVAL '7 hours' AS "Thoi_gian_bat_dau",
    s.end_time + INTERVAL '7 hours' AS "Thoi_gian_ket_thuc",
    COALESCE(log_comp.name, 'Van Loi Logistics') AS "Don_vi_van_chuyen",
    CASE 
        WHEN log_comp.company_type = 'OWN' THEN 'Nội bộ' 
        ELSE '3PL' 
    END AS "Noi_bo_3pl",    
    CASE 
        WHEN v.truck_type = 'INTERNAL' THEN 'Xe nội bộ' 
        ELSE 'Xe 3PL' 
    END AS "Xe_noi_bo_3pl",
    s.license_plate AS "Bien_kiem_soat",
    mg.name AS "Tai_trong_xe",
    
    -- Revenue Information
    to_char(COALESCE(rev.route_price, 0), 'FM999,999,999,990') AS "Doanh_thu_chuyen",
    
    -- Customer Allowances (Aggregated from erp_schedules_customer_allowance)
    to_char(COALESCE(allowance_agg.total_customer_allowance, 0), 'FM999,999,999,990') AS "Phu_cap_khach_hang",
    
    to_char(COALESCE(rev.price_without_vat, 0), 'FM999,999,999,990') AS "Doanh_thu_chua_VAT",
    to_char(COALESCE(rev.fee_vat, 0), 'FM999,999,999,990') AS "VAT",
    to_char(COALESCE(rev.total_price, 0), 'FM999,999,999,990') AS "Tong_doanh_thu",
    
    s.note AS "Ghi_chu",
    CASE 
        WHEN s.end_time < (NOW() AT TIME ZONE 'UTC') THEN 'Hoàn tất'
        WHEN s.start_time <= (NOW() AT TIME ZONE 'UTC') AND s.end_time >= (NOW() AT TIME ZONE 'UTC') THEN 'Đang diễn ra'
        ELSE 'Chưa bắt đầu'
    END AS "Trang_thai_chuyen"

FROM public.erp_schedules s

-- Join related tables
LEFT JOIN public.erp_route route ON s.route_external_id = route.external_id
LEFT JOIN public.erp_projects project ON route.project_external_id = project.external_id
LEFT JOIN public.erp_company company ON project.company_external_id = company.external_id

LEFT JOIN public.erp_vehicle v ON s.vehicle_external_id = v.external_id
LEFT JOIN public.erp_vehicle_model_group mg ON s.model_group_external_id = mg.external_id

-- Join Dispatcher (Employee)
LEFT JOIN public.erp_employee dispatcher ON s.create_uid = dispatcher.user_external_id

-- Join Revenue Data
LEFT JOIN public.erp_schedules_customer_price rev ON s.external_id = rev.schedules_external_id

-- Aggregate Customer Allowances
LEFT JOIN (
    SELECT 
        schedules_customer_price_external_id,
        SUM(COALESCE(allowance_cost, 0) * COALESCE(quantity, 0)) AS total_customer_allowance
    FROM public.erp_schedules_customer_allowance
    GROUP BY schedules_customer_price_external_id
) allowance_agg ON rev.external_id = allowance_agg.schedules_customer_price_external_id

-- Join Logistic Company
LEFT JOIN public.erp_company log_comp ON s.logistic_company_external_id = log_comp.external_id

WHERE 
    s.is_cancel = false
    AND s.is_valid = true
    AND s.vehicle_external_id IS NOT NULL

ORDER BY s.start_time DESC;
