#!/bin/bash
path_to_data="$(pwd)/data"

# create database
db_name=stanford-open-police
createdb $db_name

# create tables
general_schema="
  id varchar,
  state varchar,
  stop_date date,
  stop_time varchar,
  location_raw varchar,
  county_name varchar,
  county_fips varchar,
  fine_grained_location varchar,
  police_department varchar,
  driver_gender varchar,
  driver_age_raw varchar,
  driver_age varchar,
  driver_race_raw varchar,
  driver_race varchar,
  violation_raw varchar,
  violation varchar,
  search_conducted bool,
  search_type_raw varchar,
  search_type varchar,
  contraband_found bool,
  stop_outcome varchar,
  is_arrested bool
"
general_fields="
  id,
  state,
  stop_date,
  stop_time,
  location_raw,
  county_name,
  county_fips,
  fine_grained_location,
  police_department,
  driver_gender,
  driver_age_raw,
  driver_age,
  driver_race_raw,
  driver_race,
  violation_raw,
  violation,
  search_conducted,
  search_type_raw,
  search_type,
  contraband_found,
  stop_outcome,
  is_arrested
"

# Create a table of all trips
psql -d $db_name -c "
CREATE TABLE stops($general_schema);
"

# Import AZ data
az_schema="
  $general_schema,
  officer_id varchar,
  stop_duration varchar,
  road_number varchar,
  milepost varchar,
  consent_search bool,
  vehicle_type varchar,
  ethnicity varchar
"
az_fields="
  $general_fields,
  officer_id,
  stop_duration,
  road_number,
  milepost,
  consent_search,
  vehicle_type,
  ethnicity
"
psql -d $db_name -c "
CREATE TABLE arizona($az_schema);
"
psql -d $db_name -c "
COPY arizona($az_fields) FROM
  '$path_to_data/AZ-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM arizona;
"

# Import CA data
ca_schema="
  $general_schema,
  ethnicity varchar
"
ca_fields="
  $general_fields,
  ethnicity
"
psql -d $db_name -c "
CREATE TABLE california($ca_schema);
"
psql -d $db_name -c "
COPY california($ca_fields) FROM
  '$path_to_data/CA-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM california;
"

# Import CO data
co_schema="
  $general_schema,
  officer_id varchar,
  officer_gender varchar,
  vehicle_type varchar,
  out_of_state varchar
"
co_fields="
  $general_fields,
  officer_id,
  officer_gender,
  vehicle_type,
  out_of_state
"
psql -d $db_name -c "
CREATE TABLE colorado($co_schema);
"
psql -d $db_name -c "
COPY colorado($co_fields) FROM
  '$path_to_data/CO-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM colorado;
"

# Import CT data
ct_schema="
  $general_schema,
  officer_id varchar,
  stop_duration varchar
"
ct_fields="
  $general_fields,
  officer_id,
  stop_duration
"
psql -d $db_name -c "
CREATE TABLE connecticut($ct_schema);
"
psql -d $db_name -c "
COPY connecticut($ct_fields) FROM
  '$path_to_data/CT-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM connecticut;
"

# Import FL data
fl_schema="
  $general_schema,
  officer_id varchar,
  officer_gender varchar,
  officer_age varchar,
  officer_race varchar,
  officer_rank varchar,
  out_of_state varchar
"
fl_fields="
  $general_fields,
  officer_id,
  officer_gender,
  officer_age,
  officer_race,
  officer_rank,
  out_of_state
"
psql -d $db_name -c "
CREATE TABLE florida($fl_schema);
"
psql -d $db_name -c "
COPY florida($fl_fields) FROM
  '$path_to_data/FL-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM florida;
"

# Import IA data
ia_schema="
  $general_schema,
  officer_id varchar,
  out_of_state varchar
"
ia_fields="
  $general_fields,
  officer_id,
  out_of_state
"
psql -d $db_name -c "
CREATE TABLE iowa($ia_schema);
"
psql -d $db_name -c "
COPY iowa($ia_fields) FROM
  '$path_to_data/IA-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM iowa;
