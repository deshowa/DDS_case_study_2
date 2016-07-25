---
  title: 'Unit 10: Chulwalar Economic Study'
author: "Alex Deshowitz"
date: "July 17, 2016"
output: 
  html_document:
  keep_md: TRUE
---
  
  
  # Introduction
  ### We have been asked to assess the economic data for the country of Chulwalar and provide a forecast for the main exports of Chulwalar: Red Etel, Blue Etel, Wuge, and Efak.  In addition, we will provide forecasts for total Etel and Total exports and compare those values to the Chulwalar plan data.
  
  # Data cleaning
  ### Introduction: We were given 3 semicolon delimited files for this study to complete our work.  The files contained actual (as-is) data, planned data, and economic indicators for Chulwalar.  What proceeds is how we cleaning the data to make the data useable.  If you are not interested in the cleaning proces, please skip down to the EDA section.  The cleaning code can be found in the analysis directory for this project and is titled data_cleaning.R
  
  ### If you follow along, please ensure that your working directory is set and that your file structure is appropriate.  Additionally, you can copy this repo off of github.
  
  * First, ensure that the packages needed are loaded

```{r load_cleaning_packages, echo = TRUE, message = FALSE, WARNING = FALSE}

library("reshape2")
library("reshape")
library("tidyr")
library("gdata")

```

##### **CLEANING THE AS-IS DATA**

* read in the as-is data
```{r read_as_is, echo = TRUE}
data_test<- read.csv("Analysis/data/ImportedAsIsDataChulwalar.csv", sep = ";")
```

* Taking out the bad blank records since the data is oddly formatted

```{r filter_bd, echo = TRUE}
data_test<- data_test[c(-13,-14, -27, -28, -41, -42, -55, -56, -69, -70, -83, -84, -97),]
```

* We want to eventually get to where we have columns in the dataset, so we will create a column and append it for the variables

```{r add_new_column, echo = TRUE}

x<- c("total_as_is","efak_as_is","wuge_as_is", "total_etel_as_is","blue_etel_as_is", "red_etel_as_is", "total_yearly_exports_as_is")

y<-rep(x, each = 12)

data_test["new_col"]<- y
```

* I want to melt the data by The variable column and the new_col that I just added

```{r echo = TRUE}
data_new<- reshape2::melt(data_test, c("Total.As.Is", "new_col"))
```

* I need to rename the columns

```{r echo = TRUE}

names(data_new)<- c("month","variable","year","total_amount")

```

* we noticed that May and December were misnamed for some of the records.  This is an easy fix.

```{r echo = TRUE}

data_new$month[data_new$month=="Dez"] <- "Dec"

data_new$month[data_new$month=="Mai"] <- "May"

```

* Now I want to spread my columns out to make the dataset truly tidy

```{r echo = TRUE}

data_new_new<- spread(data_new, key= variable, value = total_amount)

```

* I also have to fix the year variable because of the way it was read in (there is an x in front of the number)

```{r echo = TRUE}

data_new_new$year<- substr(data_new_new$year, 2, 5)

data_new_new$year<- as.numeric(data_new_new$year)

```

* We would like to have a month number in the tidy data, so I will create the variable here.  I will also resort the columns to make it look like a true dimension
```{r echo = TRUE}

data_new_new["month_number"]<- match(data_new_new$month, month.abb)
data_new_new<-data_new_new[,c("month", "month_number", "year", "blue_etel_as_is", "red_etel_as_is", "total_etel_as_is", "efak_as_is", "wuge_as_is", "total_as_is", "total_yearly_exports_as_is")]

```

* Finally, let's sort the data in a logical order and rename the dataset

```{r echo = TRUE}

data_new_new<- data_new_new[order(data_new_new$year, data_new_new$month_number),]

as_is_data<-data_new_new

```


##### **CLEANING THE PLAN DATA**

* Read in the data first

```{r echo = TRUE}

plan_base<- read.csv("Analysis/data/ImportedPlanDataChulwalar.csv", sep = ";")

```

* Remove the rows we do not want

```{r echo = TRUE}

plan_base<- plan_base[c(-13,-14, -27, -28, -41, -42, -55, -56, -69, -70, -83, -84),]

```

* Create the column for the variable names in the dataset, and add it to the dataset

