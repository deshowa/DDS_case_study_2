##### This file creates the vectors and time series for all of the analysis in the project####

library(fpp)

clean_as_is_data<- read.csv("Analysis/data/tidy_as_is_data.csv")
clean_plan_data<- read.csv("Analysis/data/tidy_plan_data.csv")
clean_indicator_data<- read.csv("Analysis/data/tidy_indicator_data.csv")

colnames(clean_as_is_data)


# Pull 2013 and before into separate subset for analysis

asis_data<- subset(clean_as_is_data, year<=2013)

plan_data<- subset(clean_plan_data, year <=2013)


sapply(asis_data, class)

# I can see that the data in the datasets is not a time series, we will need them to be timeseries for this analysis
# asis data first
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
total_plan_ANNUAL_vect<- aggregate(plan_data$total_plan, list(plan_data$year), FUN = sum)[,2]

# since some of our economic indicators are annual only, I am going to create annual figures
blue_etel_as_is_ANNUAL_vect <- aggregate(asis_data$blue_etel_as_is, list(asis_data$year), FUN = sum)[,2]
red_etel_as_is_ANNUAL_vect <- aggregate(asis_data$red_etel_as_is, list(asis_data$year), FUN = sum)[,2]
total_etel_as_is_ANNUAL_vect <- aggregate(asis_data$total_etel_as_is, list(asis_data$year), FUN = sum)[,2]
efak_as_is_ANNUAL_vect<- aggregate(asis_data$efak_as_is, list(asis_data$year), FUN = sum)[,2]
wuge_as_is_ANNUAL_vect<- aggregate(asis_data$wuge_as_is, list(asis_data$year), FUN = sum)[,2]
total_as_is_ANNUAL_vect<- aggregate(asis_data$total_as_is, list(asis_data$year), FUN = sum)[,2]


# economic indicators next

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
total_plan_ANNUAL<- ts(total_plan_ANNUAL_vect, start = 2008, end = 2013, frequency = 1)

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