"

# Import IL data
il_schema="
  $general_schema,
  stop_duration varchar,
  vehicle_type varchar,
  drugs_related_stop varchar,
  district varchar
"
il_fields="
  $general_fields,
  stop_duration,
  vehicle_type,
  drugs_related_stop,
  district
"
psql -d $db_name -c "
CREATE TABLE illinois($il_schema);
"
psql -d $db_name -c "
COPY illinois($il_fields) FROM
  '$path_to_data/IL-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM illinois;
"

# Import MA data
ma_schema="
  $general_schema,
  out_of_state varchar
"
ma_fields="
  $general_fields,
  out_of_state
"
psql -d $db_name -c "
CREATE TABLE massachusetts($ma_schema);
"
psql -d $db_name -c "
COPY massachusetts($ma_fields) FROM
  '$path_to_data/MA-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM massachusetts;
"

# Import MD data
md_schema="
  $general_schema,
  out_of_state varchar,
  arrest_reason varchar,
  stop_duration varchar,
  search_duration varchar
"
md_fields="
  $general_fields,
  out_of_state,
  arrest_reason,
  stop_duration,
  search_duration
"
psql -d $db_name -c "
CREATE TABLE maryland($md_schema);
"
psql -d $db_name -c "
COPY maryland($md_fields) FROM
  '$path_to_data/MD-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM maryland;
"

# Import MI data
mi_schema="
  $general_schema,
  officer_id varchar
"
mi_fields="
  $general_fields,
  officer_id
"
psql -d $db_name -c "
CREATE TABLE michigan($mi_schema);
"
psql -d $db_name -c "
COPY michigan($mi_fields) FROM
  '$path_to_data/MI-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM michigan;
"

# Import MO data
mo_schema="
  $general_schema
"
mo_fields="
  $general_fields
"
psql -d $db_name -c "
CREATE TABLE missouri($mo_schema);
"
psql -d $db_name -c "
COPY missouri($mo_fields) FROM
  '$path_to_data/MO-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM missouri;
"

# Import MS data
ms_schema="
  $general_schema,
  officer_id varchar
"
ms_fields="
  $general_fields,
  officer_id
"
psql -d $db_name -c "
CREATE TABLE mississippi($ms_schema);
"
psql -d $db_name -c "
COPY mississippi($ms_fields) FROM
  '$path_to_data/MS-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM mississippi;
"

# Import MT data
mt_schema="
  $general_schema,
  lat numeric,
  lon numeric,
  ethnicity varchar,
  city varchar,
  out_of_state bool,
  vehicle_year varchar,
  vehicle_make varchar,
  vehicle_model varchar,
  vehicle_style varchar,
  search_reason varchar,
  stop_outcome_raw varchar
"
mt_fields="
  $general_fields,
  lat,
  lon,
  ethnicity,
  city,
  out_of_state,
  vehicle_year,
  vehicle_make,
  vehicle_model,
  vehicle_style,
  search_reason,
  stop_outcome_raw
"
psql -d $db_name -c "
CREATE TABLE montana($mt_schema);
"
psql -d $db_name -c "
COPY montana($mt_fields) FROM
  '$path_to_data/MT-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM montana;
"

# Import NC data
nc_schema="
  $general_schema,
  district varchar,
  search_basis varchar,
  officer_id varchar,
  drugs_related_stop varchar,
  ethnicity varchar
"
nc_fields="
  $general_fields,
  district,
  search_basis,
  officer_id,
  drugs_related_stop,
  ethnicity
"
psql -d $db_name -c "
CREATE TABLE north_carolina($nc_schema);
"
psql -d $db_name -c "
COPY north_carolina($nc_fields) FROM
  '$path_to_data/NC-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM north_carolina;
"

# Import ND data
nd_schema="
  $general_schema,
  drugs_related_stop varchar
"
nd_fields="
  $general_fields,
  drugs_related_stop
