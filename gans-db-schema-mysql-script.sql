-- Drop the database if it already exists
-- DROP DATABASE IF EXISTS gans_local;


-- Create the database
CREATE DATABASE gans_local;


-- Use the database
USE gans_local;


CREATE TABLE cities (
    City_id INT AUTO_INCREMENT, -- Automatically generated ID for each city
    City_name VARCHAR(255) NOT NULL, -- Name of the city
    Country VARCHAR(255) NOT NULL, -- Name of the country
    PRIMARY KEY (City_id) -- Primary key to uniquely identify each city
);



CREATE TABLE population (
    Population_id INT AUTO_INCREMENT,
    Population INT NOT NULL,
    Year_Data_Retrieved VARCHAR(255),
    City_id INT,
    PRIMARY KEY (Population_id),
    FOREIGN KEY (City_id) REFERENCES cities(City_id)
);



CREATE TABLE weather (
	weather_id INT AUTO_INCREMENT,
    city_id INT NOT NULL, 
    forecast_time DATETIME,
    outlook VARCHAR(255),
    temperature FLOAT,
    feels_like FLOAT,
    rain_in_last_3h FLOAT,
    wind_speed FLOAT,
    rain_prob FLOAT,
    data_retrieved_at DATETIME,
    PRIMARY KEY (weather_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id)
);



CREATE TABLE airports(
    icao VARCHAR(10),
    Airport_name VARCHAR(255),
    City_id INT NOT NULL,
    PRIMARY KEY (icao),
    FOREIGN KEY (City_id) REFERENCES cities(City_id)
);



CREATE TABLE flights(
	flight_id INT AUTO_INCREMENT,
    arrival_airport_icao VARCHAR(10),
    departure_airport_icao VARCHAR(10),
    departure_airport_name VARCHAR(30),
    scheduled_arrival_time DATETIME,
    flight_number VARCHAR(30),
    data_retrieved_at DATETIME,
    PRIMARY KEY (flight_id),
    FOREIGN KEY (arrival_airport_icao) REFERENCES airports(icao)
);



SELECT * FROM cities;
SELECT * FROM population;
SELECT * FROM weather;
SELECT * FROM airports;
SELECT * FROM flights;