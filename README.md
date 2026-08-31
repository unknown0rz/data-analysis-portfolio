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

| Error Type        | 修正前 | 修正後 | 変化 |
| payment_api_error | 7.1% | 22.2% | +15.1pt |
| timeout_error     | 2.4% | 14.8% | +12.4pt |

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

## 02. ECサイト売上低下の原因分析

### 目的

ECサイトで発生した売上低下について、
KPI・ユーザーセグメント・ファネル・デバイス・エラーの観点から原因を分析しました。

### 使用データ

ECサイトのユーザー行動を想定した学習用の架空データを使用。

- 期間：2026年8月
- レコード数：3,600行
- 主な項目：ユーザー属性、デバイス、流入元、購入ファネル、エラー種別、購入金額
- [分析データを見る](./data/ec_sales_decline_portfolio.csv)

### 分析内容

1. 全体KPIをBefore / Afterで比較
2. ユーザーセグメント別にCVRを比較
3. 新規ユーザーの購入ファネルを分析
4. デバイス別にpayment → purchase完了率を比較
5. Android新規ユーザーのエラー内容を分析

### 分析結果

#### 全体KPI

| 指標 | Before | After | 変化 |
|---|---:|---:|---:|
| 訪問者数 | 1,800 | 1,800 | 変化なし |
| 購入者数 | 452 | 398 | 減少 |
| 売上 | 2,786,003円 | 2,595,454円 | 減少 |
| CVR | 25.1% | 22.1% | -3.0pt |

**考察**  
集客減ではなく、購入率低下が売上減少に関係している可能性がある。  
そのため、ユーザーセグメント別にKPIを確認する。

#### セグメント分析

新規ユーザーでは以下の変化が確認された。

| 指標 | Before | After | 変化 |
|---|---:|---:|---:|
| 訪問者数 | 678 | 680 | ほぼ変化なし |
| AOV | 4,091円 | 4,202円 | 上昇 |
| 購入者数 | 166 | 125 | 約24.7%減 |
| 売上 | 679,050円 | 525,290円 | 約22.6%減 |
| CVR | 24.5% | 18.4% | -6.1pt |

**考察**  
新規ユーザーの集客ではなく、購入完了までの間に問題がある可能性が高い。  
そのため、購入ファネルを分析する。

#### ファネル分析

| 区間 | Before | After | 変化 |
|---|---:|---:|---:|
| visit → view | 74.8% | 76.3% | +1.5pt |
| view → cart | 55.4% | 56.5% | +1.1pt |
| cart → payment | 71.9% | 70.0% | -1.9pt |
| payment → purchase | 82.2% | 61.0% | -21.2pt |

**考察**  
payment → purchaseの悪化が大きく、決済画面到達後から購入完了までの離脱増加が主要因の可能性が高い。

#### デバイス分析

| Device | Before | After | 変化 |
|---|---:|---:|---:|
| iOS | 84.4% | 78.5% | -5.9pt |
| PC | 80.0% | 86.8% | +6.8pt |
| Android | 81.2% | 34.1% | -47.1pt |

**考察**  
Androidで大幅な悪化が確認されたため、新規Androidユーザーのエラー内容を確認する。

#### エラー分析

| Error Type | Before | After |
|---|---:|---:|
| timeout_error | 1件 | 47件 |
| payment_api_error | 3件 | 11件 |

**考察**  
決済処理時のエラー、特に`timeout_error`の急増がCVR低下の主要因である可能性がある。

### 考察・提案

新規Androidユーザーにおいて、payment→purchase完了率が81.2%から34.1%へ47.1pt低下している。
同期間にtimeout_errorが1件→47件、payment_api_errorも3件→11件に増加していることから、決済処理時のエラー、特にtimeout_errorの急増がCVR低下の主要因である可能性がある。
開発側で新規Androidユーザーの決済処理およびtimeout_errorの発生原因を確認し、修正対応を依頼する

### SQL

- [全体KPI分析](./sql/02_ec_sales_decline/01_overall_kpi.sql)
- [セグメント分析](./sql/02_ec_sales_decline/02_segment_analysis.sql)
- [新規ユーザーのファネル分析](./sql/02_ec_sales_decline/03_new_user_funnel.sql)
- [デバイス分析](./sql/02_ec_sales_decline/04_device_analysis.sql)
- [エラー分析](./sql/02_ec_sales_decline/05_error_analysis.sql)