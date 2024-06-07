# NBA MVP Prediction Using R
This repository is a tutorial project for using NBA statistics to predict the league MVP in R.\
The material covered includes:
- Scraping data from the internet
- Wrangling the data into a usable data frame
- Building and testing both linear and non-linear models to predict the share of MVP votes a player receives
- Visualizing the fit of the models

This project began out of personal interest in predicting the MVP of the league and learning about statistics and machine learning methods.
I have made the repository publicly available for anyone else like me who is interested in learning data science skills.
I originally wrote the project in Python (see github.com/Brandon-Michaud/NBA-MVP-ML), 
but I translated it to R as a way to increase my knowledge of the language and also to allow others to learn in whichever language they desire.

## Project Structure
The project is broken into three phases: Scraping, Cleaning, and Learning.

### Scraping
The files for scraping can be found in the `/Scrapers` directory. 
Each of these files has a .R extension and must be run individually.
There is a file for scraping MVP voting every year, a file for scraping team records every year, and a file for scraping player stats every year.
I am scraping data from the 1979-80 season to present day, but you can change these values if so desired.
Each file should produce a .csv file that stores the combined stats for the corresponding file and stores them in the `/Data` directory.

### Cleaning
The file used for cleaning and combining the data is a R notebook named `data_cleaning.Rmd`.
The HTML produced by this notebook is stored in `data_cleaning.html`.
The notebook file handles missing data, matches team names and player names, and combines all three .csv files created by the scrapers 
into one file named `combined_stats.csv` stored in the `/Data` directory.

### Learning
The file used for making machine learning models is a R notebook named `machine_learning.Rmd`.
The HTML produced by this notebook is stored in `machine_learning.html`.
The notebook file uses the cleaned and combined data from the previous phase to create machine learning models to predict the share of MVP votes a player will get.
Linear regression, ridge regression, lasso regression, quadratic regression, and cubic regression models were all tested.

## Questions or Recommendations
If you are looking over the project and have any questions or recommendations, I would love to hear them.
You can send me an email with any questions or recommendations. You can also submit a pull request.
