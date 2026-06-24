library(tidyverse)
#1. Importing the data--------------------------------------------------------
jan_2025 <- read_csv("202501-divvy-tripdata.csv")
feb_2025 <- read_csv("202502-divvy-tripdata.csv")
mar_2025 <- read_csv("202503-divvy-tripdata.csv")
apr_2025 <- read_csv("202504-divvy-tripdata.csv")
may_2025 <- read_csv("202505-divvy-tripdata.csv")
jun_2025 <- read_csv("202506-divvy-tripdata.csv")
jul_2025 <- read_csv("202507-divvy-tripdata.csv")
aug_2025 <- read_csv("202508-divvy-tripdata.csv")
sep_2025 <- read_csv("202509-divvy-tripdata.csv")
oct_2025 <- read_csv("202510-divvy-tripdata.csv")
nov_2025 <- read_csv("202511-divvy-tripdata.csv")
dec_2025 <- read_csv("202512-divvy-tripdata.csv")
#----------------------------------------------------------------------------#

#2. Ensuring all the fields match the correct name and data type--------------
glimpse(jan_2025) #Checked
glimpse(feb_2025) #Checked
glimpse(mar_2025) #Checked
glimpse(apr_2025) #Checked
glimpse(may_2025) #Checked
glimpse(jun_2025) #Checked
glimpse(jul_2025) #Checked
glimpse(aug_2025) #Checked
glimpse(sep_2025) #Checked
glimpse(oct_2025) #Checked
glimpse(nov_2025) #Checked
glimpse(dec_2025) #Checked
#----------------------------------------------------------------------------#

#3. Combining all the data sets into a single whole data set------------------
cyclistic_tripdata_2025 <- bind_rows(
  jan_2025,
  feb_2025,
  mar_2025,
  apr_2025,
  may_2025,
  jun_2025,
  jul_2025,
  aug_2025,
  sep_2025,
  oct_2025,
  nov_2025,
  dec_2025
)
#----------------------------------------------------------------------------#

#4. Verifying all the rows have successfully binded---------------------------
sum(
  nrow(jan_2025),
  nrow(feb_2025),
  nrow(mar_2025),
  nrow(apr_2025),
  nrow(may_2025),
  nrow(jun_2025),
  nrow(jul_2025),
  nrow(aug_2025),
  nrow(sep_2025),
  nrow(oct_2025),
  nrow(nov_2025),
  nrow(dec_2025)
)
#----------------------------------------------------------------------------#

#5. Ensuring Data Range (Ensured!)--------------------------------------------

#5.1 Ensuring started_at has valid timestamp
range(cyclistic_tripdata_2025$started_at, na.rm = FALSE)
range(as.Date(cyclistic_tripdata_2025$started_at), na.rm = FALSE)
range(format(cyclistic_tripdata_2025$started_at, "%H:%M:%S"), na.rm = FALSE)
#Status: Valid!

#5.2 Ensuring ended_at has valid timestamp
range(cyclistic_tripdata_2025$ended_at, na.rm = FALSE)
range(as.Date(cyclistic_tripdata_2025$ended_at), na.rm = FALSE)
range(format(cyclistic_tripdata_2025$ended_at, "%H:%M:%S"), na.rm = FALSE)
#Status: Valid!

#5.3 Ensuring start_lat and start_lng have valid timestamp
range(cyclistic_tripdata_2025$start_lat, na.rm = FALSE)
range(cyclistic_tripdata_2025$start_lng, na.rm = FALSE)
#Status: Valid!

#5.4 Ensuring end_lat and end_lng have valid timestamp
range(cyclistic_tripdata_2025$end_lat, na.rm = FALSE)
range(cyclistic_tripdata_2025$end_lng, na.rm = FALSE)

#It has N/A and it's acceptable so..
range(cyclistic_tripdata_2025$end_lat, na.rm = TRUE)
range(cyclistic_tripdata_2025$end_lng, na.rm = TRUE)
#Status: Valid!

#----------------------------------------------------------------------------#

#6. Ensuring Mandatoriness(Ensured!)------------------------------------------
colnames(cyclistic_tripdata_2025)
colSums(is.na(cyclistic_tripdata_2025[
  c("ride_id",
    "rideable_type",
    "started_at",
    "ended_at",
    "start_station_name",
    "start_station_id",
    "end_station_name",
    "end_station_id",
    "start_lat",
    "start_lng",
    "end_lat",
    "end_lng",
    "member_casual")
]))

