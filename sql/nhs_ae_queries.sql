-- ============================================================
-- NHS A&E Attendances and Emergency Admissions 2025/26
-- SQL Analysis Queries
-- Analyst: Kingsley Eboh
-- Database: nhs_ae_analysis
-- Table: nhs_ae_data
-- ============================================================

-- Query 1: National Monthly Attendance Volume
SELECT
    "Month",
    SUM(total_att)                          AS total_attendances,
    SUM(att_t1)                             AS type1_attendances,
    ROUND(SUM(total_att) / 1000000.0, 2)   AS attendances_millions
FROM nhs_ae_data
GROUP BY "Month"
ORDER BY
    CASE "Month"
        WHEN 'Apr-25' THEN 1
        WHEN 'May-25' THEN 2
        WHEN 'Jun-25' THEN 3
        WHEN 'Jul-25' THEN 4
        WHEN 'Aug-25' THEN 5
        WHEN 'Sep-25' THEN 6
        WHEN 'Oct-25' THEN 7
        WHEN 'Nov-25' THEN 8
        WHEN 'Dec-25' THEN 9
        WHEN 'Jan-26' THEN 10
        WHEN 'Feb-26' THEN 11
        WHEN 'Mar-26' THEN 12
    END;

-- Query 2: Monthly 4-Hour Breach Rate
SELECT
    "Month",
    SUM(att_t1)                             AS type1_attendances,
    SUM(total_over4)                        AS total_breaches,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100, 1)   AS breach_rate_pct,
    24.0                                    AS nhs_target_pct,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100-24,1) AS gap_to_target_pp
FROM nhs_ae_data
GROUP BY "Month"
ORDER BY
    CASE "Month"
        WHEN 'Apr-25' THEN 1
        WHEN 'May-25' THEN 2
        WHEN 'Jun-25' THEN 3
        WHEN 'Jul-25' THEN 4
        WHEN 'Aug-25' THEN 5
        WHEN 'Sep-25' THEN 6
        WHEN 'Oct-25' THEN 7
        WHEN 'Nov-25' THEN 8
        WHEN 'Dec-25' THEN 9
        WHEN 'Jan-26' THEN 10
        WHEN 'Feb-26' THEN 11
        WHEN 'Mar-26' THEN 12
    END;

-- Query 3: Monthly 12 Hour or Longer Wait Trend
SELECT
    "Month",
    SUM(wait_12plus)                        AS total_12hr_waits,
    SUM(wait_4_12)                          AS total_4_12hr_waits,
    ROUND(SUM(wait_12plus)::numeric /
        NULLIF(SUM(att_t1), 0) * 100, 2)   AS wait_12plus_rate_pct
FROM nhs_ae_data
GROUP BY "Month"
ORDER BY
    CASE "Month"
        WHEN 'Apr-25' THEN 1
        WHEN 'May-25' THEN 2
        WHEN 'Jun-25' THEN 3
        WHEN 'Jul-25' THEN 4
        WHEN 'Aug-25' THEN 5
        WHEN 'Sep-25' THEN 6
        WHEN 'Oct-25' THEN 7
        WHEN 'Nov-25' THEN 8
        WHEN 'Dec-25' THEN 9
        WHEN 'Jan-26' THEN 10
        WHEN 'Feb-26' THEN 11
        WHEN 'Mar-26' THEN 12
    END;

-- Query 4: Top 10 Providers by Type 1 Attendance Volume
SELECT
    org_name                                AS provider,
    SUM(att_t1)                             AS total_type1_attendances,
    ROUND(SUM(att_t1) / 1000.0, 1)         AS attendances_thousands,
    RANK() OVER (ORDER BY SUM(att_t1) DESC) AS attendance_rank
FROM nhs_ae_data
GROUP BY org_name
HAVING SUM(att_t1) > 0
ORDER BY total_type1_attendances DESC
LIMIT 10;

-- Query 5: Worst 10 Providers by 4-Hour Breach Rate
SELECT
    org_name                                AS provider,
    SUM(att_t1)                             AS total_type1_attendances,
    SUM(over4_t1)                           AS total_breaches,
    ROUND(SUM(over4_t1)::numeric /
        NULLIF(SUM(att_t1), 0) * 100, 1)   AS breach_rate_pct
FROM nhs_ae_data
GROUP BY org_name
HAVING SUM(att_t1) >= 500
ORDER BY breach_rate_pct DESC
LIMIT 10;

-- Query 6: Monthly Emergency Admissions Trend
SELECT
    "Month",
    SUM(total_emerg)                        AS total_emergency_admissions,
    ROUND(SUM(total_emerg)::numeric /
        NULLIF(SUM(total_att), 0) * 100, 1) AS admission_rate_pct