```{r echo = TRUE}

plan_names<- c("total_plan","efak_plan","wuge_plan", "total_etel_plan","blue_etel_plan", "red_etel_plan", "total_yearly_exports_plan")

plan_names_blowout<- rep(plan_names, each = 12)

plan_base["new_col"]<- plan_names_blowout

```

* Next, we melt the data and rename the variables for the new structure of the dataset.

```{r echo = TRUE}
plan_base_new<- reshape2::melt(plan_base, c("Total.Plan", "new_col"))

names(plan_base_new)<- c("month","variable","year","total_amount")

```
* Then we spread the data out so each variable is in a column and has its own name

```{r echo = TRUE}
plan_base_new_wide<- spread(plan_base_new, key= variable, value = total_amount)

plan_base_new_wide$year<- substr(plan_base_new_wide$year, 2, 5)

plan_base_new_wide$year<- as.numeric(plan_base_new_wide$year)

```

* I add in the new month number column, resort the columns, and sort the dataset to be in chronological order

```{r echo = TRUE}

plan_base_new_wide["month_number"]<- match(plan_base_new_wide$month, month.abb)

# move the column around

plan_base_new_wide<-plan_base_new_wide[,c("month", "month_number", "year", "blue_etel_plan", "red_etel_plan", "total_etel_plan", "efak_plan", "wuge_plan", "total_plan", "total_yearly_exports_plan")]


# Sort the plan data

plan_base_new_wide<- plan_base_new_wide[order(plan_base_new_wide$year, plan_base_new_wide$month_number),]

```

##### **CLEANING THE ECONOMIC DATA**

* Load the data in

```{r echo = TRUE}

ind_base<- read.csv("Analysis/data/ImportedIndicatorsChulwalar.csv", sep = ";")

```

* Remove the rows not wanted

```{r echo = TRUE}

ind_base<- ind_base[c(-13,-14, -27, -28, -41, -42, -55, -56, -69, -70, -83, -84, -97, -98, -111, -112, -125, -126, -139, -140, -153, -154, -167, -168, -181, -182),]

```

* Add in the new column for variable names

```{r echo = TRUE}
# names vector
ind_names<- c("chg_in_export_prices","satisfaction_index_gov","average_temperature", "births","satisfaction_index_indep", "total_exports_from_urbano", "globalisation_party_members", "average_export_price", "etel_production_price_index", "chulwalar_index", "inflation", "spending_for_chul_days", "chul_days", "infl_of_chul_days")

# blowout the names of variables for the columns
ind_names_blowout<- rep(ind_names, each = 12)

# create column for chulwar indicators

ind_base["new_col"]<- ind_names_blowout
```

* Melt the data down so that each year is not a column

```{r echo = TRUE}

ind_base_new<- reshape2::melt(ind_base, c("Change.in.export.prices", "new_col"))

# rename the columns

names(ind_base_new)<- c("month","variable","year","total_amount")
```

* Correct the month names

```{R echo = TRUE}

ind_base_new$month[ind_base_new$month=="Mai"] <- "May"

```

* Widen the variables into columns and rename the columns

```{r echo =TRUE}

ind_base_new_wide<- spread(ind_base_new, key= variable, value = total_amount)

# format the year column

ind_base_new_wide$year<- substr(ind_base_new_wide$year, 2, 5)

ind_base_new_wide$year<- as.numeric(ind_base_new_wide$year)

```

* Add in the month number reference, and sort the dataset

```{r echo = TRUE}

ind_base_new_wide["month_number"]<- match(ind_base_new_wide$month, month.abb)


# move the column around

ind_base_new_wide<-ind_base_new_wide[,c("month", "month_number", "year", "chg_in_export_prices","satisfaction_index_gov","average_temperature", "births","satisfaction_index_indep", "total_exports_from_urbano", "globalisation_party_members", "average_export_price", "etel_production_price_index", "chulwalar_index", "inflation", "spending_for_chul_days", "chul_days", "infl_of_chul_days")]

# sort it out

ind_base_new_wide<- ind_base_new_wide[order(ind_base_new_wide$year, ind_base_new_wide$month_number),]

```

* Now create nice clean .csv files

```{R echo = TRUE}

# now, let's make the cleaned up files

write.csv(as_is_data, "analysis/data/tidy_as_is_data.csv", row.names = FALSE)

write.csv(plan_base_new_wide, "analysis/data/tidy_plan_data.csv", row.names = FALSE)

write.csv(ind_base_new_wide, "analysis/data/tidy_indicator_data.csv", row.names = FALSE)

```

