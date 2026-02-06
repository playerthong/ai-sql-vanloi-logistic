-- Query to get Monthly Driver Salary
-- Based on Template: TEMP_SALARY_DRIVER_MONTHLY.csv
-- Columns:
-- THỜI GIAN GHI NHẬN -> Thoi_gian_ghi_nhan (MM/YYYY)
-- TÊN TÀI -> Ten_tai
-- MSNV TÀI XẾ -> Msnv_tai_xe
-- TỔNG LƯƠNG TÀI XẾ THEO CHUYẾN -> Tong_luong_tai_xe_theo_chuyen (Sum of route_cost)
-- TỔNG PHỤ CẤP BỐC XẾP -> Tong_phu_cap_boc_xep
-- TỔNG PHỤ CẤP LƯƠNG SC -> Tong_phu_cap_luong_sc
-- TỔNG PHỤ CẤP CÒN LẠI -> Tong_phu_cap_con_lai
-- TỔNG PHỤ CẤP TÀI -> Tong_phu_cap_tai (Total Allowances)
-- TỔNG LƯƠNG -> Tong_luong (Salary + Allowances)

WITH DriverTrips AS (
    -- Main Driver Trips
    SELECT 
        d1.phone AS driver_phone,
        d1.name AS driver_name,
        d1.external_code AS driver_code,
        s.start_time + INTERVAL '7 hours' AS start_time,
        COALESCE(cost.route_cost, 0) AS salary,
        
        -- Allowances assigned to Main Driver
        COALESCE(cost.allowance_pc1_first_driver, 0) AS allowance_pc1,
        COALESCE(cost.allowance_pc2_first_driver, 0) AS allowance_pc2,
        COALESCE(cost.other_allowance_first_driver, 0) AS other_allowance,
        COALESCE(cost.total_allowance_cost_first_driver, 0) AS total_allowance
        
    FROM public.erp_schedules s
    LEFT JOIN public.erp_driver d1 ON s.first_driver_external_id = d1.external_id
    LEFT JOIN public.erp_schedules_logistic_cost cost ON s.external_id = cost.schedules_external_id
    LEFT JOIN public.erp_company log_comp ON s.logistic_company_external_id = log_comp.external_id
    WHERE 
        s.first_driver_external_id IS NOT NULL
        AND s.is_cancel = false
        AND s.vehicle_external_id IS NOT NULL
        AND s.is_valid = true
        AND log_comp.company_type = 'OWN'

    UNION ALL

    -- Assistant Driver Trips
    SELECT 
        d2.phone AS driver_phone,
        d2.name AS driver_name,
        d2.external_code AS driver_code,
        s.start_time + INTERVAL '7 hours' AS start_time,
        -- Assistant Driver Salary: Equals to route_cost when present
        COALESCE(cost.route_cost, 0) AS salary,
        
        -- Allowances assigned to Assistant Driver
        COALESCE(cost.allowance_pc1_second_driver, 0) AS allowance_pc1,
        COALESCE(cost.allowance_pc2_second_driver, 0) AS allowance_pc2,
        COALESCE(cost.other_allowance_second_driver, 0) AS other_allowance,
        COALESCE(cost.total_allowance_cost_second_driver, 0) AS total_allowance
        
    FROM public.erp_schedules s
    LEFT JOIN public.erp_driver d2 ON s.second_driver_external_id = d2.external_id
    LEFT JOIN public.erp_schedules_logistic_cost cost ON s.external_id = cost.schedules_external_id
    LEFT JOIN public.erp_company log_comp ON s.logistic_company_external_id = log_comp.external_id
    WHERE 
        s.second_driver_external_id IS NOT NULL
        AND s.is_cancel = false
        AND s.vehicle_external_id IS NOT NULL
        AND s.is_valid = true
        AND log_comp.company_type = 'OWN'
)

SELECT
    to_char(dt.start_time, 'MM/YYYY') AS "Thoi_gian_ghi_nhan",
    dt.driver_name AS "Ten_tai",
    dt.driver_code AS "Msnv_tai_xe",
    dt.driver_phone AS "Sdt_tai_xe",
    
    to_char(SUM(dt.salary), 'FM999,999,999,990') AS "Tong_luong_tai_xe_theo_chuyen",
    to_char(SUM(dt.allowance_pc1), 'FM999,999,999,990') AS "Tong_phu_cap_1",
    to_char(SUM(dt.allowance_pc2), 'FM999,999,999,990') AS "Tong_phu_cap_2",
    to_char(SUM(dt.other_allowance), 'FM999,999,999,990') AS "Tong_phu_cap_khac",
    to_char(SUM(dt.total_allowance), 'FM999,999,999,990') AS "Tong_phu_cap_tai",
    
    to_char(SUM(dt.salary + dt.total_allowance), 'FM999,999,999,990') AS "Tong_luong"

FROM DriverTrips dt
-- Date Filter WHERE dt.start_time >= '{{ from | default("2026-01-01", true) }}' AND dt.start_time <= '{{ to | default("2026-01-30", true) }}' 
GROUP BY 
    to_char(dt.start_time, 'MM/YYYY'),
    dt.driver_name,
    dt.driver_code,
    dt.driver_phone
ORDER BY 
    to_char(dt.start_time, 'MM/YYYY') DESC,
    dt.driver_name;
