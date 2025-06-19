-- 1. USER ENGAGEMENT ANALYSIS

-- 1.1 Daily Active Users (DAU)

SELECT DATE(start_time) AS day, COUNT(DISTINCT player_id) AS DAU
FROM sessions
GROUP BY day
ORDER BY day;

-- 1.2 Monthly Active Users (MAU)

SELECT DATE_FORMAT(start_time, '%Y-%m') AS month, COUNT(DISTINCT player_id) AS mau
FROM sessions
GROUP BY month
ORDER BY month;

-- 1.3 DAU/MAU Ratio

WITH dau AS (
  SELECT DATE(start_time) AS day, COUNT(DISTINCT player_id) AS dau
  FROM sessions GROUP BY day
), mau AS (
  SELECT DATE_FORMAT(start_time, '%Y-%m') AS month, COUNT(DISTINCT player_id) AS mau
  FROM sessions GROUP BY month
)
SELECT
  dau.day,
  dau.dau,
  mau.mau,
  dau.dau * 1.0 / mau.mau AS dau_mau_ratio
FROM dau
JOIN mau ON DATE_FORMAT(dau.day, '%Y-%m') = mau.month
ORDER BY dau.day;


-- 2. Retention Analysis (Phân tích giữ chân người dùng)

-- 2.1 Day 1 Retention

WITH first_play AS (
  SELECT player_id, MIN(DATE(start_time)) AS first_date
  FROM sessions GROUP BY player_id
), next_day_play AS (
  SELECT s.player_id FROM sessions s
  JOIN first_play fp ON s.player_id = fp.player_id
  WHERE DATE(s.start_time) = DATE_ADD(fp.first_date, INTERVAL 1 DAY)
)
SELECT
  COUNT(DISTINCT next_day_play.player_id) * 1.0 / COUNT(DISTINCT first_play.player_id) AS day_1_retention
FROM first_play
LEFT JOIN next_day_play ON first_play.player_id = next_day_play.player_id;

-- 2.2 Day 7 Retention

WITH first_play AS (
  SELECT player_id, MIN(DATE(start_time)) AS first_date
  FROM sessions GROUP BY player_id
), next_day_play AS (
  SELECT s.player_id FROM sessions s
  JOIN first_play fp ON s.player_id = fp.player_id
  WHERE DATE(s.start_time) = DATE_ADD(fp.first_date, INTERVAL 7 DAY)
)
SELECT
  COUNT(DISTINCT next_day_play.player_id) * 1.0 / COUNT(DISTINCT first_play.player_id) AS day_7_retention
FROM first_play
LEFT JOIN next_day_play ON first_play.player_id = next_day_play.player_id;

-- 2.3 Cohort Retention

WITH cohorts AS (
  SELECT player_id, MIN(DATE(start_time)) AS cohort_month
  FROM sessions GROUP BY player_id
), activity AS (
  SELECT player_id, DATE(start_time) AS active_date
  FROM sessions
)
SELECT
  c.cohort_month,
  a.active_date,
  COUNT(DISTINCT a.player_id) AS active_users
FROM cohorts c
JOIN activity a ON c.player_id = a.player_id
GROUP BY c.cohort_month, a.active_date
ORDER BY c.cohort_month, a.active_date;


-- 3. Revenue Analysis (Phân tích doanh thu)

-- 3.1 Revenue by Game

SELECT g.title, SUM(s.amount) AS total_revenue
FROM sales s
JOIN games g ON s.game_id = g.game_id
GROUP BY g.title
ORDER BY total_revenue DESC;

-- 3.2 Revenue by Payment Method

SELECT payment_method, SUM(amount) AS revenue
FROM sales
GROUP BY payment_method
ORDER BY revenue DESC;

-- 3.3 Daily Revenue

SELECT DATE(sale_time) AS day, SUM(amount) AS daily_revenue
FROM sales
GROUP BY day
ORDER BY day;

-- 3.4 Monthly Revenue

SELECT DATE_FORMAT(sale_time, '%Y-%m') AS month, SUM(amount) AS monthly_revenue
FROM sales
GROUP BY month
ORDER BY month;


-- 4. User Behavior Analysis

-- 4.1 Average Session Time by Gender

SELECT p.gender,
  AVG(TIMESTAMPDIFF(MINUTE, s.start_time, s.end_time)) AS avg_session_minutes
FROM sessions s
JOIN players p ON s.player_id = p.player_id
GROUP BY p.gender;

-- 4.2 Sessions per Player Distribution

SELECT player_id, COUNT(session_id) AS session_count
FROM sessions
GROUP BY player_id
ORDER BY session_count DESC;

