library(httr)
library(rvest)
library(dplyr)
library(readr)

# Template URL for scraping team statistics
years <- 1980:2024
url_start <- 'https://www.basketball-reference.com/leagues/NBA_%s_standings.html'

# Dataframe to store team statistics
dfs <- list()

# Scrape team statistics for every year
for (year in years) {
  print(year)
  
  # Get website
  url <- sprintf(url_start, year)
  data <- GET(url)
  
  # Extract HTML and create parser for it
  html <- content(data, "text", encoding = "UTF-8")
  parser <- read_html(html)
  
  # Remove table break rows
  parser %>% html_nodes('tr.thead') %>% xml_remove()
  
  # Extract the Eastern Conference Divisions team stats table
  team_stats_table_E <- parser %>% html_node('#divs_standings_E')
  team_stats_E <- team_stats_table_E %>% html_table(fill = TRUE)
  
  # Add year column to dataframe
  team_stats_E$Year <- year
  
  # Convert column name from Eastern Conference to Team
  team_stats_E$Team <- team_stats_E$`Eastern Conference`
  team_stats_E <- team_stats_E %>% select(-`Eastern Conference`)
  
  # Add Eastern Conference team stats to list of data frames
  dfs[[length(dfs) + 1]] <- team_stats_E
  
  # Extract the Western Conference Divisions team stats table
  team_stats_table_W <- parser %>% html_node('#divs_standings_W')
  team_stats_W <- team_stats_table_W %>% html_table(fill = TRUE)
  
  # Add year column to dataframe
  team_stats_W$Year <- year
  
  # Convert column name from Western Conference to Team
  team_stats_W$Team <- team_stats_W$`Western Conference`
  team_stats_W <- team_stats_W %>% select(-`Western Conference`)
  
  # Add Western Conference team stats to list of data frames
  dfs[[length(dfs) + 1]] <- team_stats_W
  
  # Wait 2 seconds to scrape next year (required by Basketball Reference)
  Sys.sleep(2)
}

# Combine dataframes into one and save
team_stats <- bind_rows(dfs)
write_csv(team_stats, "Data/team_stats.csv")
