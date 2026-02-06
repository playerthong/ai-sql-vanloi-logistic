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


WITH ScheduleAllowances AS (
    SELECT 
        slc.schedules_external_id,
        MAX(CASE WHEN rn = 1 THEN cla.name END) AS allowance_name_1,
        MAX(CASE WHEN rn = 1 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_1,
        MAX(CASE WHEN rn = 2 THEN cla.name END) AS allowance_name_2,
        MAX(CASE WHEN rn = 2 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_2,
        MAX(CASE WHEN rn = 3 THEN cla.name END) AS allowance_name_3,
        MAX(CASE WHEN rn = 3 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_3,
        MAX(CASE WHEN rn = 4 THEN cla.name END) AS allowance_name_4,
        MAX(CASE WHEN rn = 4 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_4,
        MAX(CASE WHEN rn = 5 THEN cla.name END) AS allowance_name_5,
        MAX(CASE WHEN rn = 5 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_5,
        MAX(CASE WHEN rn = 6 THEN cla.name END) AS allowance_name_6,
        MAX(CASE WHEN rn = 6 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_6,
        MAX(CASE WHEN rn = 7 THEN cla.name END) AS allowance_name_7,
        MAX(CASE WHEN rn = 7 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_7,
        MAX(CASE WHEN rn = 8 THEN cla.name END) AS allowance_name_8,
        MAX(CASE WHEN rn = 8 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_8,
        MAX(CASE WHEN rn = 9 THEN cla.name END) AS allowance_name_9,
        MAX(CASE WHEN rn = 9 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_9,
        MAX(CASE WHEN rn = 10 THEN cla.name END) AS allowance_name_10,
        MAX(CASE WHEN rn = 10 THEN (sla.allowance_cost * COALESCE(sla.quantity, 1)) END) AS allowance_amount_10
    FROM 
        public.erp_schedules_logistic_cost slc
    JOIN 
        public.erp_schedules_logistic_allowance sla ON slc.external_id = sla.schedules_logistic_cost_external_id
    JOIN 
        public.erp_company_logistic_allowance cla ON sla.company_logistic_allowance_external_id = cla.external_id
    JOIN (
        SELECT 
            sla_inner.id,
            ROW_NUMBER() OVER (PARTITION BY slc_inner.schedules_external_id ORDER BY sla_inner.id) as rn
        FROM 
            public.erp_schedules_logistic_cost slc_inner
        JOIN 
            public.erp_schedules_logistic_allowance sla_inner ON slc_inner.external_id = sla_inner.schedules_logistic_cost_external_id
    ) ranked ON sla.id = ranked.id
    GROUP BY 
        slc.schedules_external_id
),

ScheduleSurcharges AS (
    SELECT 
        slc.schedules_external_id,
        MAX(CASE WHEN rn = 1 THEN ts.name END) AS surcharge_name_1,
        MAX(CASE WHEN rn = 1 THEN sls.surcharge END) AS surcharge_amount_1,
        MAX(CASE WHEN rn = 2 THEN ts.name END) AS surcharge_name_2,
        MAX(CASE WHEN rn = 2 THEN sls.surcharge END) AS surcharge_amount_2,
        MAX(CASE WHEN rn = 3 THEN ts.name END) AS surcharge_name_3,
        MAX(CASE WHEN rn = 3 THEN sls.surcharge END) AS surcharge_amount_3,
        MAX(CASE WHEN rn = 4 THEN ts.name END) AS surcharge_name_4,
        MAX(CASE WHEN rn = 4 THEN sls.surcharge END) AS surcharge_amount_4,
        MAX(CASE WHEN rn = 5 THEN ts.name END) AS surcharge_name_5,
        MAX(CASE WHEN rn = 5 THEN sls.surcharge END) AS surcharge_amount_5
    FROM 
        public.erp_schedules_logistic_cost slc
    JOIN 
        public.erp_schedules_logistic_surcharge sls ON slc.external_id = sls.schedules_logistic_cost_external_id
    JOIN 
        public.erp_template_surcharge ts ON sls.template_surcharge_id = ts.id
    JOIN (
        SELECT 
            sls_inner.id,
            ROW_NUMBER() OVER (PARTITION BY slc_inner.schedules_external_id ORDER BY sls_inner.id) as rn
        FROM 
            public.erp_schedules_logistic_cost slc_inner
        JOIN 
            public.erp_schedules_logistic_surcharge sls_inner ON slc_inner.external_id = sls_inner.schedules_logistic_cost_external_id
    ) ranked ON sls.id = ranked.id
    GROUP BY 
        slc.schedules_external_id
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
        WHEN log_comp.company_type = 'OWN' THEN 'Nội bộ' 
        ELSE '3PL' 
    END AS "Noi_bo_3pl",    
    CASE 
        WHEN v.truck_type = 'INTERNAL' THEN 'Xe Nội bộ' 
        ELSE 'Xe 3PL' 
    END AS "Xe_noi_bo_3pl",
    s.license_plate AS "Bien_kiem_soat",
    -- Vehicle Load / Group
    mg.name AS "Tai_trong_xe",    
    
    -- ==========================================================
    -- MAIN DRIVER INFO & SALARY
    -- ==========================================================
    d1.name AS "Tai_chinh",
    d1.external_code AS "Msnv_tai_chinh",
    d1.phone AS "Sdt_tai_chinh",
    
    -- Main Driver Salary (Route Cost usually goes to Main Driver if not split?? 
    -- Assuming route_cost is the base salary for the trip)
    to_char(COALESCE(cost.route_cost, 0), 'FM999,999,999,990') AS "Luong_tai_chinh",

    -- Main Driver Allowances
    
    -- ==========================================================
    -- MAIN DRIVER ALLOWANCE DETAILED COLUMNS (From CTE)
    -- ==========================================================
    sa.allowance_name_1 AS "Tai_chinh_Ten_phu_cap_1",
    to_char(COALESCE(sa.allowance_amount_1, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_1",
    sa.allowance_name_2 AS "Tai_chinh_Ten_phu_cap_2",
    to_char(COALESCE(sa.allowance_amount_2, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_2",
    sa.allowance_name_3 AS "Tai_chinh_Ten_phu_cap_3",
    to_char(COALESCE(sa.allowance_amount_3, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_3",
    sa.allowance_name_4 AS "Tai_chinh_Ten_phu_cap_4",
    to_char(COALESCE(sa.allowance_amount_4, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_4",
    sa.allowance_name_5 AS "Tai_chinh_Ten_phu_cap_5",
    to_char(COALESCE(sa.allowance_amount_5, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_5",
    sa.allowance_name_6 AS "Tai_chinh_Ten_phu_cap_6",
    to_char(COALESCE(sa.allowance_amount_6, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_6",
    sa.allowance_name_7 AS "Tai_chinh_Ten_phu_cap_7",
    to_char(COALESCE(sa.allowance_amount_7, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_7",
    sa.allowance_name_8 AS "Tai_chinh_Ten_phu_cap_8",
    to_char(COALESCE(sa.allowance_amount_8, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_8",
    sa.allowance_name_9 AS "Tai_chinh_Ten_phu_cap_9",
    to_char(COALESCE(sa.allowance_amount_9, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_9",
    sa.allowance_name_10 AS "Tai_chinh_Ten_phu_cap_10",
    to_char(COALESCE(sa.allowance_amount_10, 0), 'FM999,999,999,990') AS "Tai_chinh_So_tien_phu_cap_10",
    
    -- Total Allowance Main Driver
    to_char(COALESCE(cost.total_allowance_cost_first_driver, 0), 'FM999,999,999,990') AS "Tong_phu_cap_tai_chinh",

    -- Total Income Main Driver
    to_char((
        COALESCE(cost.route_cost, 0) + 
        COALESCE(cost.total_allowance_cost_first_driver, 0)
    ), 'FM999,999,999,990') AS "Tong_thu_nhap_tai_chinh",

    -- ==========================================================
    -- ASSISTANT DRIVER INFO & SALARY
    -- ==========================================================
    d2.name AS "Tai_phu",
    d2.phone AS "Sdt_tai_phu",
    d2.external_code AS "Msnv_tai_phu",
    
    -- Assistant Driver Salary (Equal to route_cost if present)
    to_char(
        CASE WHEN s.second_driver_external_id IS NOT NULL THEN COALESCE(cost.route_cost, 0) ELSE 0 END, 
        'FM999,999,999,990'
    ) AS "Luong_tai_phu",

    -- ==========================================================
    -- ASSISTANT DRIVER ALLOWANCE DETAILED COLUMNS (From CTE)
    -- ==========================================================
    sa.allowance_name_1 AS "Tai_phu_Ten_phu_cap_1",
    to_char(COALESCE(sa.allowance_amount_1, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_1",
    sa.allowance_name_2 AS "Tai_phu_Ten_phu_cap_2",
    to_char(COALESCE(sa.allowance_amount_2, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_2",
    sa.allowance_name_3 AS "Tai_phu_Ten_phu_cap_3",
    to_char(COALESCE(sa.allowance_amount_3, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_3",
    sa.allowance_name_4 AS "Tai_phu_Ten_phu_cap_4",
    to_char(COALESCE(sa.allowance_amount_4, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_4",
    sa.allowance_name_5 AS "Tai_phu_Ten_phu_cap_5",
    to_char(COALESCE(sa.allowance_amount_5, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_5",
    sa.allowance_name_6 AS "Tai_phu_Ten_phu_cap_6",
    to_char(COALESCE(sa.allowance_amount_6, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_6",
    sa.allowance_name_7 AS "Tai_phu_Ten_phu_cap_7",
    to_char(COALESCE(sa.allowance_amount_7, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_7",
    sa.allowance_name_8 AS "Tai_phu_Ten_phu_cap_8",
    to_char(COALESCE(sa.allowance_amount_8, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_8",
    sa.allowance_name_9 AS "Tai_phu_Ten_phu_cap_9",
    to_char(COALESCE(sa.allowance_amount_9, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_9",
    sa.allowance_name_10 AS "Tai_phu_Ten_phu_cap_10",
    to_char(COALESCE(sa.allowance_amount_10, 0), 'FM999,999,999,990') AS "Tai_phu_So_tien_phu_cap_10",
    
    -- Total Allowance Assistant Driver
    to_char(COALESCE(cost.total_allowance_cost_second_driver, 0), 'FM999,999,999,990') AS "Tong_phu_cap_tai_phu",

    -- Total Income Assistant Driver
    to_char((
        CASE WHEN s.second_driver_external_id IS NOT NULL THEN COALESCE(cost.route_cost, 0) ELSE 0 END +
        COALESCE(cost.total_allowance_cost_second_driver, 0)
    ), 'FM999,999,999,990') AS "Tong_thu_nhap_tai_phu",
    
    -- ==========================================================
    -- PLAN SURCHARGES (From CTE)
    -- ==========================================================
    ss.surcharge_name_1 AS "Ten_phu_phi_1",
    to_char(COALESCE(ss.surcharge_amount_1, 0), 'FM999,999,999,990') AS "So_tien_phu_phi_1",
    ss.surcharge_name_2 AS "Ten_phu_phi_2",
    to_char(COALESCE(ss.surcharge_amount_2, 0), 'FM999,999,999,990') AS "So_tien_phu_phi_2",
    ss.surcharge_name_3 AS "Ten_phu_phi_3",
    to_char(COALESCE(ss.surcharge_amount_3, 0), 'FM999,999,999,990') AS "So_tien_phu_phi_3",
    ss.surcharge_name_4 AS "Ten_phu_phi_4",
    to_char(COALESCE(ss.surcharge_amount_4, 0), 'FM999,999,999,990') AS "So_tien_phu_phi_4",
    ss.surcharge_name_5 AS "Ten_phu_phi_5",
    to_char(COALESCE(ss.surcharge_amount_5, 0), 'FM999,999,999,990') AS "So_tien_phu_phi_5",

    -- ==========================================================
    -- TRIP STATUS & NOTES
    -- ==========================================================
    s.note AS "Ghi_chu",
    CASE 
        WHEN s.end_time < (NOW() AT TIME ZONE 'UTC') THEN 'Hoan tat'
        WHEN s.start_time <= (NOW() AT TIME ZONE 'UTC') AND s.end_time >= (NOW() AT TIME ZONE 'UTC') THEN 'Dang dien ra'
        ELSE 'Chua bat dau'
    END AS "Trang_thai_chuyen",
    
    -- ==========================================================
    -- OVERALL SUMMARIES (Route Level)
    -- ==========================================================
    
    -- Total Allowances for the Trip (Both Drivers)
    to_char((COALESCE(cost.total_allowance_cost_first_driver, 0) + COALESCE(cost.total_allowance_cost_second_driver, 0)), 'FM999,999,999,990') AS "Tong_phu_cap_ca_chuyen",

    -- Surcharge
    to_char(COALESCE(cost.total_surcharge, 0), 'FM999,999,999,990') AS "Tong_phu_phi",

    -- Total Salary Cost for the Trip (Route Cost (Main) + Route Cost (Assistant if any) + All Allowances + Surcharge)
    to_char((
        COALESCE(cost.route_cost, 0) + 
        CASE WHEN s.second_driver_external_id IS NOT NULL THEN COALESCE(cost.route_cost, 0) ELSE 0 END +
        COALESCE(cost.total_allowance_cost_first_driver, 0) + 
        COALESCE(cost.total_allowance_cost_second_driver, 0) +
        COALESCE(cost.total_surcharge, 0)
    ), 'FM999,999,999,990') AS "Tong_chi_phi_chuyen"

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

-- Join Logistic Company
LEFT JOIN public.erp_company log_comp ON s.logistic_company_external_id = log_comp.external_id

-- Join Allowances CTE
LEFT JOIN ScheduleAllowances sa ON s.external_id = sa.schedules_external_id

-- Join Surcharges CTE
LEFT JOIN ScheduleSurcharges ss ON s.external_id = ss.schedules_external_id

WHERE 
    s.is_cancel = false
    -- Add Date Range Filter if needed
    AND s.is_valid = true
    AND s.vehicle_external_id IS NOT NULL

ORDER BY s.start_time DESC;

