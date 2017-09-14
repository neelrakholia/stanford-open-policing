-- Total stops between 2011 and 2015 by race
CREATE TABLE total_stops AS
SELECT
  driver_race,
  count(driver_race)
FROM stops
WHERE extract(YEAR FROM stop_date) BETWEEN 2011 AND 2015
GROUP BY driver_race
ORDER BY count DESC;

-- Joing county pop data with stops and calculating total number of stops
CREATE TABLE stop_rate_by_race AS
SELECT
  tot_stops_by_race.state,
  tot_stops_by_race.county_name,
  tot_stops_by_race.county_fips,
  tot_stops_by_race.total_stops,
  (CASE driver_race WHEN 'Asian' THEN total_stops / NULLIF(asian_pop * num_years, 0)
                    WHEN 'Black' THEN total_stops / NULLIF(black_pop * num_years, 0)
                    WHEN 'Hispanic' THEN total_stops / NULLIF(hispanic_pop * num_years, 0)
                    WHEN 'White' THEN total_stops / NULLIF(white_pop * num_years, 0)
                    ELSE 0
  END) AS stop_rate,
  demographics.tot_pop,
  demographics.asian_pop,
  demographics.black_pop,
  demographics.hispanic_pop,
  demographics.white_pop,
  tot_stops_by_race.num_years,
  tot_stops_by_race.driver_race
FROM
  (SELECT
    state,
    min(county_name) AS county_name,
    county_fips,
    driver_race,
    count(county_name) AS total_stops,
    CAST((max(stop_date) - min(stop_date)) AS numeric) / 365 AS num_years
  FROM
    stops
  WHERE
    driver_race ~ 'Asian|Black|Hispanic|White' AND
    county_fips NOT LIKE ''
  GROUP BY state, county_fips, driver_race
  ORDER BY state, county_fips, driver_race)
  tot_stops_by_race
INNER JOIN
  (SELECT
    stname,
    (state || county) as county_fips,
    tot_pop,
    (wac_male + wac_female) AS white_pop,
    (bac_male + bac_female) AS black_pop,
    (h_male + h_female) AS hispanic_pop,
    (aac_male + aac_female) AS asian_pop
  FROM
    county_pop_data
  WHERE agegrp = 0 AND year = 8
  ORDER BY stname, county_fips)
  demographics
ON (tot_stops_by_race.county_fips = demographics.county_fips);

-- table for search rate
CREATE TABLE search_rate_by_race AS
SELECT
  tot_stops_by_race.state,
  tot_stops_by_race.county_name,
  tot_stops_by_race.county_fips,
  tot_stops_by_race.total_stops,
  tot_stops_by_race.total_searches,
  CAST(total_searches AS numeric) / total_stops AS search_rate,
  (CASE driver_race WHEN 'Asian' THEN total_stops / NULLIF(asian_pop * num_years, 0)
                    WHEN 'Black' THEN total_stops / NULLIF(black_pop * num_years, 0)
                    WHEN 'Hispanic' THEN total_stops / NULLIF(hispanic_pop * num_years, 0)
                    WHEN 'White' THEN total_stops / NULLIF(white_pop * num_years, 0)
                    ELSE 0
  END) AS stop_rate,
  demographics.tot_pop,
  demographics.asian_pop,
  demographics.black_pop,
  demographics.hispanic_pop,
  demographics.white_pop,
  tot_stops_by_race.num_years,
  tot_stops_by_race.driver_race
FROM
  (SELECT
    state,
    min(county_name) AS county_name,
    county_fips,
    driver_race,
    count(county_name) AS total_stops,
    count(CASE WHEN search_conducted THEN 1 END) AS total_searches,
    CAST((max(stop_date) - min(stop_date)) AS numeric) / 365 AS num_years
  FROM
    stops
  WHERE
    driver_race ~ 'Asian|Black|Hispanic|White' AND
    county_fips NOT LIKE ''
  GROUP BY state, county_fips, driver_race
  ORDER BY state, county_fips, driver_race)
  tot_stops_by_race
INNER JOIN
  (SELECT
    stname,
    (state || county) as county_fips,
    tot_pop,
    (wac_male + wac_female) AS white_pop,
    (bac_male + bac_female) AS black_pop,
    (h_male + h_female) AS hispanic_pop,
    (aac_male + aac_female) AS asian_pop
  FROM
    county_pop_data
  WHERE agegrp = 0 AND year = 8
  ORDER BY stname, county_fips)
  demographics
ON (tot_stops_by_race.county_fips = demographics.county_fips);

-- table for arrest rate
CREATE TABLE arrest_rate_by_race AS
SELECT
  tot_stops_by_race.state,
  tot_stops_by_race.county_name,
  tot_stops_by_race.county_fips,
  tot_stops_by_race.total_searches,
  tot_stops_by_race.total_arrests,
  CAST(total_arrests AS numeric) / total_searches AS arrest_rate,
  demographics.tot_pop,
  demographics.asian_pop,
  demographics.black_pop,
  demographics.hispanic_pop,
  demographics.white_pop,
  tot_stops_by_race.num_years,
  tot_stops_by_race.driver_race
FROM
  (SELECT
    state,
    min(county_name) AS county_name,
    county_fips,
    driver_race,
    count(county_name) AS total_searches,
    count(CASE WHEN is_arrested THEN 1 END) AS total_arrests,
    CAST((max(stop_date) - min(stop_date)) AS numeric) / 365 AS num_years
  FROM
    stops
  WHERE
    driver_race ~ 'Asian|Black|Hispanic|White' AND
    county_fips NOT LIKE '' AND
    search_conducted = TRUE
  GROUP BY state, county_fips, driver_race
  ORDER BY state, county_fips, driver_race)
  tot_stops_by_race
INNER JOIN
  (SELECT
    stname,
    (state || county) as county_fips,
    tot_pop,
    (wac_male + wac_female) AS white_pop,
    (bac_male + bac_female) AS black_pop,
    (h_male + h_female) AS hispanic_pop,
    (aac_male + aac_female) AS asian_pop
  FROM
    county_pop_data
  WHERE agegrp = 0 AND year = 8
  ORDER BY stname, county_fips)
  demographics
ON (tot_stops_by_race.county_fips = demographics.county_fips);

-- most common violates
CREATE TABLE violations AS
SELECT
  violation,
  count(violation) AS num_violations
FROM stops
GROUP BY violation
ORDER BY num_violations DESC;