#Additional checkups--
sum(is.na(cyclistic_tripdata_2025$ride_id)) #Ensured!
sum(is.na(cyclistic_tripdata_2025$rideable_type)) #Ensured!
sum(is.na(cyclistic_tripdata_2025$started_at)) #Ensured!
sum(is.na(cyclistic_tripdata_2025$ended_at)) #Ensured!
sum(is.na(cyclistic_tripdata_2025$member_casual)) #Ensured!
sum(is.na(cyclistic_tripdata_2025$end_lat))
sum(is.na(cyclistic_tripdata_2025$end_lng))
#----------------------------------------------------------------------------#

#7. Ensuring Data Uniqueness(Ensured!)----------------------------------------

#Layer1: Total rows vs. unique ride_id
nrow(cyclistic_tripdata_2025)
n_distinct(cyclistic_tripdata_2025$ride_id)
#Ensured!

#Layer2: Count duplicate ride_ids (if any)
sum(duplicated(cyclistic_tripdata_2025$ride_id))
#Ensured!

#----------------------------------------------------------------------------#

#8. Ensuring Regex patterns (Not Required)------------------------------------

#----------------------------------------------------------------------------#

#9. Ensuring cross-field validation (..v2 created here)(Ensured!)-------------
# Jan 17-18

#9.1 started_at must be lesser than ended_at
sum(cyclistic_tripdata_2025$started_at >= cyclistic_tripdata_2025$ended_at)
#WARNING: 29 invalid found

#View:
cyclistic_tripdata_2025 %>%
  filter(ended_at <= started_at) %>% print(n = 30) #To view

#Solution:
cyclistic_tripdata_2025_v2 <- cyclistic_tripdata_2025 %>%
  filter(ended_at > started_at) #Done!

#----------------------------------------------------------------------------#
#9.2 start_station_name cross-field validation:

#1.Shouldn’t exist if start_station_id is N/A
cyclistic_tripdata_2025_v2 %>%
  filter(is.na(start_station_id)) %>%
  distinct(start_station_name)
#Status: Ensured!

#2. Matches start_station_id
cyclistic_tripdata_2025_v2 %>%
  select(start_station_name, start_station_id) %>% unique() %>%
  group_by(start_station_name) %>%
  filter(n() > 1) %>%
  arrange(start_station_name)
#WARNING: Maps multiple id's

#----------------------------------------------------------------------------#
#9.3 start_station_id cross-field validation:

#1.Shouldn’t exist if start_station_name is N/A
cyclistic_tripdata_2025_v2 %>%
  filter(is.na(start_station_name)) %>%
  distinct(start_station_id)
#Status: Ensured!

#2. Matches start_station_name
cyclistic_tripdata_2025_v2 %>%
  select(start_station_id, start_station_name) %>% unique() %>%
  group_by(start_station_id) %>%
  filter(n() > 1) %>%
  arrange(start_station_id)
#WARNING: Maps multiple names, but those names look similar with just some
# minor letter differences or specifications

#----------------------------------------------------------------------------#
#9.4 end_station_name cross-field validation:

#1.Shouldn’t exist if end_station_id is N/A
cyclistic_tripdata_2025_v2 %>%
  filter(is.na(end_station_id)) %>%
  distinct(end_station_name)
#Status: Ensured!

#2. Matches end_station_id
cyclistic_tripdata_2025_v2 %>%
  select(end_station_name, end_station_id) %>% unique() %>%
  group_by(end_station_name) %>%
  filter(n() > 1) %>%
  arrange(end_station_name)
#WARNING: Maps multiple id's

#----------------------------------------------------------------------------#
#9.5 end_station_id cross-field validation:

#1.Shouldn’t exist if end_station_name is N/A
cyclistic_tripdata_2025_v2 %>%
  filter(is.na(end_station_name)) %>%
  distinct(end_station_id)
#Status: Ensured!

#2. Matches start_station_name
cyclistic_tripdata_2025_v2 %>%
  select(end_station_id, end_station_name) %>% unique() %>%
  group_by(end_station_id) %>%
  filter(n() > 1) %>%
  arrange(end_station_id)
#WARNING: Maps multiple names, but those names look similar with just some
# minor letter differences or specifications

#-----------------------------------------------------------------------#
#                                                                       #
# Conclusion: Use station names to represent stations instead of ID's   #
#                                                                       #
#-----------------------------------------------------------------------#