"
psql -d $db_name -c "
CREATE TABLE north_dakota($nd_schema);
"
psql -d $db_name -c "
COPY north_dakota($nd_fields) FROM
  '$path_to_data/ND-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM north_dakota;
"

# Import NE data
ne_schema="
  $general_schema
"
ne_fields="
  $general_fields
"
psql -d $db_name -c "
CREATE TABLE nebraska($ne_schema);
"
psql -d $db_name -c "
COPY nebraska($ne_fields) FROM
  '$path_to_data/NE-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM nebraska;
"

# Import NH data
nh_schema="
  $general_schema,
  lat numeric,
  lon numeric,
  out_of_state bool,
  aerial_enforcement bool
"
nh_fields="
  $general_fields,
  lat,
  lon,
  out_of_state,
  aerial_enforcement
"
psql -d $db_name -c "
CREATE TABLE new_hampshire($nh_schema);
"
psql -d $db_name -c "
COPY new_hampshire($nh_fields) FROM
  '$path_to_data/NH-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM new_hampshire;
"

# Import NJ data
nj_schema="
  $general_schema,
  officer_id varchar,
  out_of_state bool,
  vehicle_make varchar,
  vehicle_model varchar,
  vehicle_color varchar
"
nj_fields="
  $general_fields,
  officer_id,
  out_of_state,
  vehicle_make,
  vehicle_model,
  vehicle_color
"
psql -d $db_name -c "
CREATE TABLE new_jersey($nj_schema);
"
psql -d $db_name -c "
COPY new_jersey($nj_fields) FROM
  '$path_to_data/NJ-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM new_jersey;
"

# Import NV data
nv_schema="
  $general_schema,
  drugs_related_stop varchar
"
nv_fields="
  $general_fields,
  drugs_related_stop
"
psql -d $db_name -c "
CREATE TABLE nevada($nv_schema);
"
psql -d $db_name -c "
COPY nevada($nv_fields) FROM
  '$path_to_data/NV-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM nevada;
"

# Import OH data
oh_schema="
  $general_schema,
  lat numeric,
  lon numeric,
  officer_id varchar,
  drugs_related_stop varchar
"
oh_fields="
  $general_fields,
  lat,
  lon,
  officer_id,
  drugs_related_stop
"
psql -d $db_name -c "
CREATE TABLE ohio($oh_schema);
"
psql -d $db_name -c "
COPY ohio($oh_fields) FROM
  '$path_to_data/OH-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM ohio;
"

# Import OR data
or_schema="
  $general_schema
"
or_fields="
  $general_fields
"
psql -d $db_name -c "
CREATE TABLE oregon($or_schema);
"
psql -d $db_name -c "
COPY oregon($or_fields) FROM
  '$path_to_data/OR-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM oregon;
"

# Import RI data
ri_schema="
  $general_schema,
  stop_duration varchar,
  out_of_state bool,
  drugs_related_stop varchar,
  district varchar
"
ri_fields="
  $general_fields,
  stop_duration,
  out_of_state,
  drugs_related_stop,
  district
"
psql -d $db_name -c "
CREATE TABLE rhode_island($ri_schema);
"
psql -d $db_name -c "
COPY rhode_island($ri_fields) FROM
  '$path_to_data/RI-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM rhode_island;
"

# Import SC data
sc_schema="
  $general_schema,
  lat numeric,
  lon numeric,
  officer_id varchar,
  officer_race varchar,
  officer_age varchar,
  highway_type varchar,
  road_number varchar,
  stop_purpose varchar
"
sc_fields="
  $general_fields,
  lat,
  lon,
  officer_id,
  officer_race,
  officer_age,
  highway_type,
  road_number,
  stop_purpose
"
psql -d $db_name -c "
CREATE TABLE south_carolina($sc_schema);
"
psql -d $db_name -c "
COPY south_carolina($sc_fields) FROM
  '$path_to_data/SC-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM south_carolina;
"