# Exploratory Data Analysis

### In the exploratory data analysis, we created time series out of the data, looked at the actual versus plan data,  evaluated the relationships between the data and the economic indicators, and decomposed the datasets using both classical and STL methods.  

### Note, if you are not interested in the EDA, please skip down to the forecasting section where we will have sourced all of the code.  The code for this section can be found in the analysis directory as data_analysis.R


##### **CREATING THE TIME SERIES**

* The first thing we will do is start fresh by clearing out the environment and putting just the newly cleaned datasets into the environment.  Notice, that we will source the data cleaning in case you have not run the other code.

```{R echo = TRUE, results = ('hide')}

source("analysis/data_cleaning.R")

ls()
rm(list = ls())
ls()

```

* Load in the required library.  Only one was needed.

```{r analysis_lib, , echo = TRUE, message = FALSE, WARNING = FALSE}

library(fpp) 

```

* Now, we can read in the data

```{R read_clean_data, echo = TRUE}

clean_as_is_data<- read.csv("Analysis/data/tidy_as_is_data.csv")
clean_plan_data<- read.csv("Analysis/data/tidy_plan_data.csv")
clean_indicator_data<- read.csv("Analysis/data/tidy_indicator_data.csv")

```

* Some of my data only goes out to 2013.  I need to account for this while comparing.  I do however create datasets to allow for analysis of 2014 where present as well.

```{R create_2013_sets, echo = TRUE}
asis_data<- subset(clean_as_is_data, year<=2013)

plan_data<- subset(clean_plan_data, year <=2013)

```

* I now need to create vectors for each of my variables.  I also create full year annual numbers because some of the econ data is full year only and not monthly.  I want to be able to compare these still.

```{r vectors_for_asis_and_plan, echo = TRUE}

blue_etel_as_is_vect <- asis_data$blue_etel_as_is
red_etel_as_is_vect <- asis_data$red_etel_as_is
total_etel_as_is_vect <- asis_data$total_etel_as_is
efak_as_is_vect<- asis_data$efak_as_is
wuge_as_is_vect<- asis_data$wuge_as_is
total_as_is_vect<- asis_data$total_as_is
total_as_is_inc_2014_vect<-clean_as_is_data$total_as_is

total_yearly_exports_as_is_vect<- aggregate(asis_data$total_yearly_exports_as_is, list(asis_data$year), FUN = mean)[,2] # aggregated to make dataframe, then subsetted the dataframe to make the numeric vector

# plan data next

blue_etel_plan_vect <- plan_data$blue_etel_plan
red_etel_plan_vect <- plan_data$red_etel_plan
total_etel_plan_vect <- plan_data$total_etel_plan
efak_plan_vect<- plan_data$efak_plan
wuge_plan_vect<- plan_data$wuge_plan
total_plan_vect<- plan_data$total_plan
total_plan_inc_2014_vect<-clean_plan_data$total_plan

# since some of our economic indicators are annual only, I am going to create annual figures
blue_etel_as_is_ANNUAL_vect <- aggregate(asis_data$blue_etel_as_is, list(asis_data$year), FUN = sum)[,2]
red_etel_as_is_ANNUAL_vect <- aggregate(asis_data$red_etel_as_is, list(asis_data$year), FUN = sum)[,2]
total_etel_as_is_ANNUAL_vect <- aggregate(asis_data$total_etel_as_is, list(asis_data$year), FUN = sum)[,2]
efak_as_is_ANNUAL_vect<- aggregate(asis_data$efak_as_is, list(asis_data$year), FUN = sum)[,2]
wuge_as_is_ANNUAL_vect<- aggregate(asis_data$wuge_as_is, list(asis_data$year), FUN = sum)[,2]
total_as_is_ANNUAL_vect<- aggregate(asis_data$total_as_is, list(asis_data$year), FUN = sum)[,2]

```


* I will do the same for the economic data

