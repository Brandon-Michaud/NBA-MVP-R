library(httr)
library(rvest)
library(dplyr)
library(readr)

# Template URL for scraping player statistics
years <- 1980:2024
url_start <- 'https://www.basketball-reference.com/leagues/NBA_%s_per_game.html'

# Dataframe to store player statistics
dfs <- list()

# Scrape player statistics for every year
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
  
  # Locate player stats table and convert it to a dataframe
  player_stats_table <- parser %>% html_node('#per_game_stats')
  player_stats <- player_stats_table %>% html_table(fill = TRUE)
  
  # Add year column to dataframe
  player_stats$Year <- year
  
  # Add player stats dataframe to list of previous ones
  dfs[[length(dfs) + 1]] <- player_stats
  
  # Wait 2 seconds to scrape next year (required by Basketball Reference)
  Sys.sleep(2)
}

# Combine dataframes into one and save
player_stats <- bind_rows(dfs)
write_csv(player_stats, "Data/player_stats.csv")
