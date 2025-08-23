# ==============================
# Cyclistic Bike-Share Analysis
# ==============================

# Load libraries
library(data.table)
library(dplyr)
library(ggplot2)

# Load data
trips <- fread("C:/Users/MI/OneDrive/Desktop/Cleaned_bicycledata.csv", header = FALSE)

# Add column names
setnames(trips, c("ride_id", "rideable_type", "started_at", "ended_at", 
                  "start_station_name", "start_station_id", "end_station_name", 
                  "end_station_id", "start_lat", "start_lng", "end_lat", "end_lng", 
                  "member_casual", "start_time", "end_time", "ride_length_minutes", 
                  "day_of_week"))

# Clean text columns
trips <- trips %>% mutate(across(where(is.character), ~ gsub('"', '', .)))

# Create folder for plots
if (!dir.exists("plots")) dir.create("plots")

# --------------------------
# 1. Rides by Bike Type
# --------------------------
p1 <- ggplot(trips, aes(x = rideable_type, fill = member_casual)) +
  geom_bar(position = "dodge") +
  theme_minimal() +
  labs(title = "Rides by Bike Type and Rider Type", x = "Bike Type", y = "Number of Rides")
print(p1)
ggsave("plots/rides_by_bike_type.png", p1, width = 8, height = 5)

# --------------------------
# 2. Rides by Day of Week
# --------------------------
p2 <- ggplot(trips, aes(x = day_of_week, fill = member_casual)) +
  geom_bar(position = "dodge") +
  theme_minimal() +
  labs(title = "Rides by Day of the Week", x = "Day", y = "Number of Rides")
print(p2)
ggsave("plots/rides_by_day.png", p2, width = 8, height = 5)

# --------------------------
# 3. Distribution of Ride Lengths
# --------------------------
p3 <- ggplot(trips, aes(x = ride_length_minutes, fill = member_casual)) +
  geom_histogram(binwidth = 5, alpha = 0.7, position = "identity") +
  xlim(0, 100) +
  theme_minimal() +
  labs(title = "Distribution of Ride Lengths", x = "Ride Length (minutes)", y = "Count")
print(p3)
ggsave("plots/ride_length_distribution.png", p3, width = 8, height = 5)

# --------------------------
# 4. Average Ride Length
# --------------------------
avg_length <- trips %>%
  group_by(member_casual) %>%
  summarise(avg_ride_length = mean(ride_length_minutes, na.rm = TRUE))
print(avg_length)

p4 <- ggplot(avg_length, aes(x = member_casual, y = avg_ride_length, fill = member_casual)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Ride Length by Member Type",
       x = "Member Type",
       y = "Average Ride Length (minutes)") +
  theme_minimal()
print(p4)
ggsave("plots/avg_ride_length.png", p4, width = 8, height = 5)

# --------------------------
# 5. Top Start Stations
# --------------------------
top_stations <- trips %>%
  group_by(start_station_name, member_casual) %>%
  summarise(total_rides = n()) %>%
  arrange(desc(total_rides)) %>%
  slice_head(n = 10)

p5 <- ggplot(top_stations, aes(x = reorder(start_station_name, total_rides), 
                               y = total_rides, fill = member_casual)) +
  geom_bar(stat = "identity", position = "dodge") +
  coord_flip() +
  labs(title = "Top 10 Start Stations by User Type", 
       x = "Station", y = "Number of Rides") +
  theme_minimal()
print(p5)
ggsave("plots/top_start_stations.png", p5, width = 8, height = 5)

# --------------------------
# Insights Summary (Console)
# --------------------------
cat("\n--- Insights ---\n")
cat("1. Casual riders generally take longer trips than members.\n")
cat("2. Members ride more consistently on weekdays (commuting pattern).\n")
cat("3. Casual riders are more active during weekends and prefer electric bikes.\n")
cat("4. Certain stations are more popular for casual riders (tourist areas).\n")
