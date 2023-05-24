DROP TABLE IF EXISTS video_games;

# creating a table

CREATE TABLE video_games (
  Rank INT,
  Name VARCHAR(255),
  Platform VARCHAR(255),
  Year INT,
  Genre VARCHAR(255),
  Publisher VARCHAR(255),
  NA_Sales DECIMAL(10,2),
  EU_Sales DECIMAL(10,2),
  JP_Sales DECIMAL(10,2),
  Other_Sales DECIMAL(10,2),
  Global_Sales DECIMAL(10,2),
  Critic_Score INT,
  Critic_Count INT,
  User_Score DECIMAL(3,1),
  User_Count INT,
  Rating VARCHAR(255)
);
