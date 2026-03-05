# SQL-Revenue-Concentration-Analysis-git
Revenue structure and concentration analysis of the Northwind database using advanced SQL, window functions, Pareto analysis, and HHI metrics to evaluate customer, category, and SKU dependency risk.

Live landing page: https://jdesk99.github.io/SQL-Revenue-Concentration-Analysis-git/

## Business Context & Objective
As revenue accelerated in the most last 5 months, this project evaluates whether growth is structurally resilient or overly dependent on concentrated customers, categories, or SKUs.

The analysis combines:
- SQL-based growth decomposition
- Pareto concentration modeling
- Herfindahl-Hirschman Index (HHI) and effective-count translation
- Market basket association metrics (support, confidence, lift)

## Key Findings (Pages 2-4)

### Revenue Growth Mechanics
- Growth was primarily engagement-driven, not acquisition-driven.
- New customer additions remained minimal during the acceleration period.
- Average order value (AOV) stayed within historical range.
- Orders per active customer increased from ~1.28 (late 1995) to ~1.45 (early 1996), peaking at ~1.6 in March.
- Revenue reached approximately $129K in the latest month, with order volume peaking at 77.
- Repeat behavior was strong (88 of 89 customers were repeat buyers).

### Customer Concentration & Dependency
- Customer HHI = 0.034 (low concentration).
- Effective customer count is roughly 30, despite 88 total customers.
- Pareto view: top 20% of customers generate about 60% of revenue.
- No single customer contributes more than ~9% of total revenue.
- Conclusion: customer-level dependency is limited and not the primary structural vulnerability.

### Geographic Structure
- Revenue spans 21 countries.
- Largest shares: United States (~19.4%) and Germany (~18.1%).
- Top 3 countries contribute ~48% combined; no single country exceeds 20%.
- Some intra-country concentration exists (for example, anchor-account dependence in Austria), while larger markets are more distributed.
- Conclusion: geographic concentration risk is moderate/localized, not systemic.

### Product Portfolio Structure & SKU Dependency
- Category-level concentration is low (Category HHI ~0.143), indicating macro diversification.
- Dependency emerges at SKU-within-category level.
- Category 1 (~21% revenue) has 12 SKUs but effective SKU count ~3.29 (SKU HHI ~0.304), meaning revenue behaves as if driven by ~3-4 SKUs.
- Similar (smaller) compression appears in categories 5 and 6.
- Conclusion: primary structural exposure is product-level dependency within selected categories.

### Analytical Conclusion
Revenue expansion is supported by strong retention and broad customer/category diversification, but localized SKU dependency remains the core risk. Structural resilience is broad; fragility is concentrated at specific product clusters.

## Technical Architecture & Analytical Framework

### Data Structure & SQL Design
- Built layered SQL foundations from Orders, Order Details, Customers, Products, and Categories.
- Standardized revenue at three levels:
  - Line-item revenue layer (OrderID x ProductID)
  - Order-level revenue layer
  - Customer-level revenue layer
- Reused intermediate metrics (revenue share, rank, cumulative share) across all analyses.
- Used window functions for Pareto distributions, running totals, and partitioned rankings.

### Concentration Methodology
- Concentration measured using HHI across customers, categories, and SKU-within-category views.
- Effective count used for interpretability:
  - Effective Count = 1 / HHI
- This distinguishes:
  - macro diversification (e.g., low category concentration)
  - localized dependency (e.g., SKU concentration inside a category)

### Cross-Sell / Market Basket Framework
- Product pairs generated via self-joins on line-item data by `OrderID`.
- Metrics computed:
  - Support
  - Confidence
  - Lift
- Highest pair signal (Products 21 and 61) showed lift > 1, but:
  - support ~0.96%
  - confidence ~0.20 / 0.33
  - total revenue contribution ~0.43%
- Conclusion: no economically material cross-sell structure at portfolio level.

## Assumptions & Limitations
- Historical transaction behavior is assumed representative of underlying demand behavior.
- Revenue uses recorded order-line values and excludes external effects (returns/cancellations/market shocks not explicitly modeled).
- Market basket analysis captures same-order co-purchase only, not sequential multi-order effects.
- HHI and dependency metrics are dataset-period specific and may shift as catalog/customer mix evolves.

## Resources
- Repository: https://github.com/jdesk99/SQL-Revenue-Concentration-Analysis-git
- Landing page: https://jdesk99.github.io/SQL-Revenue-Concentration-Analysis-git/
