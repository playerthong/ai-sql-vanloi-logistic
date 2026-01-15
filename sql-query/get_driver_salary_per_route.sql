-- Query to get Driver Salary per Route based on Template
-- Mapping:
-- STT -> ROW_NUMBER()
-- ĐIỀU PHỐI -> (Unknown, using create_uid or similar if available, else NULL)
-- NHÂN SỰ MIỀN -> project.region
-- TÊN KHÁCH HÀNG -> company.name
-- DỰ ÁN -> project.name
-- MIỀN DỰ ÁN -> project.region
-- TUYẾN -> route.name
-- THỜI GIAN BẮT ĐẦU -> s.start_time
-- THỜI GIAN KẾT THÚC -> s.end_time
-- ĐƠN VỊ VẬN CHUYỂN -> (Based on vehicle owner/company)
-- NỘI BỘ / 3PL -> CASE WHEN vehicle.flag_3pl THEN '3PL' ELSE 'NỘI BỘ' END
-- BIỂN KIỂM SOÁT -> s.license_plate
-- TÀI CHÍNH (Main Driver) -> s.first_driver_name
-- MSNV TÀI CHÍNH -> d1.external_code
-- SĐT TÀI CHÍNH -> s.first_driver_phone
-- LƯƠNG TÀI CHÍNH -> cost.route_cost (Assuming route cost is assigned to main driver/trip)
-- TẢI TRỌNG XE -> mg.name
-- TÀI PHỤ -> s.second_driver_name
-- SĐT TÀI PHỤ -> s.second_driver_phone
-- MSNV TÀI PHỤ -> d2.external_code
-- LƯƠNG TÀI PHỤ -> 0 (Not explicitly separated in standard cost table)
-- GHI CHÚ -> s.note
-- TRẠNG THÁI CHUYẾN -> s.status
-- MÃ KẾ HOẠCH -> s.code

WITH AllowanceSummary AS (
    SELECT 
        slc.schedules_external_id,
        
        -- Allowance 1 Quantity (template_allowance_id = 1)
        SUM(CASE WHEN sla.template_allowance_id = 1 THEN sla.quantity ELSE 0 END) AS allowance_1_quantity,
        
        -- Allowance 2 Quantity (template_allowance_id = 2)
        SUM(CASE WHEN sla.template_allowance_id = 2 THEN sla.quantity ELSE 0 END) AS allowance_2_quantity,
        
        -- Loading Allowance Cost (template_allowance_id IN (3, 4, 12, 13, 14))
        SUM(CASE WHEN sla.template_allowance_id IN (3, 4, 12, 13, 14) THEN sla.allowance_cost * sla.quantity ELSE 0 END) AS loading_allowance_cost,

        -- Standby Salary (Lương sơ cua - template_allowance_id IN (9, 10))
        SUM(CASE WHEN sla.template_allowance_id IN (9, 10) THEN sla.allowance_cost * sla.quantity ELSE 0 END) AS standby_allowance_cost,

        -- Other Allowances (Total - Allowance 1 - Allowance 2 - Loading Allowance - Standby Salary)
        SUM(CASE WHEN sla.template_allowance_id NOT IN (1, 2, 3, 4, 9, 10, 12, 13, 14) OR sla.template_allowance_id IS NULL THEN sla.allowance_cost * sla.quantity ELSE 0 END) AS other_allowance_cost
        
    FROM public.erp_schedules_logistic_allowance sla
    JOIN public.erp_schedules_logistic_cost slc ON sla.schedules_logistic_cost_external_id = slc.external_id
    GROUP BY slc.schedules_external_id
)