FROM nhs_ae_data
GROUP BY "Month"
ORDER BY
    CASE "Month"
        WHEN 'Apr-25' THEN 1
        WHEN 'May-25' THEN 2
        WHEN 'Jun-25' THEN 3
        WHEN 'Jul-25' THEN 4
        WHEN 'Aug-25' THEN 5
        WHEN 'Sep-25' THEN 6
        WHEN 'Oct-25' THEN 7
        WHEN 'Nov-25' THEN 8
        WHEN 'Dec-25' THEN 9
        WHEN 'Jan-26' THEN 10
        WHEN 'Feb-26' THEN 11
        WHEN 'Mar-26' THEN 12
    END;

-- Query 7: Regional Attendance and Breach Rate
SELECT
    region,
    SUM(total_att)                          AS total_attendances,
    ROUND(SUM(total_att) / 1000000.0, 2)   AS attendances_millions,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100, 1)   AS breach_rate_pct,
    24.0                                    AS nhs_target_pct,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100-24,1) AS gap_to_target_pp
FROM nhs_ae_data
GROUP BY region
ORDER BY total_attendances DESC;

-- Query 8: Winter Pressure Analysis
SELECT
    CASE
        WHEN "Month" IN ('Dec-25', 'Jan-26', 'Feb-26')
        THEN 'Winter (Dec-Feb)'
        ELSE 'Rest of Year'
    END                                     AS period,
    COUNT(DISTINCT "Month")                 AS months_included,
    ROUND(AVG(monthly_att), 0)             AS avg_monthly_attendances,
    ROUND(AVG(monthly_waits), 0)           AS avg_monthly_12hr_waits,
    ROUND(AVG(monthly_breach), 1)          AS avg_breach_rate_pct
FROM (
    SELECT
        "Month",
        SUM(total_att)                      AS monthly_att,
        SUM(wait_12plus)                    AS monthly_waits,
        SUM(total_over4)::numeric /
            NULLIF(SUM(att_t1), 0) * 100   AS monthly_breach
    FROM nhs_ae_data
    GROUP BY "Month"
) monthly_totals
GROUP BY
    CASE
        WHEN "Month" IN ('Dec-25', 'Jan-26', 'Feb-26')
        THEN 'Winter (Dec-Feb)'
        ELSE 'Rest of Year'
    END
ORDER BY avg_breach_rate_pct DESC;

-- Query 9: Full Year National Summary Scorecard
SELECT
    SUM(total_att)                          AS total_attendances,
    SUM(total_emerg)                        AS total_emergency_admissions,
    ROUND(SUM(total_emerg)::numeric /
        NULLIF(SUM(total_att), 0) * 100, 1) AS emergency_admission_rate_pct,
    SUM(wait_12plus)                        AS total_12hr_waits,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100, 1)   AS overall_breach_rate_pct,
    24.0                                    AS nhs_target_pct,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100-24,1) AS gap_to_target_pp,
    COUNT(DISTINCT "Month")                 AS months_analysed,
    COUNT(DISTINCT org_name)                AS providers_analysed
FROM nhs_ae_data;

-- Query 10: Month on Month Performance Change
SELECT
    "Month",
    total_att,
    breach_rate_pct,
    ROUND((total_att - LAG(total_att) OVER (
        ORDER BY month_order))::numeric /
        NULLIF(LAG(total_att) OVER (
        ORDER BY month_order), 0) * 100, 1) AS att_change_pct,
    ROUND(breach_rate_pct - LAG(breach_rate_pct) OVER (
        ORDER BY month_order), 1)           AS breach_change_pp
FROM (
    SELECT
        "Month",
        CASE "Month"
            WHEN 'Apr-25' THEN 1
            WHEN 'May-25' THEN 2
            WHEN 'Jun-25' THEN 3
            WHEN 'Jul-25' THEN 4
            WHEN 'Aug-25' THEN 5
            WHEN 'Sep-25' THEN 6
            WHEN 'Oct-25' THEN 7
            WHEN 'Nov-25' THEN 8
            WHEN 'Dec-25' THEN 9
            WHEN 'Jan-26' THEN 10
            WHEN 'Feb-26' THEN 11
            WHEN 'Mar-26' THEN 12
        END                                 AS month_order,
        SUM(total_att)                      AS total_att,
        ROUND(SUM(total_over4)::numeric /
            NULLIF(SUM(att_t1), 0) * 100, 1) AS breach_rate_pct
    FROM nhs_ae_data
    GROUP BY "Month"
) monthly_summary
ORDER BY month_order;