```{r economic_data, echo = TRUE}

econ_data<- subset(clean_indicator_data, year<=2013) # just filtering out the econ year for now so that they can be compared in R
colnames(clean_indicator_data)

chg_in_export_prices_vect<- econ_data$chg_in_export_prices
satisfaction_index_gov_vect<-econ_data$satisfaction_index_gov
average_temperature_vect<- econ_data$average_temperature
births_vect<- econ_data$births
satisfaction_index_indep_vect<- econ_data$satisfaction_index_indep
total_exports_from_urbano_vect<- econ_data$total_exports_from_urbano
globalisation_part_members_vect<- econ_data$globalisation_party_members
average_export_price_vect<- econ_data$average_export_price
etel_productions_price_index_vect<- econ_data$etel_production_price_index
chulwalar_index_vect<-econ_data$chulwalar_index
inflation_vect<-econ_data$inflation
spending_for_chul_days_vect<- econ_data$spending_for_chul_days
chul_days_vect<- econ_data$chul_days
infl_of_chul_days_vect<- econ_data$infl_of_chul_days

# need to make annual economic indicators data into annual series; keeping limited to 2013 because our other data sources are not complete for that period
total_exports_from_urbano_ANNUAL_vect<- aggregate(econ_data$total_exports_from_urbano, list(econ_data$year), FUN = mean)[,2]
globalisation_part_members_ANNUAL_vect<- aggregate(econ_data$globalisation_party_members, list(econ_data$year), FUN = mean)[,2]
spending_for_chul_days_ANNUAL_vect<- aggregate(econ_data$spending_for_chul_days, list(econ_data$year), FUN = mean)[,2]

```

* Now, we convert these over to the time_series format

```{r create_time_series, echo = TRUE}

# now convert variables to time series

blue_etel_as_is <- ts(blue_etel_as_is_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
red_etel_as_is <- ts(red_etel_as_is_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
total_etel_as_is <- ts(total_etel_as_is_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
efak_as_is<- ts(efak_as_is_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
wuge_as_is<- ts(wuge_as_is_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
total_as_is<- ts(total_as_is_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
total_as_is_inc_2014<- ts(total_as_is_inc_2014_vect, start = c(2008,1), end = c(2014,12), frequency = 12)
total_yearly_exports_as_is<- ts(total_yearly_exports_as_is_vect, start = c(2008,1), end = c(2013,12), frequency = 12)


# make the as is variables into annual time series

blue_etel_as_is_ANNUAL <- ts(blue_etel_as_is_ANNUAL_vect,start = 2008, end = 2013, frequency = 1)
red_etel_as_is_ANNUAL <- ts(red_etel_as_is_ANNUAL_vect,start = 2008, end = 2013, frequency = 1)
total_etel_as_is_ANNUAL <- ts(total_etel_as_is_ANNUAL_vect,start = 2008, end = 2013, frequency = 1)
efak_as_is_ANNUAL<- ts(efak_as_is_ANNUAL_vect,start = 2008, end = 2013, frequency = 1)
wuge_as_is_ANNUAL<- ts(wuge_as_is_ANNUAL_vect,start = 2008, end = 2013, frequency = 1)
total_as_is_ANNUAL<- ts(total_as_is_ANNUAL_vect,start = 2008, end = 2013, frequency = 1)

# convert the plan variables into time series

blue_etel_plan <- ts(blue_etel_plan_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
red_etel_plan <- ts(red_etel_plan_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
total_etel_plan <- ts(total_etel_plan_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
efak_plan<- ts(efak_plan_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
wuge_plan<- ts(wuge_plan_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
total_plan<- ts(total_plan_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
total_plan_inc_2014<-ts(total_plan_inc_2014_vect, start = c(2008,1), end = c(2014,12), frequency = 12)

# change the economic indicators into time series
chg_in_export_prices<- ts(chg_in_export_prices_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
satisfaction_index_gov<- ts(satisfaction_index_gov_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
average_temperature<- ts(average_temperature_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
births<- ts(births_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
satisfaction_index_indep<- ts(satisfaction_index_indep_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
total_exports_from_urbano<- ts(total_exports_from_urbano_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
globalisation_part_members<- ts(globalisation_part_members_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
average_export_price<- ts(average_export_price_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
etel_productions_price_index<- ts(etel_productions_price_index_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
chulwalar_index<-ts(chulwalar_index_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
inflation<-ts(inflation_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
spending_for_chul_days<- ts(spending_for_chul_days_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
chul_days<- ts(chul_days_vect, start = c(2008,1), end = c(2013,12), frequency = 12)
infl_of_chul_days<- ts(infl_of_chul_days_vect, start = c(2008,1), end = c(2013,12), frequency = 12)

# convert annual economic indicators to time series for analysis and correct visualization

total_exports_from_urbano_ANNUAL <- ts(total_exports_from_urbano_ANNUAL_vect, start = 2008, end = 2013, frequency = 1)
globalisation_part_members_ANNUAL <- ts(globalisation_part_members_ANNUAL_vect, start = 2008, end = 2013, frequency = 1)
spending_for_chul_days_ANNUAL<- ts(spending_for_chul_days_ANNUAL_vect, start = 2008, end = 2013, frequency = 1)

```

