# NHS A&E Attendances & Emergency Admissions
## Trend Analysis | Financial Year 2025/26

---

## Project Overview
This project examined NHS England A&E attendance and emergency admission data
across the full 2025/26 financial year (April 2025 to March 2026). The analysis
covers all NHS trusts and providers submitting monthly A&E returns to NHS England,
producing 8 analytical outputs that track performance trends, identify providers
with the greatest performance challenges and quantify the impact of winter
pressure on the system.

---

## Objectives
- Quantify monthly A&E attendance volumes and identify seasonal patterns
- Track 4-hour performance against the NHS England standard across the year
- Measure the scale and trend of 12+ hour waits from Decision to Admit
- Identify highest volume providers and those with the greatest performance challenges
- Analyse emergency admission trends across the financial year
- Compare regional performance variation across NHS England
- Assess the impact of winter pressure (December 2025 to February 2026)

---

## Data Source
**Publisher:** NHS England  
**Dataset:** A&E Attendances and Emergency Admissions 2025/26  
**Coverage:** Approximately 200 NHS trusts and providers per month submitting
A&E returns to NHS England  
**Frequency:** Monthly  
**Access:** [NHS England Statistics](https://www.england.nhs.uk/statistics/statistical-work-areas/ae-waiting-times-and-activity/)

---

## Tools & Libraries
| Tool | Purpose |
|---|---|
| Python 3.12 | Core programming language |
| pandas | Data loading, cleaning and transformation |
| matplotlib | Chart production and formatting |
| seaborn | Chart styling and colour palettes |
| Jupyter Notebook | Interactive analysis environment |

---

## Key Findings
- **26.9 million** A&E attendances were recorded across England in 2025/26
- **6.5 million** attendances resulted in an emergency admission: approximately 1 in 4 patients
- **570,931 patients** waited 12 or more hours from Decision to Admit: a serious patient safety concern
- The overall 4-hour breach rate was **39.4%**: nearly double the NHS target of 24%
- **January 2026** was the worst performing month with a breach rate of 44.8%
- **March 2026** was the busiest month with 2.35 million attendances
- **NHS England Midlands** was the busiest region with 4.9 million attendances
- **University Hospitals Birmingham** was the highest volume provider with 414,623 Type 1 attendances
- **Mid Cheshire Hospitals** recorded the highest breach rate at 56.4%
- Winter months averaged **1.3 times** more 12+ hour long waits than the rest of the year

---

## Analyses
| Analysis | Description |
|---|---|
| 1. Monthly attendances | Total A&E attendances by month across 2025/26 |
| 2. 4-hour breach rate | Monthly breach rate trend vs NHS target |
| 3. 12+ hour long waits | DTA long wait trend across the year |
| 4. Top 10 providers | Highest volume Type 1 providers |
| 5. Worst 10 providers | Providers with the highest breach rates |
| 6. Emergency admissions | Monthly emergency admissions trend |
| 7. Regional breakdown | Total attendances by NHS England region |
| 8. Winter pressure | December 2025 to February 2026 vs rest of year |

---

## How to Run
1. Clone the repository:
```bash
git clone https://github.com/Kingsley-Eboh/nhs-trend-analysis.git
```
2. Navigate to the project folder:
```bash
cd nhs-trend-analysis
```
3. Install required libraries:
```bash
pip install pandas matplotlib seaborn
```
4. Launch Jupyter Notebook:
```bash
jupyter notebook
```
5. Open `nhs_trend_analysis.ipynb` and run all cells:
**Kernel → Restart & Run All**

---

## Project Structure
nhs-trend-analysis/
├── nhs_trend_analysis.ipynb           # Main analysis notebook
├── analysis1_monthly_attendances.png  # Monthly attendance trend
├── analysis2_4hr_breach_rate.png      # 4-hour breach rate trend
├── analysis3_long_waits.png           # 12+ hour long waits trend
├── analysis4_top10_providers.png      # Top 10 providers
├── analysis5_worst10_breach.png       # Worst 10 providers
├── analysis6_emergency_admissions.png # Emergency admissions trend
├── analysis7_regional_breakdown.png   # Regional breakdown
├── analysis8_winter_pressure.png      # Winter pressure analysis
├── .gitignore                         # Excludes Jupyter checkpoints
└── README.md                          # Project documentation

---

## Author
**Kingsley Eboh**   
[GitHub](https://github.com/Kingsley-Eboh)

---

*Data sourced from NHS England. This project is intended for portfolio and
educational purposes.*