-- Query 11: Best 10 Providers by 4-Hour Breach Rate
SELECT
    org_name                                AS provider,
    SUM(att_t1)                             AS total_type1_attendances,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100, 1)   AS breach_rate_pct,
    CASE
        WHEN ROUND(SUM(total_over4)::numeric /
            NULLIF(SUM(att_t1), 0) * 100, 1) <= 24
        THEN 'Met target'
        ELSE 'Missed target'
    END                                     AS target_status
FROM nhs_ae_data
GROUP BY org_name
HAVING SUM(att_t1) >= 500
ORDER BY breach_rate_pct ASC
LIMIT 10;

-- Query 12: Regional Breach Rate Ranking
SELECT
    region,
    SUM(att_t1)                             AS type1_attendances,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100, 1)   AS breach_rate_pct,
    RANK() OVER (
        ORDER BY SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) DESC
    )                                       AS breach_rank,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100-24,1) AS gap_to_target_pp
FROM nhs_ae_data
GROUP BY region
ORDER BY breach_rate_pct DESC;

-- Query 13: Provider Performance Consistency
SELECT
    org_name                                AS provider,
    COUNT(DISTINCT "Month")                 AS months_reported,
    ROUND(AVG(monthly_breach), 1)          AS mean_breach_rate_pct,
    ROUND(STDDEV(monthly_breach)::numeric, 1)
                                            AS stddev_breach_rate,
    ROUND(MIN(monthly_breach), 1)          AS min_monthly_breach_pct,
    ROUND(MAX(monthly_breach), 1)          AS max_monthly_breach_pct,
    ROUND(MAX(monthly_breach) -
        MIN(monthly_breach), 1)            AS breach_range_pp
FROM (
    SELECT
        org_name,
        "Month",
        SUM(total_over4)::numeric /
            NULLIF(SUM(att_t1), 0) * 100   AS monthly_breach
    FROM nhs_ae_data
    WHERE att_t1 >= 50
    GROUP BY org_name, "Month"
) provider_monthly
GROUP BY org_name
HAVING COUNT(DISTINCT "Month") >= 6
ORDER BY mean_breach_rate_pct DESC
LIMIT 20;

-- Query 14: Long Wait Analysis by Provider
SELECT
    org_name                                AS provider,
    region,
    SUM(wait_12plus)                        AS total_12hr_waits,
    SUM(wait_4_12)                          AS total_4_12hr_waits,
    SUM(att_t1)                             AS total_type1_attendances,
    ROUND(SUM(wait_12plus)::numeric /
        NULLIF(SUM(att_t1), 0) * 100, 2)   AS wait_12plus_rate_pct
FROM nhs_ae_data
GROUP BY org_name, region
HAVING SUM(att_t1) >= 500
ORDER BY total_12hr_waits DESC
LIMIT 10;

-- Query 15: Quarterly Performance Summary
SELECT
    CASE
        WHEN "Month" IN ('Apr-25', 'May-25', 'Jun-25')
            THEN 'Q1 Apr-Jun 2025'
        WHEN "Month" IN ('Jul-25', 'Aug-25', 'Sep-25')
            THEN 'Q2 Jul-Sep 2025'
        WHEN "Month" IN ('Oct-25', 'Nov-25', 'Dec-25')
            THEN 'Q3 Oct-Dec 2025'
        WHEN "Month" IN ('Jan-26', 'Feb-26', 'Mar-26')
            THEN 'Q4 Jan-Mar 2026'
    END                                     AS quarter,
    SUM(total_att)                          AS total_attendances,
    SUM(total_emerg)                        AS total_emergency_admissions,
    SUM(wait_12plus)                        AS total_12hr_waits,
    ROUND(SUM(total_over4)::numeric /
        NULLIF(SUM(att_t1), 0) * 100, 1)   AS breach_rate_pct,
    ROUND(SUM(total_emerg)::numeric /
        NULLIF(SUM(total_att), 0) * 100, 1) AS admission_rate_pct
FROM nhs_ae_data
GROUP BY
    CASE
        WHEN "Month" IN ('Apr-25', 'May-25', 'Jun-25')
            THEN 'Q1 Apr-Jun 2025'
        WHEN "Month" IN ('Jul-25', 'Aug-25', 'Sep-25')
            THEN 'Q2 Jul-Sep 2025'
        WHEN "Month" IN ('Oct-25', 'Nov-25', 'Dec-25')
            THEN 'Q3 Oct-Dec 2025'
        WHEN "Month" IN ('Jan-26', 'Feb-26', 'Mar-26')
            THEN 'Q4 Jan-Mar 2026'
    END
ORDER BY quarter;
