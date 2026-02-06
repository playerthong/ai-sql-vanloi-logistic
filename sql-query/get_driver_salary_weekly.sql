-- Query to get Weekly Driver Salary
-- Columns:
-- THỜI GIAN GHI NHẬN -> Thoi_gian_ghi_nhan (ISO Year-Week)
-- TÊN TÀI -> Ten_tai
-- MSNV TÀI XẾ -> Msnv_tai_xe
-- SĐT TÀI XẾ -> Sdt_tai_xe
-- TỔNG LƯƠNG TÀI XẾ THEO CHUYẾN -> Tong_luong_tai_xe_theo_chuyen
-- TỔNG PHỤ CẤP BỐC XẾP -> Tong_phu_cap_boc_xep
-- TỔNG PHỤ CẤP LƯƠNG SC -> Tong_phu_cap_luong_sc
-- TỔNG PHỤ CẤP CÒN LẠI -> Tong_phu_cap_con_lai
-- TỔNG PHỤ CẤP TÀI -> Tong_phu_cap_tai
-- TỔNG LƯƠNG -> Tong_luong

WITH DriverTrips AS (
    -- Main Driver Trips
    SELECT 
        d1.phone AS driver_phone,
        d1.name AS driver_name,
        d1.external_code AS driver_code,
        s.start_time + INTERVAL '7 hours' AS start_time_vn,
        COALESCE(cost.route_cost, 0) AS salary,
        -- Allowance mapping
        0 AS loading_allowance,
        0 AS standby_allowance,
        COALESCE(cost.total_allowance_cost_first_driver, 0) AS total_allowance_raw,
        COALESCE(cost.other_allowance_first_driver, 0) AS other_allowance_clean
    FROM public.erp_schedules s
    LEFT JOIN public.erp_driver d1 ON s.first_driver_external_id = d1.external_id
    LEFT JOIN public.erp_schedules_logistic_cost cost ON s.external_id = cost.schedules_external_id
    WHERE s.first_driver_external_id IS NOT NULL 
      AND s.is_cancel = false AND s.is_valid = true AND s.vehicle_external_id IS NOT NULL

    UNION ALL

    -- Assistant Driver Trips
    SELECT 
        d2.phone AS driver_phone,
        d2.name AS driver_name,
        d2.external_code AS driver_code,
        s.start_time + INTERVAL '7 hours' AS start_time_vn,
        COALESCE(cost.route_cost, 0) AS salary,
        -- Allowance mapping
        0 AS loading_allowance,
        0 AS standby_allowance,
        COALESCE(cost.total_allowance_cost_second_driver, 0) AS total_allowance_raw,
        COALESCE(cost.other_allowance_second_driver, 0) AS other_allowance_clean
    FROM public.erp_schedules s
    LEFT JOIN public.erp_driver d2 ON s.second_driver_external_id = d2.external_id
    LEFT JOIN public.erp_schedules_logistic_cost cost ON s.external_id = cost.schedules_external_id
    WHERE s.second_driver_external_id IS NOT NULL 
      AND s.is_cancel = false AND s.is_valid = true AND s.vehicle_external_id IS NOT NULL
)
SELECT
    to_char(date_trunc('week', dt.start_time_vn), 'DD/MM/YYYY') || ' - ' || to_char(date_trunc('week', dt.start_time_vn) + interval '6 days', 'DD/MM/YYYY') AS "Thoi_gian_ghi_nhan",
    dt.driver_name AS "Ten_tai",
    dt.driver_code AS "Msnv_tai_xe",
    dt.driver_phone AS "Sdt_tai_xe",
    to_char(SUM(dt.salary), 'FM999,999,999,990') AS "Tong_luong_tai_xe_theo_chuyen",
    to_char(SUM(dt.loading_allowance), 'FM999,999,999,990') AS "Tong_phu_cap_boc_xep",
    to_char(SUM(dt.standby_allowance), 'FM999,999,999,990') AS "Tong_phu_cap_luong_sc",
    to_char(SUM(dt.other_allowance_clean), 'FM999,999,999,990') AS "Tong_phu_cap_con_lai",
    to_char(SUM(dt.total_allowance_raw), 'FM999,999,999,990') AS "Tong_phu_cap_tai",
    to_char(SUM(dt.salary + dt.total_allowance_raw), 'FM999,999,999,990') AS "Tong_luong"
FROM DriverTrips dt
WHERE dt.start_time_vn >= '{{ from | default("2026-01-01", true) }}' 
  AND dt.start_time_vn <= '{{ to | default("2026-01-30", true) }}'
GROUP BY 
    date_trunc('week', dt.start_time_vn),
    dt.driver_name,
    dt.driver_code,
    dt.driver_phone
ORDER BY date_trunc('week', dt.start_time_vn) DESC, dt.driver_name;