#----------------------------------------------------------------------------#
#9.6 start_lat cross-field validation:

#1.Shouldn’t exist if start_lng is N/A
cyclistic_tripdata_2025_v2 %>%
  filter(is.na(start_lng)) %>%
  distinct(start_lat)
#Status: Ensured!

#----------------------------------------------------------------------------#
#9.7 start_lng cross-field validation:

#1.Shouldn’t exist if start_lat is N/A
cyclistic_tripdata_2025_v2 %>%
  filter(is.na(start_lat)) %>%
  distinct(start_lng)
#Status: Ensured!

#----------------------------------------------------------------------------#
#9.8 end_lat cross-field validation:

#1.Shouldn’t exist if end_lng is N/A
cyclistic_tripdata_2025_v2 %>%
  filter(is.na(end_lng)) %>%
  distinct(end_lat)
#Status: Ensured!

#----------------------------------------------------------------------------#
#9.9 end_lng cross-field validation:

#1.Shouldn’t exist if end_lat is N/A
cyclistic_tripdata_2025_v2 %>%
  filter(is.na(end_lat)) %>%
  distinct(end_lng)
#Status: Ensured!

#----------------------------------------------------------------------------#

#10. Primary-key verification(Ensure!)----------------------------------------
nrow(cyclistic_tripdata_2025_v2) #Output: 5552965
n_distinct(cyclistic_tripdata_2025_v2$ride_id) #Output: 5552965
#Status: Ensured!

#11. Set-membership verification(Ensured!)------------------------------------

#rideable_type
unique(cyclistic_tripdata_2025_v2$rideable_type)
#Ensured!

#member_casual
unique(cyclistic_tripdata_2025_v2$member_casual)
#Ensured!

#----------------------------------------------------------------------------#

#12. DATA CLEANING(Ensured!)--------------------------------------------------

#12.1 Dirty Data: ***This should have been done earlier!*** (Ensured!)

#1.1 Remove duplicate data
n_distinct(cyclistic_tripdata_2025_v2) #Output: 5552965
nrow(cyclistic_tripdata_2025_v2) #Output: 5552965
# Ensured!

#1.2 Outdated data
range(as.Date(cyclistic_tripdata_2025_v2$started_at))
#Output: "2024-12-31" "2025-12-31"
#Ensured!

#1.3 Incomplete Data
#Already checked in the "Integrity Checkup" part
#Ensured!

#1.4 Incorrect/inaccurate data
#Covered in "Integrity Checkup"
#Ensured!

#1.5 Inconsistent data
#Single station represented by variety of ID's
#Also, ID's don't follow any predictable pattern
#Many stations are represented by multiple names
#Ensured!

#12.2 Trimming: ***This should have been done earlier too!*** (Ensured!)
cyclistic_tripdata_2025_v2 %>%
  filter(
    if_any(
      c(start_station_name, end_station_name, member_casual,
        rideable_type),
      ~ str_detect(.x, "^\\s|\\s$")
    )
  ) %>%
  nrow()
#Output: 0
#Ensured!

#13. ANALYZE (18 Jan)---------------------------------------------------------

#13.1 Removing unnecessary columns (..v3 created here)(Ensured!)----
cyclistic_tripdata_2025_v3 <- select(
  cyclistic_tripdata_2025_v2, -c(
    start_station_id,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng
  )
)
#----------------------------------------------------------------------------#

#13.2 Creating required columns(..v4;...v5 created here)(Ensured!)------------
# (You should have create required columns just after data
# binding and before Data integrity checkup)

#13.21 ride_length_min
cyclistic_tripdata_2025_v3 %>%
  mutate(
    ride_length_min = as.numeric(
      difftime(ended_at, started_at, units = "mins")
    )
  ) -> cyclistic_tripdata_2025_v4

#Checking for invalid ride lengths:
sum(cyclistic_tripdata_2025_v4$ride_length_min >= 1440,
    cyclistic_tripdata_2025_v4$ride_length_min < 1)
#Output: 152957
#WARNING: 152957 invalid found

#Removing invalids:
cyclistic_tripdata_2025_v5 <- cyclistic_tripdata_2025_v4 %>%
  filter(ride_length_min >=1, ride_length_min < 1440)

#Verification:
range(cyclistic_tripdata_2025_v5$ride_length_min)
#Output: 1.000 1439.976
#Status: Ensured!

