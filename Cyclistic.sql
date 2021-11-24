-- PROJECT CYCLISTIC 
-- AIM: how casual and annual riders used the bikes differently?
-- Name: Dat Nguyen 
-- Date: 13/11/2021

-- Explore the dataset - 04/2020 as an example 
SELECT *
FROM Cyclistic.dbo.['202004-divvy-tripdata$']

-- Combine all datasets from 04/2020 to 10/2021

DROP TABLE IF EXISTS #temp_ride
CREATE TABLE #temp_ride
	(
	ride_id nvarchar(255),
	rideable_type nvarchar(255),
	started_at datetime,
	ended_at datetime, 
	start_station_name nvarchar(255),
	end_station_name nvarchar(255),
	start_lat float,
	start_lng float, 
	end_lat float,
	end_lng float, 
	member_casual nvarchar(255)
	)

INSERT INTO #temp_ride

SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202004-divvy-tripdata$']
UNION 
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202005-divvy-tripdata$']
UNION 
SELECT ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202006-divvy-tripdata$']
UNION 
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202007-divvy-tripdata$']
UNION 
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202008-divvy-tripdata$']
UNION 
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202009-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202010-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202011-divvy-tripdata$']
UNION
-- This dataset has an issue with datatype nvarchar
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202012-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202101-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202102-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202103-divvy-tripdata$']
UNION
-- This dataset has an issue wih datatype nvarchar 
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202104-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202105-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202106-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202107-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202108-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202109-divvy-tripdata$']
UNION
SELECT ride_id, rideable_type,started_at, ended_at, start_station_name, end_station_name, start_lng, start_lng, end_lat, end_lng, member_casual
	FROM Cyclistic.dbo.['202110-divvy-tripdata$']

SELECT TOP(1000) *
FROM #temp_ride
 
-- Step 1: Creat 2 collumns 
-- 1.1 - ride_length = ended_at - started_at 
-- 1.2 - day_of_week = DATENAME((WEEKDAT, started_at) 

SELECT 
	   started_at, 
	   ended_at,
	   DATEDIFF(minute, started_at, ended_at) as ride_length,
	   DATENAME(WEEKDAY, started_at) as day_of_week,
	   member_casual
FROM #temp_ride

-- Step 2: Perform calculations to determine the average ride time, max ride time and the most popular day to ride
-- based on the 2 new cols created in step 1 

-- Create a temp table 
WITH CTE_ride_time
	as
	(SELECT started_at, 
	   ended_at,
	   DATEDIFF(minute, started_at, ended_at) as ride_length,
	   DATENAME(WEEKDAY, started_at) as day_of_week,
	   member_casual
	FROM #temp_ride)

-- TASK 1: Find out the average ride time
SELECT AVG(ride_length)
FROM CTE_ride_time
-- Answer: 22 mins 

-- NOTE: CTE code chunk will be replaced with TEMP TABLE for efficiency and readability 
DROP TABLE IF EXISTS #ride_time
CREATE TABLE #ride_time
	(
	ride_length int,
	day_of_week nvarchar(255),
	membership nvarchar(255),
	ID nvarchar(255)
	)

INSERT INTO #ride_time
SELECT DATEDIFF(minute, started_at, ended_at) as ride_length,
	   DATENAME(WEEKDAY, started_at) as day_of_week,
	   member_casual as membership,
	   ride_id as ID
FROM #temp_ride
WHERE ride_length > 0

-- Step 3: Find out the average ride time for each day of the week, which day people ride the most?
SELECT AVG(ride_length), day_of_week
FROM #ride_time
WHERE ride_length > 0 
GROUP BY day_of_week
ORDER BY AVG(ride_length) DESC
-- Answer: Sunday 
-- Noted: Tuesday has a negative average balance, investigated the matter and 
-- noted this was due to one trip where time was recorded incorrectly, as such, the data point was excluded

-- Step 4: Calculate the mode day of the week (which day the bikes get used the most) by both member and casual 
SELECT DISTINCT COUNT(ID) AS no_of_trips, day_of_week
FROM #ride_time
GROUP BY day_of_week
ORDER BY no_of_trips DESC
-- Answer: Wednesday 
-- Step 4.1: Calculate the number of trips made my casual and member on any given day during the week 
SELECT DISTINCT COUNT(ID) as no_of_trips, day_of_week, membership
FROM #ride_time
WHERE membership = 'casual'
GROUP BY membership, day_of_week
ORDER BY COUNT(ID) DESC, membership
-- Answer: Casual ride more than member on a the weekend and less on weekdays 

-- Step 5: Calculate the AVG ride_length of casual and members 
SELECT AVG(ride_length), membership
FROM #ride_time
GROUP BY membership
-- Answer: member ride a lot less than casual (at 9 mins on average compared to 35)
SELECT AVG(ride_length) AS ride_length, day_of_week, membership
FROM #ride_time
WHERE ride_length > 0
GROUP BY membership, day_of_week
ORDER BY AVG(ride_length) DESC, membership
-- Answer: casual users ride longer than member every day of the week, 2.3 times on average 

-- Step 6: Which time of the year casual and member users use Cyclistic bikes?
-- Noted combined datasets are dated from 04/2020 to 10/2021 
-- Code chunk to extract data from 10/2020 to 10/2021 (to avoid double counting overlapping monthly data)
-- For visualisation purposes 
SELECT MONTH(ended_at), count(ride_id), member_casual, ended_at
FROM #temp_ride
WHERE ended_at between '2020/10/01' and '2021/10/01'
GROUP BY MONTH(ended_at), member_casual, ended_at

-- Which month casual users use Cyclistic bikes the most? 
SELECT MONTH(ended_at) AS month, count(ride_id) AS no_of_trips, member_casual
FROM #temp_ride
WHERE ended_at between '2020/10/01' and '2021/10/01'
	AND member_casual = 'casual'
GROUP BY MONTH(ended_at), member_casual
ORDER BY no_of_trips DESC
-- Answer for casual: October, November 

-- Which month member users use Cyclistic bikes the most? 
SELECT MONTH(ended_at) AS month, count(ride_id) AS no_of_trips, member_casual
FROM #temp_ride
WHERE ended_at between '2020/10/01' and '2021/10/01'
	AND member_casual = 'member'
GROUP BY MONTH(ended_at), member_casual
ORDER BY no_of_trips DESC
-- Answer for member: Dec and Jan 

-- Step 7: Which station most casual users use?
-- Where most casual members end their trips?
SELECT TOP(20) COUNT(ride_id) as no_of_trips, end_station_name, member_casual, end_lat, end_lng
FROM #temp_ride
WHERE end_station_name IS NOT NULL 
		AND member_casual = 'casual'
GROUP BY end_station_name, member_casual, end_lat, end_lng
ORDER BY COUNT(ride_id) DESC
-- Where most members end their trips?
SELECT TOP(20) COUNT(ride_id) as no_of_trips, end_station_name, member_casual, end_lat, end_lng
FROM #temp_ride
WHERE end_station_name IS NOT NULL 
		AND member_casual = 'member'
GROUP BY end_station_name, member_casual, end_lat, end_lng
ORDER BY COUNT(ride_id) DESC

-- Step 8: Extract data related to which type of bikes each type of users use the most?
SELECT rideable_type, member_casual, count(ride_id)
FROM #temp_ride
GROUP BY rideable_type, member_casual