* Now that the data is in time series format, I just want to look at the information to see what it looks like.
* First, I will look at the data on a monthly basis

```{r echo = TRUE}

par(mfrow=c(3,2))

plot(total_as_is, col="black", main="TotalAsIs") # total as is seems to have very seasonal swings, but seasonal impacts do not appear to be increasing over time, so additive might makes sense
plot(efak_as_is , col="red",main="EfakAsIs") # efac is less seasonal and has seen a real takeoff since mid-2010
plot(wuge_as_is, col="blue", main="WugeAsIs") # wuge has consistently moved higher with seasonal fluctuations that are less pronounced
plot(total_etel_as_is, col="green",main="TotalEtelAsIs") # Overall etel sees minimal growth but definite seasonal trends
plot(blue_etel_as_is, col="orange", main="BlueEtelAsIs") # the blue variety of etel seems to be a little more volatile than the red etal, but sells alot less than the red
plot(red_etel_as_is, col="purple", main="RedEtelAsIs") # the red sells alot more than the blue and evidences in the overall trend for total etel, we may be seeing larger seasonal spikes and a multiplicative model may be best for this type of data

```

##### Based on this graph, we can see that:
* The data are seasonal
* Blue etel seems to be more volatile than red, but also exports alot less
* We can hypothesize that the multiplicative model may make sense since visually some of these variables seem to be moving up in seasonality over time

* Next, I want to see the data on an annual basis
```{r annual_read, echo = TRUE}
par(mfrow=c(3,2))
plot(total_as_is_ANNUAL, col="black", main="TotalAsIs") 
plot(efak_as_is_ANNUAL , col="red",main="EfakAsIs") 
plot(wuge_as_is_ANNUAL, col="blue", main="WugeAsIs") 
plot(total_etel_as_is_ANNUAL, col="green",main="TotalEtelAsIs") 
plot(blue_etel_as_is_ANNUAL, col="orange", main="BlueEtelAsIs") 
plot(red_etel_as_is_ANNUAL, col="purple", main="RedEtelAsIs")

```

##### The blue etel catches my attention on an annual basis as we see a large dip.  Could there have been a bad crop?  Disease?  It does look like the demand has recovered and grown really nicely.  We would not have seen this on a monthly level necessarily.

* Let's see which exports are the largest for the country

```{r annual_barplot, echo = TRUE}

efak_as_is_2013<-   efak_as_is_ANNUAL[length(efak_as_is_ANNUAL)]
wuge_as_is_2013<-   wuge_as_is_ANNUAL[length(wuge_as_is_ANNUAL)]
total_etel_as_is_2013<-   total_etel_as_is_ANNUAL[length(total_etel_as_is_ANNUAL)]
blue_etel_as_is_2013<-   blue_etel_as_is_ANNUAL[length(blue_etel_as_is_ANNUAL)]
red_etel_as_is_2013<-   red_etel_as_is_ANNUAL[length(blue_etel_as_is_ANNUAL)]

par(mfrow = c(1,1))
barplot(rbind(c(efak_as_is_2013,wuge_as_is_2013,
total_etel_as_is_2013, blue_etel_as_is_2013, red_etel_as_is_2013))
, main = "Total exports by type 2013", names.arg= c("efak","wuge","total etel","blue_etel","red_etel")
, col = c("dark blue")
)

```

##### It is evident that etel, driven by the red variety is the largest export for Chulwalar.  Etel is followed by Efak, and Wuge in order

* I am also interested in the relationship of these exports with economic indicators.  I will now look at the correlation between the variables

##### **Export Prices**
```{r export_prices, echo = TRUE}
par(mfrow = c (1, 1))
plot(chg_in_export_prices, main="Change in export prices")

cor(total_as_is, chg_in_export_prices)
cor(efak_as_is , chg_in_export_prices)
cor(wuge_as_is, chg_in_export_prices)
cor(total_etel_as_is, chg_in_export_prices)
cor(blue_etel_as_is , chg_in_export_prices)
cor(red_etel_as_is , chg_in_export_prices)

```

