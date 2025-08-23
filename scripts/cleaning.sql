-- Cyclistic Case Study: SQL Cleaning Script

-- 1. Create database
CREATE DATABASE CyclisticDB;
GO

-- 2. Use database
USE CyclisticDB;
GO

-- 3. Create table schema
CREATE TABLE trips (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name NVARCHAR(255),
    start_station_id NVARCHAR(50),
    end_station_name NVARCHAR(255),
    end_station_id NVARCHAR(50),
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(50)
);
GO

-- 4. Import monthly CSVs using BULK INSERT (example for Jan)
-- Adjust file paths for each month
BULK INSERT trips
FROM 'C:\CyclisticData\2023_01_trips.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='\n',
    TABLOCK
);
GO

-- 5. Cleaning: remove nulls, calculate ride_length, weekday
ALTER TABLE trips ADD ride_length_minutes INT;
ALTER TABLE trips ADD day_of_week VARCHAR(20);
GO

UPDATE trips
SET ride_length_minutes = DATEDIFF(MINUTE, started_at, ended_at),
    day_of_week = DATENAME(WEEKDAY, started_at)
WHERE started_at IS NOT NULL AND ended_at IS NOT NULL;
GO