SELECT
    ROW_NUMBER() OVER(ORDER BY s.start_time DESC) AS "STT",
    COALESCE(dispatcher.last_name || ' ' || dispatcher.first_name, dispatcher.first_name) AS "Dieu_Phoi",
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
        WHEN v.truck_type = 'INTERNAL' THEN 'Noi bo' 
        ELSE '3PL' 
    END AS "noi_bo_3pl",
    s.license_plate AS "Bien_kiem_soat",
    -- Vehicle Load / Group
    mg.name AS "Tai_trong_xe",    
    -- Main Driver Info
    d1.name AS "Tai_chinh",
    d1.external_code AS "Msnv_tai_chinh",
    d1.phone AS "Sdt_tai_chinh",
    to_char(COALESCE(cost.route_cost, 0), 'FM999,999,999,990') AS "Luong_tai_chinh",
    
    -- Second Driver Info
    d2.name AS "Tai_phu",
    d2.phone AS "Sdt_tai_phu",
    d2.external_code AS "Msnv_tai_phu",
    to_char(CASE 
        WHEN d2.external_id IS NOT NULL THEN COALESCE(cost.route_cost, 0) 
        ELSE 0 
    END, 'FM999,999,999,990') AS "Luong_tai_phu",
    
    s.note AS "Ghi_chu",
    CASE 
        WHEN s.end_time < (NOW() AT TIME ZONE 'UTC') THEN 'Hoan tat'
        WHEN s.start_time <= (NOW() AT TIME ZONE 'UTC') AND s.end_time >= (NOW() AT TIME ZONE 'UTC') THEN 'Dang dien ra'
        ELSE 'Chua bat dau'
    END AS "Trang_thai_chuyen",
    
    -- Allowances (Specific ID=1)
    CASE WHEN als.allowance_1_quantity > 0 THEN 'Luu dem' ELSE NULL END AS "Phu_cap_1",
    als.allowance_1_quantity AS "Sl_phu_cap_1",
    to_char(COALESCE(cost.allowance_pc1, 0), 'FM999,999,999,990') AS "Phu_cap_1_thanh_tien",

    -- Allowances (Specific ID=2)
    CASE WHEN als.allowance_2_quantity > 0 THEN 'Rai diem' ELSE NULL END AS "Phu_cap_2",
    als.allowance_2_quantity AS "Sl_phu_cap_2",
    to_char(COALESCE(cost.allowance_pc2, 0), 'FM999,999,999,990') AS "Phu_cap_2_thanh_tien",
    
    -- Summaries
    to_char(COALESCE(als.loading_allowance_cost, 0), 'FM999,999,999,990') AS "Tong_phu_cap_boc_xep",
    to_char(COALESCE(als.standby_allowance_cost, 0), 'FM999,999,999,990') AS "Tong_luong_so_cua",
    to_char((COALESCE(cost.other_allowance, 0) - COALESCE(als.loading_allowance_cost, 0) - COALESCE(als.standby_allowance_cost, 0)), 'FM999,999,999,990') AS "Tong_phu_cap_con_lai",
    to_char(COALESCE(cost.total_allowance_cost, 0), 'FM999,999,999,990') AS "Tong_phu_cap",
    
    to_char(COALESCE(cost.route_cost, 0), 'FM999,999,999,990') AS "Luong_tuyen",
    to_char((
        COALESCE(cost.route_cost, 0) + -- Lương Tài 1
        CASE WHEN d2.external_id IS NOT NULL THEN COALESCE(cost.route_cost, 0) ELSE 0 END + -- Lương Tài 2
        COALESCE(cost.total_allowance_cost, 0) -- Tổng Phụ Cấp
    ), 'FM999,999,999,990') AS "Tong_luong"

FROM public.erp_schedules s

-- Join related tables
LEFT JOIN public.erp_route route ON s.route_external_id = route.external_id
LEFT JOIN public.erp_projects project ON route.project_external_id = project.external_id
LEFT JOIN public.erp_company company ON project.company_external_id = company.external_id

LEFT JOIN public.erp_vehicle v ON s.vehicle_external_id = v.external_id
LEFT JOIN public.erp_vehicle_model_group mg ON s.model_group_external_id = mg.external_id

-- Join Dispatcher (Employee) - Linked via User UUID
LEFT JOIN public.erp_employee dispatcher ON s.create_uid = dispatcher.user_external_id

-- Join Drivers
LEFT JOIN public.erp_driver d1 ON s.first_driver_external_id = d1.external_id
LEFT JOIN public.erp_driver d2 ON s.second_driver_external_id = d2.external_id

-- Join Costs
LEFT JOIN public.erp_schedules_logistic_cost cost ON s.external_id = cost.schedules_external_id

-- Join Allowance Summary
LEFT JOIN AllowanceSummary als ON s.external_id = als.schedules_external_id

-- Join Logistic Company
LEFT JOIN public.erp_company log_comp ON s.logistic_company_external_id = log_comp.external_id

WHERE 
    s.is_cancel = false
    -- Add Date Range Filter if needed
    AND s.start_time >= '2026-01-01'
    AND s.is_valid = true
    AND s.vehicle_external_id IS NOT NULL
    AND als.allowance_1_quantity > 0

ORDER BY s.start_time DESC;