##### It looks like efak has a very strong positive correlation to export prices as do Wuge and, to a somewhat lesser extent, total asis.  The other variables appear to be unrelated

##### **Government Satisfaction Index**

```{r government_satis, echo = TRUE}

plot(satisfaction_index_gov, main="govt satisfaction index")


cor(total_as_is, satisfaction_index_gov)
cor(efak_as_is , satisfaction_index_gov)
cor(wuge_as_is, satisfaction_index_gov)
cor(total_etel_as_is, satisfaction_index_gov)
cor(blue_etel_as_is , satisfaction_index_gov)
cor(red_etel_as_is , satisfaction_index_gov)

```

#####  It looks like there was some sort of downturn in the economy or potentially political unrest that started in mid-2008, but was over with by about 1Q2009.  The overall satisfaction measured by the government seems to be in good shape now.  None of the exports appear to be strongly related to the index.

##### **Temperature**

```{r temp, echo = TRUE}

plot(average_temperature, main="average temperature")


cor(total_as_is, average_temperature)
cor(efak_as_is , average_temperature)
cor(wuge_as_is, average_temperature)
cor(total_etel_as_is, average_temperature)
cor(blue_etel_as_is , average_temperature)
cor(red_etel_as_is , average_temperature)

```

##### As we might expect, temperature is seasonal, but does not appear to be increasing over time.
##### Blue etel appears to be moderately negatively related to temperature.  Therefore, when temperature rises, we might expect demand to slow down for blue etel.  This appears to be a very seasonal item.  The other variables do not appear to have any notable relationships.

##### **Births**

```{r births, echo = TRUE}
plot(births, main = "monthly births in chulwalar")


cor(total_as_is, births)
cor(efak_as_is , births)
cor(wuge_as_is, births)
cor(total_etel_as_is, births)
cor(blue_etel_as_is , births)
cor(red_etel_as_is , births)

```

##### The data appear to be seasonal with no relationships worth commenting on.

##### ** Satisfaction Index- External**

```{r ext_satis_ind, echo = TRUE}
plot(satisfaction_index_indep, main = "independent satisfaction index")



cor(total_as_is, satisfaction_index_indep)
cor(efak_as_is , satisfaction_index_indep)
cor(wuge_as_is, satisfaction_index_indep)
cor(total_etel_as_is, satisfaction_index_indep)
cor(blue_etel_as_is , satisfaction_index_indep)
cor(red_etel_as_is , satisfaction_index_indep)

# It looks like people buy alot of efak when they are happy (r = 0.836).  Wuge seems to be strongly correlated with this satisfaction index as well (r = 0.67)

```

##### We see the same thing here regarding potential recession or downturn in 2008
##### Additionally, It looks like people buy efak when they are happy (r = 0.836).  Wuge seems to be strongly correlated with this satisfaction index as well (r = 0.67)


##### ** Total Urbano Exports **

```{r urbano_exp, echo = TRUE}
plot(total_exports_from_urbano_ANNUAL, main = "Total Urbano exports")

cor(total_as_is_ANNUAL, total_exports_from_urbano_ANNUAL)
cor(efak_as_is_ANNUAL , total_exports_from_urbano_ANNUAL)
cor(wuge_as_is_ANNUAL, total_exports_from_urbano_ANNUAL)
cor(total_etel_as_is_ANNUAL, total_exports_from_urbano_ANNUAL)
cor(blue_etel_as_is_ANNUAL , total_exports_from_urbano_ANNUAL)
cor(red_etel_as_is_ANNUAL , total_exports_from_urbano_ANNUAL)

```
#####these indicators seem to have very high correlations with all variables except blue etel.  However, these are just annual datapoints, so we may need to proceed with caution when making claims about the relationships.


######** GLobalization Party Members**

```{r glob_party_mem, echo = TRUE}
plot(globalisation_part_members_ANNUAL, main = "Globalization party members")


cor(total_as_is_ANNUAL, globalisation_part_members_ANNUAL)
cor(efak_as_is_ANNUAL , globalisation_part_members_ANNUAL)
cor(wuge_as_is_ANNUAL, globalisation_part_members_ANNUAL)
cor(total_etel_as_is_ANNUAL, globalisation_part_members_ANNUAL)
cor(blue_etel_as_is_ANNUAL , globalisation_part_members_ANNUAL)
cor(red_etel_as_is_ANNUAL , globalisation_part_members_ANNUAL)

# once again see the strong relationship like we did for total exports, but this could be due to the data being annual with only 6 observations
# Maybe as exports increase, globalisation party members tend to increase to participate in the trade? 
```

