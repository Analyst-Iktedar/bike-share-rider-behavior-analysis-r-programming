# Cyclistic Bike-Share Analysis: How Does a Bike-Share Navigate Speedy Success?

This repository contains the case study and data analysis project completed as part of the **Google Data Analytics Professional Certificate** capstone. The project follows the structured data analysis framework: **Ask, Prepare, Process, Analyze, Share, and Act**.

---

## 📌 Project Overview
Cyclistic is a fictional bike-share company based in Chicago with over 5,800 bicycles and 600 docking stations. While the company offers flexible pricing (single-ride and full-day passes), financial analysts have concluded that **annual members are significantly more profitable** than casual riders. 

The goal of this marketing campaign is to design strategies aimed at **converting existing casual riders into annual members**. Because casual riders are already familiar with the Cyclistic brand, they represent a high-potential growth opportunity.

---

## ❓ Business Question
To guide the marketing strategy, this analysis answers a core question:
> **How do annual members and casual riders use Cyclistic bikes differently?**

---

## 💾 Data Source & Structure
The analysis utilizes 12 months of historical trip data from the full calendar year **2025** (January through December), representing real-world trip records from Chicago's Divvy bike-share system. 

Each monthly dataset contains the following key dimensions:
* `ride_id`: Unique identifier for each trip
* `rideable_type`: Bike type (`classic_bike` or `electric_bike`)
* `started_at` / `ended_at`: Trip start and end timestamps
* `start_station_name` / `end_station_name`: Station names
* `start_lat` / `start_lng` / `end_lat` / `end_lng`: GPS coordinates
* `member_casual`: Rider type (`member` or `casual`)

---

## 🛠️ Data Processing & Transformations
Data integrity checks, cleaning, and transformations were performed using **R**. 

### Cleaning Steps:
1. **Validation:** Confirmed all timestamps fell within the 2025 range and removed 29 records where `ended_at` $\le$ `started_at`.
2. **Uniqueness:** Verified 5,552,965 unique `ride_id` records.
3. **Outlier Removal:** Filtered out trips under 1 minute (docking errors) and over 24 hours (stolen/lost bikes), removing 152,957 records.
4. **Final Cleaned Dataset:** 5,400,008 records remained for analysis.

### Feature Engineering (Derived Columns):
* `ride_length_min`: Total trip duration calculated via `difftime()`.
* `month` / `day_of_week` / `hour`: Extracted from timestamps.
* `time_of_day` / `day_type` / `season`: Categorical groupings for deeper trend analysis.

---

## 📊 Key Findings

### 1. Weekend vs. Weekday Behavior
* **Members** ride consistently throughout the week, peaking Tuesday–Thursday, strongly indicating **commute-driven usage**.
* **Casual riders** dominate the weekends, with **46.7%** of their total volume occurring on Saturday and Sunday.

### 2. Trip Duration Differences
* Casual riders take significantly longer trips on average (**20 minutes**) compared to members (**12 minutes**) — a **67% difference**. This indicates leisure and exploration usage.

### 3. High-Concentration Stations
* Casual rider activity is heavily clustered around Chicago’s lakefront, parks, and tourist hotspots.
* **Top 3 casual stations:** DuSable Lake Shore Dr & Monroe St, Navy Pier, and Streeter Dr & Grand Ave.

---

## 🚀 Marketing Recommendations

1. **Targeted Weekend Promotions:** Launch weekend-specific membership passes or discount annual offers pushed via app notifications on Friday evenings/Saturday mornings.
2. **Cost-Savings Messaging:** Create direct marketing campaigns demonstrating how a membership is highly cost-effective for longer rides (e.g., *"10 long rides as a casual rider = cost of an annual membership"*).
3. **Station-Specific Interventions:** Deploy physical signage and digital geo-fenced push notifications at the top 10 leisure/tourist stations to capture casual riders at the exact point of use.

---

## 💻 Repository Contents
* `/scripts` : Contains the full R script utilized for data cleaning, transformation, and aggregation.
* `/data` : Summary tables or data dictionary (Note: Raw large datasets are ignored via `.gitignore`).
* `/presentation` : Link or file to the final executive summary slide deck.

---

*This project was completed as part of the Google Data Analytics Capstone (2025).*