# Import SD data
sd_schema="
  $general_schema,
  vehicle_type varchar,
  out_of_state bool,
  drugs_related_stop varchar
"
sd_fields="
  $general_fields,
  vehicle_type,
  out_of_state,
  drugs_related_stop
"
psql -d $db_name -c "
CREATE TABLE south_dakota($sd_schema);
"
psql -d $db_name -c "
COPY south_dakota($sd_fields) FROM
  '$path_to_data/SD-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM south_dakota;
"

# Import TN data
tn_schema="
  $general_schema,
  road_number varchar,
  milepost varchar
"
tn_fields="
  $general_fields,
  road_number,
  milepost
"
psql -d $db_name -c "
CREATE TABLE tennessee($tn_schema);
"
psql -d $db_name -c "
COPY tennessee($tn_fields) FROM
  '$path_to_data/TN-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM tennessee;
"

# Import TX data
tx_schema="
  $general_schema,
  lat numeric,
  lon numeric,
  officer_id varchar,
  driver_race_original varchar
"
tx_fields="
  $general_fields,
  lat,
  lon,
  officer_id,
  driver_race_original
"
psql -d $db_name -c "
CREATE TABLE texas($tx_schema);
"
psql -d $db_name -c "
COPY texas($tx_fields) FROM
  '$path_to_data/TX-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM texas;
"

# Import VA data
va_schema="
  $general_schema,
  officer_id varchar,
  officer_race varchar
"
va_fields="
  $general_fields,
  officer_id,
  officer_race
"
psql -d $db_name -c "
CREATE TABLE virginia($va_schema);
"
psql -d $db_name -c "
COPY virginia($va_fields) FROM
  '$path_to_data/VA-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM virginia;
"

# Import VT data
vt_schema="
  $general_schema,
  officer_id varchar
"
vt_fields="
  $general_fields,
  officer_id
"
psql -d $db_name -c "
CREATE TABLE vermont($vt_schema);
"
psql -d $db_name -c "
COPY vermont($vt_fields) FROM
  '$path_to_data/VT-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM vermont;
"

# Import WA data
wa_schema="
  $general_schema,
  officer_id varchar,
  officer_gender varchar,
  officer_race varchar,
  highway_type varchar,
  road_number varchar,
  milepost varchar,
  violations varchar,
  lat numeric,
  lon numeric,
  contact_type varchar,
  enforcements varchar,
  drugs_related_stop varchar
"
wa_fields="
  $general_fields,
  officer_id,
  officer_gender,
  officer_race,
  highway_type,
  road_number,
  milepost,
  violations,
  lat,
  lon,
  contact_type,
  enforcements,
  drugs_related_stop
"
psql -d $db_name -c "
CREATE TABLE washington($wa_schema);
"
psql -d $db_name -c "
COPY washington($wa_fields) FROM
  '$path_to_data/WA-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM washington;
"

# Import WI data
wi_schema="
  $general_schema,
  lat numeric,
  lon numeric,
  officer_id varchar,
  vehicle_type varchar,
  drugs_related_stop varchar
"
wi_fields="
  $general_fields,
  lat,
  lon,
  officer_id,
  vehicle_type,
  drugs_related_stop
"
psql -d $db_name -c "
CREATE TABLE wisconsin($wi_schema);
"
psql -d $db_name -c "
COPY wisconsin($wi_fields) FROM
  '$path_to_data/WI-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM wisconsin;
"

# Import WY data
wy_schema="
  $general_schema,
  officer_id varchar,
  drugs_related_stop varchar
"
wy_fields="
  $general_fields,
  officer_id,
  drugs_related_stop
"
psql -d $db_name -c "
CREATE TABLE wyoming($wy_schema);
"
psql -d $db_name -c "
COPY wyoming($wy_fields) FROM
  '$path_to_data/WY-clean.csv'
DELIMITER
  ','
CSV HEADER;
"
psql -d $db_name -c "
INSERT INTO stops ($general_fields)
SELECT $general_fields
FROM wyoming;
"