##### **Monthly Average Export Price Index**


```{r export_pr_ind, echo = TRUE}
plot(average_export_price, main = "Average export prices")



cor(total_as_is, average_export_price)
cor(efak_as_is , average_export_price)
cor(wuge_as_is, average_export_price)
cor(total_etel_as_is, average_export_price)
cor(blue_etel_as_is , average_export_price)
cor(red_etel_as_is , average_export_price)
```


##### The overall trend has been upward since mid-2009
##### efak (.91), wuge (.72), and total (.63) have good correlations

###### **ETEL production price index**

```{r etel_ppi, echo = TRUE}
plot(etel_productions_price_index, main = "Etel production price index")


cor(total_as_is, etel_productions_price_index)
cor(efak_as_is , etel_productions_price_index)
cor(wuge_as_is, etel_productions_price_index)
cor(total_etel_as_is, etel_productions_price_index)
cor(blue_etel_as_is , etel_productions_price_index)
cor(red_etel_as_is , etel_productions_price_index)

```
##### Costs seem to have gotten pretty high over the past couple of years.  I wonder if this has hit blue etel more than red etel

##### Etel doesnt seem to be correlated very highly (blue or red) (r = 0.33)


##### **Chulwalar index**

```{r chul_ind, echo = TRUE}
plot(chulwalar_index, main = "Chulwalar index")

cor(total_as_is, chulwalar_index)
cor(efak_as_is , chulwalar_index)
cor(wuge_as_is, chulwalar_index)
cor(total_etel_as_is, chulwalar_index)
cor(blue_etel_as_is , chulwalar_index)
cor(red_etel_as_is , chulwalar_index)

```

##### we do not have alot of metadata about this variabe, but it has a similar trend to the independent sentiment survey.
##### Efak looks to be strongly related to the index (r = 0.71).  However, there are no other relationships on which to comment.

##### **Inflation**

```{r inflation, echo =TRUE}
plot(inflation, main = "Inflation")

cor(total_as_is, inflation)
cor(efak_as_is , inflation)
cor(wuge_as_is, inflation)
cor(total_etel_as_is, inflation)
cor(blue_etel_as_is , inflation)
cor(red_etel_as_is , inflation)

```

##### Inflation was relatively high in 2008 for the period plotted but dropped about the time that we saw a drop in sentiment in the previous data.  It is looking like we may have something like a recession here.  I am apprehensive about saying this was a recession.  We do not know if this is a small part of a larger trend.  However, negative inflation is not something that we see in a robust economy.
##### Amazingly, these exports seem to be resistant to or unrelated to inflation or overall economic trends.  Could some of the trends we are seeing in the economic data be strictly isolated to Chulwalar and not more global?

##### **Spending for Chulwalar Days**


```{r spending_chul_days, echo = TRUE}
plot(spending_for_chul_days_ANNUAL, main = "Chulwalar day spending")

cor(total_as_is_ANNUAL, spending_for_chul_days_ANNUAL)
cor(efak_as_is_ANNUAL , spending_for_chul_days_ANNUAL)
cor(wuge_as_is_ANNUAL, spending_for_chul_days_ANNUAL)
cor(total_etel_as_is_ANNUAL, spending_for_chul_days_ANNUAL)
cor(blue_etel_as_is_ANNUAL , spending_for_chul_days_ANNUAL)
cor(red_etel_as_is_ANNUAL , spending_for_chul_days_ANNUAL)


```

##### It is funny that when it looked like we were seeing some declines in sentiment, that spending on Chulwalar days went up.  I wonder if this was people's big splurge to feel good about the extrinsic factors impacting their lives.

#### Al variables has a decent positive correlation.  However, Etel seems to be the big item that is related to spending on these days.

##### ** Chulwalar Days and influence**

```{r chul_day, echo = TRUE}
plot(infl_of_chul_days, col = "blue", main= "Influence of Chulwalar days")
lines(chul_days, col = "red")
```

##### We just wanted to put these on a graph to (poorly) visualize when these days occur and what periods act as influence periods.

##### It looks like there may be some influence in the months preceeding the large holidays.  This is a good thing to know when looking at the data.



