# 🎮 Game User Engagement Analysis

📌 Overview

This project dives into player engagement patterns for a hypothetical mobile game platform, using SQL (MySQL) to analyze raw event log data. It reflects real-world data scenarios from mobile gaming - an industry driven by player retention, in-app monetization, and user behavior analytics.

Core Objectives:

•	Design a normalized relational data model from 5 CSV datasets.

•	Import & preprocess data in MySQL.

•	Execute SQL-based exploratory data analysis (EDA).

•	Extract actionable business insights on game monetization, player retention, LTV, and conversion.

📂 Dataset Description

Sourced from Kaggle, the dataset mimics typical backend data collected by game publishers:

File Name	Description

•	players.csv	Player demographic info (ID, name, gender, country, signup date)

•	games.csv	Game catalog (title, genre, publisher, etc.)

•	sessions.csv	In-game sessions (start/end time per game)

•	sales.csv	In-app purchases

•	engagement_metrics.csv	Retention, app opens, total playtime

Database Schema: Modeled into a normalized relational structure.

🎯 Business Context: Why Analyze Game Data?

In mobile gaming, success depends heavily on:

•	Retention: How often players come back after first play.

•	Monetization: Converting active users to payers.

•	Lifetime Value (LTV): How much revenue a user brings over time.

•	User Funnels: How users move from installs → sessions → payments.

These KPIs are critical to:

•	Reducing churn and extending playtime.

•	Optimizing monetization strategies (IAPs, ad placements).

•	Guiding marketing spend by targeting high-value cohorts.

📊 Analysis Topics (with SQL)

This project explores:

1.	User Engagement

•	DAU, MAU, DAU/MAU Ratio

•	Active user trends over time

2.	Retention Analysis

•	Day 1 / Day 7 Retention

•	Cohort Retention

3.	Revenue Analysis

•	Revenue by Game, Payment Method, Daily Breakdown

4.	User Behavior

•	Session frequency, Playtime, Demographic breakdown

5.	Funnel Conversion

•	Player → Session → Sale conversion

•	Step-by-step funnel performance by cohort

6.	User Lifetime Value (LTV)

•	Average and cohort-based 30-day LTV

7.	Engagement Over Time

•	Time-series of Sessions, Playtime


💡 Key Insights & Takeaways

🧑‍🤝‍🧑 User Engagement

•	DAU fluctuates between 2–15 users/day, MAU stable around ~200 users.

•	DAU/MAU ratio ≈ 4%, indicating limited daily stickiness.

•	Suggests casual or low-commitment user base.

🔁 Retention Trends

•	Day 1 retention: ~2.4%, Day 7: ~1.4% → very low.

•	Most users churn after the first session.

•	However, some long-term loyal users exist (30–90+ days).

•	Certain spikes in retention align with possible marketing pushes or new feature releases 

🎯 Actionable Tip: Improve onboarding UX and introduce daily login rewards to boost short-term retention.

💰 Revenue Insights

•	Game D dominates revenue, suggesting high in-game economy or better engagement mechanics.

•	Paypal is the most-used payment method.

•	May 2024 was a high-revenue month with multiple spikes.

🎯 Business Strategy: Prioritize ads, content updates for top-grossing games.

🎮 Player Behavior

•	Session time is gender-neutral; both male and female users behave similarly.

•	Most users play only 1–3 sessions, implying a short product life cycle.

•	No strong preference observed across genres in terms of playtime.

🎯 Next step: Apply segmentation models to find niche audiences for genre-specific retention.

🔄 Funnel Conversion

•	Around 75% of total users play at least one session, and ~57% of users make at least one purchase.

•	Indicates strong monetization funnel, but front-end engagement (first play) can improve.

🎯 UX Consideration: Improve first session experience to reduce initial drop-off.

📈 Lifetime Value (LTV)

•	Average 30-day LTV is healthy.

•	Cohort-based LTV reveals consistent patterns: older cohorts = higher LTV.

•	Indicates longer players = more revenue, which supports investment in long-term engagement features.

🛠️ Tools & Skills Used

•	SQL (MySQL) for data cleaning, transformation, and analysis

•	ERD for database design

•	Data storytelling for business insights

•	Familiarity with KPIs in the mobile gaming industry

🚀 Future Work

•	Integrate with visualization tools (e.g., Power BI, Tableau) to create dashboards.

•	Use Python for session clustering and churn prediction.

•	Simulate A/B testing for feature launches or monetization changes.

•	Explore Time-on-Device patterns and session drop-off points.

