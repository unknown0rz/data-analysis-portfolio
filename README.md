# Data Analysis Portfolio

SQL / BigQueryを中心としたデータ分析の学習記録です。

Web・ECサービスを想定した架空データ（学習用データセット）を使用し、
KPI分析、ファネル分析、エラー分析などの実務想定演習に取り組んでいます。

学習ではChatGPTなども活用し、分からないSQLや分析方法を調べながら、
「問題発見 → 仮説 → データ検証 → 原因分析 → 改善提案」
までの分析プロセスを身につけることを目標としています。

---

## Currently Learning / 学習中

- SQL
- BigQuery
- KPI分析
- ファネル分析
- セグメント分析
- A/Bテスト・施策効果検証

### SQL

`SELECT` / `WHERE` / `GROUP BY` / `HAVING` / `CASE`  
`JOIN` / `CTE (WITH)` / `COUNT DISTINCT` / `SAFE_DIVIDE`  
`ROW_NUMBER` / `RANK` / `LAG` / `LEAD` / Window Functions

---

# Analysis Exercises

## 01. Android新規ユーザーの決済エラー分析

### 目的

Android新規ユーザーにおいて、決済エラー修正後もKPIが改善しなかった原因を調査しました。

### 分析内容

- 修正前後の `payment` 到達者数を集計
- `error_type` 別のエラー発生人数を集計
- `payment` 到達者を分母としてエラー率を算出
- 修正前後のエラー率を比較

### 分析結果

| Error Type | 修正前 | 修正後 | 変化 |
| payment_api_error | 7.1% | 22.2% | +15.1pt |
| timeout_error | 2.4% | 14.8% | +12.4pt |

### 考察

修正後も決済周辺で複数のエラーが悪化していました。

`payment_api_error` だけでなく `timeout_error` も増加していることから、決済処理周辺に別の問題が残っており、CVR低下に影響している可能性があると考えました。

### 使用したSQL

- CTE (`WITH`)
- `COUNT(DISTINCT CASE WHEN ...)`
- `SAFE_DIVIDE`
- `CROSS JOIN`
- `GROUP BY`

### SQL

[分析SQLを見る](./sql/01_android_payment_error_analysis.sql)

---

## About

データ分析職を目指し、SQL / BigQueryを中心にデータ分析を学習しています。

今後もWeb・ECサービスなどを想定した分析演習を追加していきます。