#13.22 month, day_of_week and hour
cyclistic_tripdata_2025_v5 %>%
  mutate(
    month = month(started_at, label = TRUE),
    day_of_week = wday(started_at, label = TRUE),
    hour = hour(started_at)
  ) -> cyclistic_tripdata_2025_v5

#13.23 time_of_day
cyclistic_tripdata_2025_v5 %>%
  mutate(
    time_of_day = case_when(
      hour >= 0 & hour < 6 ~ "Night",
      hour >= 6 & hour < 12 ~ "Morning",
      hour >= 12 & hour < 18 ~ "Afternoon",
      hour >= 18 & hour < 24 ~ "Evening"
    )
  ) -> cyclistic_tripdata_2025_v5

#13.24 day_type
cyclistic_tripdata_2025_v5 %>%
  mutate(
    day_type = ifelse(day_of_week %in% c("Sat","Sun"), "Weekend",
                      "Weekday")
  ) -> cyclistic_tripdata_2025_v5

#13.25 trip_type
cyclistic_tripdata_2025_v5 %>%
  mutate(
    trip_type = ifelse(ride_length_min > 30, "Long", "Short")
  ) -> cyclistic_tripdata_2025_v5

#13.26 season
cyclistic_tripdata_2025_v5 %>%
  mutate(
    season = case_when(
      month %in% c("Dec", "Jan", "Feb") ~ "Winter",
      month %in% c("Mar", "Apr", "May") ~ "Spring",
      month %in% c("Jun", "Jul", "Aug") ~ "Summer",
      month %in% c("Sep", "Oct", "Nov") ~ "Fall"
    )
  ) -> cyclistic_tripdata_2025_v5
#----------------------------------------------------------------------------#

#13.3 Descriptive Analysis (19 Jan)(Ensured!)---------------------------------

#13.31 General Summaries
cyclistic_tripdata_2025_v5 %>%
  summarise(
    total_rides = n(),
    total_classic_bike = sum(rideable_type=="classic_bike"),
    total_electric_bike = sum(rideable_type == "electric_bike"),
    mean_ride_length = mean(ride_length_min),
    median_ride_length = median(ride_length_min),
    min_ride_length = min(ride_length_min),
    max_ride_length = max(ride_length_min),
    total_weekday = sum(day_type == "Weekday"),
    total_weekend = sum(day_type == "Weekend"),
    total_longtrips = sum(trip_type == "Long"),
    total_shorttrips = sum(trip_type == "Short")
  ) -> summary_by_general

#13.32 member vs casual
cyclistic_tripdata_2025_v5 %>% group_by(member_casual) %>%
  summarise(
    total_rides = n(),
    total_classic_bike = sum(rideable_type=="classic_bike"),
    total_electric_bike = sum(rideable_type == "electric_bike"),
    mean_ride_length = mean(ride_length_min),
    median_ride_length = median(ride_length_min),
    min_ride_length = min(ride_length_min),
    max_ride_length = max(ride_length_min),
    total_weekday = sum(day_type == "Weekday"),
    total_weekend = sum(day_type == "Weekend"),
    total_longtrips = sum(trip_type == "Long"),
    total_shorttrips = sum(trip_type == "Short")
  ) -> summary_by_usertype

#13.4 Time Series Analysis (Ensured!)-----------------------------------------
cyclistic_tripdata_2025_v5 %>%
  group_by(season, month) %>%
  summarise(
    n_member_rides = sum(member_casual=="member"),
    n_casual_rides = sum(member_casual=="casual"),
  ) -> time_series_analysis

#13.5 About Stations (Ensured!)-----------------------------------------------

#Start Station
cyclistic_tripdata_2025_v5 %>%
  group_by(start_station_name) %>%
  summarise(
    n_member_rides = sum(member_casual=="member"),
    n_casual_rides = sum(member_casual=="casual"),
  ) -> about_start_stations

#End Station
cyclistic_tripdata_2025_v5 %>%
  group_by(end_station_name) %>%
  summarise(
    n_member_rides = sum(member_casual=="member"),
    n_casual_rides = sum(member_casual=="casual"),
  ) -> about_end_stations

#14. Exporting Summaries------------------------------------------------------
library(writexl)
write_xlsx(
  list(
    "General Summary" = summary_by_general,
    "Member vs Casual" = summary_by_usertype,
    "Time Series Analysis" = time_series_analysis,
    "User Per Start Stations" = about_start_stations,
    "User Per End Stations" = about_end_stations
  ),
  "Cyclistic_Tripdata_Summary_2025.xlsx"
)