-- Database creation
CREATE DATABASE IF NOT EXISTS rea_games;
USE rea_games;

-- Tables creations
-- 'Games' Table creation

CREATE TABLE games (
  game_id INT PRIMARY KEY,
  title VARCHAR(255),
  genre VARCHAR(100),
  platform VARCHAR(50)
);

-- 'Players' Table creation
CREATE TABLE players (
  player_id INT PRIMARY KEY,
  age INT,
  gender ENUM('M','F','Other'),
  country VARCHAR(50)
);

-- 'Sales' Table creation
CREATE TABLE sales (
  sale_id INT PRIMARY KEY,
  player_id INT,
  game_id INT,
  amount DECIMAL(8,2),
  payment_method VARCHAR(50),
  sale_time DATETIME,
  FOREIGN KEY (player_id) REFERENCES players(player_id),
  FOREIGN KEY (game_id) REFERENCES games(game_id)
);

-- 'Engagement Metrics' Table creation
CREATE TABLE engagement_metrics (
  player_id INT,
  game_id INT,
  total_sessions INT,
  playtime_minutes INT,
  churned TINYINT,
  avg_session_time DECIMAL(6,2),
  PRIMARY KEY (player_id, game_id),
  FOREIGN KEY (player_id) REFERENCES players(player_id),
  FOREIGN KEY (game_id) REFERENCES games(game_id)
);