# Import county data
county_schema="
  sumlev varchar,
  state varchar,
  county varchar,
  stname varchar,
  ctyname varchar,
  year numeric,
  agegrp numeric,
  tot_pop numeric,
  tot_male numeric,
  tot_female numeric,
  wa_male numeric,
  wa_female numeric,
  ba_male numeric,
  ba_female numeric,
  ia_male numeric,
  ia_female numeric,
  aa_male numeric,
  aa_female numeric,
  na_male numeric,
  na_female numeric,
  tom_male numeric,
  tom_female numeric,
  wac_male numeric,
  wac_female numeric,
  bac_male numeric,
  bac_female numeric,
  iac_male numeric,
  iac_female numeric,
  aac_male numeric,
  aac_female numeric,
  nac_male numeric,
  nac_female numeric,
  nh_male numeric,
  nh_female numeric,
  nhwa_male numeric,
  nhwa_female numeric,
  nhba_male numeric,
  nhba_female numeric,
  nhia_male numeric,
  nhia_female numeric,
  nhaa_male numeric,
  nhaa_female numeric,
  nhna_male numeric,
  nhna_female numeric,
  nhtom_male numeric,
  nhtom_female numeric,
  nhwac_male numeric,
  nhwac_female numeric,
  nhbac_male numeric,
  nhbac_female numeric,
  nhiac_male numeric,
  nhiac_female numeric,
  nhaac_male numeric,
  nhaac_female numeric,
  nhnac_male numeric,
  nhnac_female numeric,
  h_male numeric,
  h_female numeric,
  hwa_male numeric,
  hwa_female numeric,
  hba_male numeric,
  hba_female numeric,
  hia_male numeric,
  hia_female numeric,
  haa_male numeric,
  haa_female numeric,
  hna_male numeric,
  hna_female numeric,
  htom_male numeric,
  htom_female numeric,
  hwac_male numeric,
  hwac_female numeric,
  hbac_male numeric,
  hbac_female numeric,
  hiac_male numeric,
  hiac_female numeric,
  haac_male numeric,
  haac_female numeric,
  hnac_male numeric,
  hnac_female numeric
"

county_fields="
  sumlev,
  state,
  county,
  stname,
  ctyname,
  year,
  agegrp,
  tot_pop,
  tot_male,
  tot_female,
  wa_male,
  wa_female,
  ba_male,
  ba_female,
  ia_male,
  ia_female,
  aa_male,
  aa_female,
  na_male,
  na_female,
  tom_male,
  tom_female,
  wac_male,
  wac_female,
  bac_male,
  bac_female,
  iac_male,
  iac_female,
  aac_male,
  aac_female,
  nac_male,
  nac_female,
  nh_male,
  nh_female,
  nhwa_male,
  nhwa_female,
  nhba_male,
  nhba_female,
  nhia_male,
  nhia_female,
  nhaa_male,
  nhaa_female,
  nhna_male,
  nhna_female,
  nhtom_male,
  nhtom_female,
  nhwac_male,
  nhwac_female,
  nhbac_male,
  nhbac_female,
  nhiac_male,
  nhiac_female,
  nhaac_male,
  nhaac_female,
  nhnac_male,
  nhnac_female,
  h_male,
  h_female,
  hwa_male,
  hwa_female,
  hba_male,
  hba_female,
  hia_male,
  hia_female,
  haa_male,
  haa_female,
  hna_male,
  hna_female,
  htom_male,
  htom_female,
  hwac_male,
  hwac_female,
  hbac_male,
  hbac_female,
  hiac_male,
  hiac_female,
  haac_male,
  haac_female,
  hnac_male,
  hnac_female
"

psql -d $db_name -c "
CREATE TABLE county_pop_data($county_schema);
"
psql -d $db_name -c "
COPY county_pop_data($county_fields) FROM
  '$path_to_data/county-pop-utf-8.csv'
DELIMITER
  ','
CSV HEADER;
"
