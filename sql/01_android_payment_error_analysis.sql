-- ============================================================
-- Android New User Payment Error Analysis
-- ============================================================
-- 目的:
-- Android新規ユーザーの決済エラー修正後も
-- KPIが改善しなかった原因を確認する。
--
-- 分析内容:
-- ・修正前後のpayment到達者数を集計
-- ・error_type別のエラー発生人数を集計
-- ・payment到達者を分母としてエラー率を比較
--
-- 主な結果:
-- timeout_error     : 2.4% → 14.8%
-- payment_api_error : 7.1% → 22.2%
--
-- 考察:
-- 修正後も決済周辺で複数のエラーが悪化しており、
-- payment_api_errorだけでなくtimeout_errorも
-- CVR低下に影響している可能性がある。
-- ============================================================

WITH payment_count AS (
  SELECT
    COUNT(DISTINCT CASE
      WHEN step_log = 'payment'
        AND event_date BETWEEN '2026-08-11' AND '2026-08-17'
      THEN user_id
    END) AS before_payment,

    COUNT(DISTINCT CASE
      WHEN step_log = 'payment'
        AND event_date BETWEEN '2026-08-18' AND '2026-08-24'
      THEN user_id
    END) AS after_payment

  FROM `project_id.dataset_id.funnel_error_log`

  WHERE device = 'Android'
    AND user_segment = 'new'
),

error_count AS (
  SELECT
    error_type,

    COUNT(DISTINCT CASE
      WHEN event_date BETWEEN '2026-08-11' AND '2026-08-17'
      THEN user_id
    END) AS before_error,

    COUNT(DISTINCT CASE
      WHEN event_date BETWEEN '2026-08-18' AND '2026-08-24'
      THEN user_id
    END) AS after_error

  FROM FROM `project_id.dataset_id.funnel_error_log`

  WHERE device = 'Android'
    AND user_segment = 'new'
    AND error_type IS NOT NULL

  GROUP BY error_type
)

SELECT
  error_type,

  ROUND(
    SAFE_DIVIDE(before_error, before_payment) * 100, 1
  ) AS before_error_rate,

  ROUND(
    SAFE_DIVIDE(after_error, after_payment) * 100, 1
  ) AS after_error_rate

FROM error_count
CROSS JOIN payment_count;