-- 4.3 Popular Genres by Playtime

SELECT g.genre,
  AVG(TIMESTAMPDIFF(MINUTE, s.start_time, s.end_time)) AS avg_playtime
FROM sessions s
JOIN games g ON s.game_id = g.game_id
GROUP BY g.genre;


-- 5. Funnel Conversion Analysis (Phân tích phễu chuyển đổi)

-- 5.1 Players → Sessions → Sales Conversion Rates

WITH total_players AS (SELECT COUNT(DISTINCT player_id) AS cnt FROM players),
     players_played AS (SELECT COUNT(DISTINCT player_id) AS cnt FROM sessions),
     players_purchased AS (SELECT COUNT(DISTINCT player_id) AS cnt FROM sales)
SELECT
  tp.cnt AS total_players,
  pp.cnt AS players_played,
  pp.cnt * 1.0 / tp.cnt AS play_rate,
  ps.cnt AS players_purchased,
  ps.cnt * 1.0 / tp.cnt AS purchase_rate
FROM total_players tp, players_played pp, players_purchased ps;


-- 5.2 Stepwise Funnel by Day

WITH first_play AS (
  SELECT player_id, MIN(DATE(start_time)) AS first_play_date
  FROM sessions
  GROUP BY player_id
),
daily_activity AS (
  SELECT
    fp.first_play_date,
    DATE(s.start_time) AS session_date,
    s.player_id
  FROM sessions s
  JOIN first_play fp ON s.player_id = fp.player_id
),
daily_sales AS (
  SELECT
    fp.first_play_date,
    DATE(sl.sale_time) AS sale_date,
    sl.player_id
  FROM sales sl
  JOIN first_play fp ON sl.player_id = fp.player_id
)
SELECT
  fp.first_play_date,
  d.session_date,
  COUNT(DISTINCT fp.player_id) AS total_players,
  COUNT(DISTINCT d.player_id) AS active_sessions,
  COUNT(DISTINCT ds.player_id) AS purchases
FROM first_play fp
LEFT JOIN daily_activity d
  ON fp.player_id = d.player_id AND d.session_date = DATE_ADD(fp.first_play_date, INTERVAL 0 DAY)
LEFT JOIN daily_sales ds
  ON fp.player_id = ds.player_id AND ds.sale_date = DATE_ADD(fp.first_play_date, INTERVAL 0 DAY)
GROUP BY fp.first_play_date, d.session_date
ORDER BY fp.first_play_date, d.session_date;


-- 6. User Lifetime Value (LTV)

-- 6.1 Average LTV in 30 Days

WITH first_play AS (
  SELECT player_id, MIN(DATE(start_time)) AS first_play_date
  FROM sessions GROUP BY player_id
),
revenue_30d AS (
  SELECT s.player_id, SUM(s.amount) AS total_revenue_30d
  FROM sales s
  JOIN first_play fp ON s.player_id = fp.player_id
  WHERE s.sale_time BETWEEN fp.first_play_date AND DATE_ADD(fp.first_play_date, INTERVAL 30 DAY)
  GROUP BY s.player_id
)
SELECT AVG(total_revenue_30d) AS avg_ltv_30d FROM revenue_30d;

-- 6.2 Cohort-based LTV

WITH first_play AS (
  SELECT player_id, MIN(DATE(start_time)) AS first_play_date,
         DATE_FORMAT(MIN(start_time), '%Y-%m') AS cohort_month
  FROM sessions
  GROUP BY player_id
),
revenue_per_player AS (
  SELECT s.player_id,
         SUM(s.amount) AS total_revenue,
         fp.cohort_month
  FROM sales s
  JOIN first_play fp ON s.player_id = fp.player_id
  WHERE s.sale_time BETWEEN fp.first_play_date AND DATE_ADD(fp.first_play_date, INTERVAL 30 DAY)
  GROUP BY s.player_id, fp.cohort_month
)
SELECT
  cohort_month,
  AVG(total_revenue) AS avg_ltv_30d
FROM revenue_per_player
GROUP BY cohort_month
ORDER BY cohort_month;


-- 7. Engagement Over Time

-- 7.1 Sessions Over Time

SELECT DATE(start_time) AS day, COUNT(session_id) AS total_sessions
FROM sessions
GROUP BY day
ORDER BY day;

-- 7.2 Playtime Over Time

SELECT DATE(start_time) AS day,
  SUM(TIMESTAMPDIFF(MINUTE, start_time, end_time)) AS total_playtime_minutes
FROM sessions
GROUP BY day
ORDER BY day;

