library(httr)
library(rvest)
library(dplyr)
library(readr)

# Template URL for scraping MVP voting
years <- 1980:2024
url_start <- 'https://www.basketball-reference.com/awards/awards_%s.html'

# Dataframe to store MVP voting statistics
dfs <- list()

# Scrape MVP voting for every year
for (year in years) {
  print(year)
  
  # Get website
  url <- sprintf(url_start, year)
  data <- GET(url)
  
  # Extract HTML and create parser for it
  html <- content(data, "text", encoding = "UTF-8")
  parser <- read_html(html)
  
  # Remove high level table headers (Voting, Per Game, Shooting, Advanced)
  parser %>% html_nodes('tr.over_header') %>% xml_remove()
  
  # Locate MVP voting table and convert it to a dataframe
  mvp_voting_table <- parser %>% html_node('#mvp')
  mvp_voting <- mvp_voting_table %>% html_table(fill = TRUE)
  
  # Add year column to dataframe
  mvp_voting$Year <- year
  
  # Ensure that the rank is stored as a character (not integer)
  if("Rank" %in% names(mvp_voting)) {
    mvp_voting$Rank <- as.character(mvp_voting$Rank)
  }
  
  # Add MVP dataframe to list of previous ones
  dfs[[length(dfs) + 1]] <- mvp_voting
  
  # Wait 2 seconds to scrape next year (required by Basketball Reference)
  Sys.sleep(2)
}

# Combine dataframes into one and save
mvps <- bind_rows(dfs)
write_csv(mvps, "Data/mvp_voting.csv")
