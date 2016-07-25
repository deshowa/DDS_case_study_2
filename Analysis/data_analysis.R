
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

# want to look at these on a graph

par(mfrow=c(3,2))

plot(total_as_is, col="black", main="TotalAsIs") # total as is seems to have very seasonal swings, but seasonal impacts do not appear to be increasing over time, so additive might makes sense
plot(efak_as_is , col="red",main="EfakAsIs") # efac is less seasonal and has seen a real takeoff since mid-2010
plot(wuge_as_is, col="blue", main="WugeAsIs") # wuge has consistently moved higher with seasonal fluctuations that are less pronounced
plot(total_etel_as_is, col="green",main="TotalEtelAsIs") # Overall etel sees minimal growth bu definite seasonal trends
plot(blue_etel_as_is, col="orange", main="BlueEtelAsIs") # the blue variety of etel seems to be a little more volatile than the red etal, but sells alot less than the red
plot(red_etel_as_is, col="purple", main="RedEtelAsIs") # the red sells alot more than the blue and evidences in the overall trend for total etel, we may be seeing larger seasonal spikes and a multiplicative model may be best for this type of data

# just want to look at it on an annual basis
par(mfrow=c(3,2))
plot(total_as_is_ANNUAL, col="black", main="TotalAsIs") # total as is seems to have very seasonal swings, but seasonal impacts do not appear to be increasing over time, so additive might makes sense
plot(efak_as_is_ANNUAL , col="red",main="EfakAsIs") # efac is less seasonal and has seen a real takeoff since mid-2010
plot(wuge_as_is_ANNUAL, col="blue", main="WugeAsIs") # wuge has consistently moved higher with seasonal fluctuations that are less pronounced
plot(total_etel_as_is_ANNUAL, col="green",main="TotalEtelAsIs") # Overall etel sees minimal growth bu definite seasonal trends
plot(blue_etel_as_is_ANNUAL, col="orange", main="BlueEtelAsIs") # the blue variety of etel seems to be a little more volatile than the red etal, but sells alot less than the red
plot(red_etel_as_is_ANNUAL, col="purple", main="RedEtelAsIs") # the red sells alot more than the blue and evidences in the overall trend for total etel, we may be seeing larger seasonal spikes and a multiplicative model may be best for this type of data

# blue etel  really saw a dip in 2011.  Interesting.  Wonder if there was a bad crop or some sort of externality that impacted the production/demand.  Any number of items could be the cause.  However, it appears that it was realted to blue and not red


# just for comparison of exports, I want to see how they all look in the data

efak_as_is_2013<-   efak_as_is_ANNUAL[length(efak_as_is_ANNUAL)]
wuge_as_is_2013<-   wuge_as_is_ANNUAL[length(wuge_as_is_ANNUAL)]
total_etel_as_is_2013<-   total_etel_as_is_ANNUAL[length(total_etel_as_is_ANNUAL)]
blue_etel_as_is_2013<-   blue_etel_as_is_ANNUAL[length(blue_etel_as_is_ANNUAL)]
red_etel_as_is_2013<-   red_etel_as_is_ANNUAL[length(blue_etel_as_is_ANNUAL)]

# just to check, do red and blue add up to total
(blue_etel_as_is_2013 + red_etel_as_is_2013) - total_etel_as_is_2013
# off by 1 maybe slight rounding...not a big deal

par(mfrow = c(1,1))
barplot(rbind(c(efak_as_is_2013,wuge_as_is_2013,
                total_etel_as_is_2013, blue_etel_as_is_2013, red_etel_as_is_2013))
        , main = "Total exports by type 2013", names.arg= c("efak","wuge","total etel","blue_etel","red_etel")
        , col = c("dark blue")
)

#So, etel is by far the largest export (mainly red etel), followed by efak and then wuge

# Now, let's see how highly correlated our data are with economic indicators

## First up is change in export prices
par(mfrow = c (1, 1))
plot(chg_in_export_prices, main="Change in export prices")

cor(total_as_is, chg_in_export_prices)
cor(efak_as_is , chg_in_export_prices)
cor(wuge_as_is, chg_in_export_prices)
cor(total_etel_as_is, chg_in_export_prices)
cor(blue_etel_as_is , chg_in_export_prices)
cor(red_etel_as_is , chg_in_export_prices)

# looks like efak has a very strong positive correlation to export prices as do Wuge and to a somewhat lesser extent, total exports


## government satisfaction index

plot(satisfaction_index_gov, main="govt satisfaction index")

# must have had a recession or some sort of political issue in 2009 and resolved by 2011


# nothing really pops here...maybe slight positive relationship of WUGE and efak...nothing else

cor(total_as_is, satisfaction_index_gov)
cor(efak_as_is , satisfaction_index_gov)
cor(wuge_as_is, satisfaction_index_gov)
cor(total_etel_as_is, satisfaction_index_gov)
cor(blue_etel_as_is , satisfaction_index_gov)
cor(red_etel_as_is , satisfaction_index_gov)


##temperature view

plot(average_temperature, main="average temperature")

# very seasonal and pretty much the same...so much for global warming?? :)

cor(total_as_is, average_temperature)
cor(efak_as_is , average_temperature)
cor(wuge_as_is, average_temperature)
cor(total_etel_as_is, average_temperature)
cor(blue_etel_as_is , average_temperature)
cor(red_etel_as_is , average_temperature)

# looks like blue etel has a strong negative relationship with the average temperature

## Let's look at births in chulwalar next

plot(births, main = "monthly births in chulwalar")
# looks like a very seasonal dataset with no real trend in any direction.  The data simply moves sideways.  We might use an additive model here if needed



cor(total_as_is, births)
cor(efak_as_is , births)
cor(wuge_as_is, births)
cor(total_etel_as_is, births)
cor(blue_etel_as_is , births)
cor(red_etel_as_is , births)

# there do not appear to be any strong relationships between births and any of the exports.


## Satisfaction index external

plot(satisfaction_index_indep, main = "independent satisfaction index")

# the people of chulwalar seem to be pretty happy.  It looks like maybe there was a war, political unrest, or some sort of recession in mid 2008 that caused a major downturn. 
#It looks like something else may have happened in late 2010 and early 2011 to caused some detraction
# overall, there appears to be a strong uptrend with a very noticeable spike in late 2013

cor(total_as_is, satisfaction_index_indep)
cor(efak_as_is , satisfaction_index_indep)
cor(wuge_as_is, satisfaction_index_indep)
cor(total_etel_as_is, satisfaction_index_indep)
cor(blue_etel_as_is , satisfaction_index_indep)
cor(red_etel_as_is , satisfaction_index_indep)

# It looks like people buy alot of efak when they are happy (r = 0.836).  Wuge seems to be strongly correlated with this satisfaction index as well (r = 0.67)

## Looking at total Urbano exports next; For this one, we need to use the annual datasets

plot(total_exports_from_urbano_ANNUAL, main = "Total Urbano exports")

cor(total_as_is_ANNUAL, total_exports_from_urbano_ANNUAL)
cor(efak_as_is_ANNUAL , total_exports_from_urbano_ANNUAL)
cor(wuge_as_is_ANNUAL, total_exports_from_urbano_ANNUAL)
cor(total_etel_as_is_ANNUAL, total_exports_from_urbano_ANNUAL)
cor(blue_etel_as_is_ANNUAL , total_exports_from_urbano_ANNUAL)
cor(red_etel_as_is_ANNUAL , total_exports_from_urbano_ANNUAL)

# these indicators seem to have very high correlations with all variables except blue etel.  However, these are just annual datapoints, so we may need to proceed with caution

## Globalization party members

plot(globalisation_part_members_ANNUAL, main = "Globalization party members")

# very linear and strong relationship, but the trend has been flattened since 2011

cor(total_as_is_ANNUAL, globalisation_part_members_ANNUAL)
cor(efak_as_is_ANNUAL , globalisation_part_members_ANNUAL)
cor(wuge_as_is_ANNUAL, globalisation_part_members_ANNUAL)
cor(total_etel_as_is_ANNUAL, globalisation_part_members_ANNUAL)
cor(blue_etel_as_is_ANNUAL , globalisation_part_members_ANNUAL)
cor(red_etel_as_is_ANNUAL , globalisation_part_members_ANNUAL)

# once again see the strong relationship like we did for total exports, but this could be due to the data being annual with only 6 observations
# Maybe as exports increase, globalisation party members tend to increase to participate in the trade? 

########## maybe do this for the output file as.table(c(a,b)) ##########


## Monthly average export price index

plot(average_export_price, main = "Average export prices")

# overall have been on an upward trend since mid-2009

cor(total_as_is, average_export_price)
cor(efak_as_is , average_export_price)
cor(wuge_as_is, average_export_price)
cor(total_etel_as_is, average_export_price)
cor(blue_etel_as_is , average_export_price)
cor(red_etel_as_is , average_export_price)

# efak (.91), wuge (.72), and total (.63) have good correlations

##ETEL production price index

plot(etel_productions_price_index, main = "Etel production price index")

# costs seem to have gotten pretty high over the past couple of years.  I wonder if this hurt demand for Etel and if there is any collinearity with other variables


cor(total_as_is, etel_productions_price_index)
cor(efak_as_is , etel_productions_price_index)
cor(wuge_as_is, etel_productions_price_index)
cor(total_etel_as_is, etel_productions_price_index)
cor(blue_etel_as_is , etel_productions_price_index)
cor(red_etel_as_is , etel_productions_price_index)

# well, etel doesnt seem to be correlated very highly (blue nor red) (r = 0.33)

## Chulwalar index

plot(chulwalar_index, main = "Chulwalar index")
# we do not have alot of data about this but it has a similar trend to the independent sentiment survey

cor(total_as_is, chulwalar_index)
cor(efak_as_is , chulwalar_index)
cor(wuge_as_is, chulwalar_index)
cor(total_etel_as_is, chulwalar_index)
cor(blue_etel_as_is , chulwalar_index)
cor(red_etel_as_is , chulwalar_index)

# Efak looks to be strongly related to the index (r = 0.71).  This is speaking relatively of course.


## Inflation next

plot(inflation, main = "Inflation")

# inflation was realtively high in 2008 for the period plotted but dropped about the time that we saw a drop in sentiment in the previous data.  It is looking like we may have something like a recession here.  I am apprehensive about saying this was a recession.  We do not know if this is a small part of a larger trend.  However, negative inflation is not something that we see in a robust economy.


cor(total_as_is, inflation)
cor(efak_as_is , inflation)
cor(wuge_as_is, inflation)
cor(total_etel_as_is, inflation)
cor(blue_etel_as_is , inflation)
cor(red_etel_as_is , inflation)

# amazingly, these exports seem to be resistant to or unrelated to inflation or overall economic trends.  Could some of the trends we are seeing in the economic data be strictly isolated to Chulwalar and not more global?

## Spending for Chulwalar Days - needs to be annual

plot(spending_for_chul_days_ANNUAL, main = "Chulwalar day spending")

# funny that when it looked like we were seeing some economic weakness, that spending on Chulwalar days went up.  I wonder if this was people's big splurge to feel good about the extrinsic factors impacting their lives

cor(total_as_is_ANNUAL, spending_for_chul_days_ANNUAL)
cor(efak_as_is_ANNUAL , spending_for_chul_days_ANNUAL)
cor(wuge_as_is_ANNUAL, spending_for_chul_days_ANNUAL)
cor(total_etel_as_is_ANNUAL, spending_for_chul_days_ANNUAL)
cor(blue_etel_as_is_ANNUAL , spending_for_chul_days_ANNUAL)
cor(red_etel_as_is_ANNUAL , spending_for_chul_days_ANNUAL)

# Well, everything has a decent positive correlation.  However, Etel seems to be the big item that is related to spending on these days


## Culwalar days - this should just show us when they occur

plot(chul_days, main = "chulwalar days")

# Seem to occur in December and March of each year



cor(total_as_is, chul_days)
cor(efak_as_is , chul_days)
cor(wuge_as_is, chul_days)
cor(total_etel_as_is, chul_days)
cor(blue_etel_as_is , chul_days)
cor(red_etel_as_is , chul_days)

# this doesnt really show much because it is a boolean vector.


## influence of Chulwalar days

plot(infl_of_chul_days, col = "blue", main= "Influence of Chulwalar days")
lines(chul_days, col = "red")

# looks like there might be some prep in the months before that influences the economy in those time periods.  While not visually pleasing, this shows the relationship offset


## Now I want to look at my data on graphs indexed on one graph.

# create the index values
blue_etel_index<- blue_etel_as_is[1]
red_etel_index<- red_etel_as_is[1]
total_etel_index<- total_etel_as_is[1]
wuge_as_is_index<- wuge_as_is[1]
efak_as_is_index<- efak_as_is[1]
total_as_is_index<- total_as_is[1]

# not create the indexed series
indexed_blue_etel<- blue_etel_as_is/blue_etel_index
indexed_red_etel<- red_etel_as_is/red_etel_index
indexed_total_etel<- total_etel_as_is/total_etel_index
indexed_wuge_as_is<- wuge_as_is/wuge_as_is_index
indexed_efak_as_is<- efak_as_is/efak_as_is_index
indexed_total_as_is<- total_as_is/total_as_is_index


plot(indexed_blue_etel, col = "blue", ylim = c(.2,3))

lines(indexed_red_etel, col = "red")
lines(indexed_total_etel, col = "black")
lines(indexed_efak_as_is, col = "purple")
lines(indexed_wuge_as_is, col = "magenta")
lines(indexed_total_as_is, col = "green")

# while a messy graph, this shows several things:
#1.) blue etel does have a seasonal pattern, but is mostly not growing in the amount exported
#2.) red etel is highly seasonal, and the trend is increasing.  The amount exported is nearly triple the value in 2008 seasonally
#3.) Total etel follows that same trend as red etel, and is only decremented by the minor impact of blue etel.  Blue etel does not appear to be nearly as popular.  It could also be more scarce.
#4.) EFAK has the strongest growth of all.  While seasonal, the seasonal fluctuations are not nearly as strong as etel
#5.) Wuge is strong as well and closely mimics efac
#6.) Total exports are growing and have definite seasonal trends

########### Compare as_is to plan data #########

## Red etel ##

plot(red_etel_as_is, main = "red_etel as is vs. red_etel plan", col = "blue")
lines(red_etel_plan, col = "red")

data.frame(accuracy(red_etel_plan,red_etel_as_is))

red_etel_plan_v_actual<- (red_etel_plan/red_etel_as_is-1)*100
mean(red_etel_plan_v_actual)

plot(red_etel_plan_v_actual, main = "percent error red etel", col = "blue")

# red etel has a MAPE of 13.6% and a mean percentage error of -5.32%.  There is obviously alot of volatility in the plan.

## blue etel ##

plot(blue_etel_as_is, main = "blue_etel as is vs. blue_etel plan", col = "blue")
lines(blue_etel_plan, col = "red")

accuracy(blue_etel_plan,blue_etel_as_is)

blue_etel_plan_v_actual<- (blue_etel_plan/blue_etel_as_is-1)*100
mean(blue_etel_plan_v_actual)

plot(blue_etel_plan_v_actual, main = "percent error blue etel", col = "blue")

# Blue etel is even more inaccurate and more volatile than red etel.  We see a MAPE of 14.06 and a Mean percentage error of -9.54%.  This is very high.



## Total etel ##

plot(total_etel_as_is, main = "total_etel as is vs. total_etel plan", col = "blue")
lines(total_etel_plan, col = "red")

accuracy(total_etel_plan, total_etel_as_is)

total_etel_plan_v_actual<- (total_etel_plan/ total_etel_as_is-1)*100
mean(total_etel_plan_v_actual)

plot(total_etel_plan_v_actual, main = "percent error total etel", col = "blue")

# total etel is over 12% off on an absolute basis.  These plan numbers would not cut it in the private sector.

## Total WUGE ##

plot(wuge_as_is, main = "wuge as is vs. wuge plan", col = "blue")
lines(wuge_plan, col = "red")

accuracy(wuge_plan, wuge_as_is)

wuge_plan_v_actual<- (wuge_plan/wuge_as_is-1)*100
mean(wuge_plan_v_actual)

plot(wuge_plan_v_actual, main = "percent error wuge", col = "blue")

# total wuge is a little bit better than wuge.  However, our average absolute percentage error is still over 10%


## Total ##

plot(total_as_is, main = "total as is vs. total plan", col = "blue")
lines(total_plan, col = "red")


accuracy(total_plan, total_as_is)
# the total MAPE was 9.0%.  This is a little high in general.  However, the MPE is -1.99%. Our overall plan must have some high and low swings
# 



############ Decomposition Models ##############


# I will start off with classical decomposition of the variables

cl_fit_red_etel_as_is <- decompose(red_etel_as_is)
cl_fit_blue_etel_as_is <- decompose(blue_etel_as_is)
cl_fit_total_etel_as_is <- decompose(total_etel_as_is)
cl_fit_efak_as_is <- decompose(efak_as_is)
cl_fit_wuge_as_is <- decompose(wuge_as_is)
cl_fit_total_as_is<-decompose(total_as_is)

plot(cl_fit_red_etel_as_is)
# as stated before, it looks like the trend of red etel is increasing over time and that there is definitely a seasonal component to the data

plot(cl_fit_blue_etel_as_is)
# blue etel also appears to be highly seasonal.  It seems that the trend was depressed until mid-2011 and has been on the ride since then

plot(cl_fit_total_etel_as_is)

# When looking at total etel combined, we can see that the trend is clearly upward and that there is a repeated seasonal pattern

plot(cl_fit_efak_as_is)

# the seasonal pattern for efak is definitely different from etel, but there is a seasonal trend.  The seasonality is not as well defined as etel.  The trend in demand is upward

plot(cl_fit_wuge_as_is)

# Wuge has a clear upward trend and well-defined seasonality

plot(cl_fit_total_as_is)

# As expected, total exports have a repeated seasonal trend since all of the underlying values that make up exports are seasonal.  Additionally, the trend in overall exports is upward

## I want to see the data once it has been seasonally adjusted, I will use the decompose seasonal adjustment to view the data

red_etel_seas_adjust<- seasadj(cl_fit_red_etel_as_is)
blue_etel_seas_adjust<- seasadj(cl_fit_blue_etel_as_is)
total_etel_seas_adjust<- seasadj(cl_fit_total_etel_as_is)
efak_seas_adjust<- seasadj(cl_fit_efak_as_is)
wuge_seas_adjust<- seasadj(cl_fit_wuge_as_is)
total_seas_adjust<-seasadj(cl_fit_total_as_is)

# initiate 3X2
par(mfrow = c(3,2))

plot(red_etel_seas_adjust, col = "red", main = "seasonally adjusted red_etel")
plot(blue_etel_seas_adjust, col = "blue", main = "seasonally adjusted blue_etel")
plot(total_etel_seas_adjust, col = "purple", main = "seasonally adjusted total_etel")
plot(efak_seas_adjust, col = "dark green", main = "seasonally adjusted efak")
plot(wuge_seas_adjust, col = "gold", main = "seasonally adjusted wuge")
plot(total_seas_adjust, col = "black", main = "seasonally adjusted total exports")

# Just as expected all of the terms are intact with just random and trend left in the lines


## Now, we can try the STL model to see if it shows the same decomposition results since we know that classical is not robust to outliers

stl_fit_red_etel_as_is <- stl(red_etel_as_is, s.window = 5)
stl_fit_blue_etel_as_is <- stl(blue_etel_as_is, s.window = 5)
stl_fit_total_etel_as_is <- stl(total_etel_as_is, s.window = 5)
stl_fit_efak_as_is <- stl(efak_as_is, s.window = 5)
stl_fit_wuge_as_is <- stl(wuge_as_is, s.window = 5)
stl_fit_total_as_is<-stl(total_as_is, s.window = 5)

plot(stl_fit_red_etel_as_is)
# This one seems to make a little more sense, plus we get the benefit of having more periods involved in the decomposition

plot(stl_fit_blue_etel_as_is)
# now we really see the dip in the blue that we thought we saw in the annual data.  This only confirms that we do think we are seeing something in the 2008-2011 time period with the blue

plot(stl_fit_total_etel_as_is)
# AS we know, blue is very small and didnt impact the overall trend of the etel.  Note that hte seasonal fluctuations tend to grow more extreme.  Maybe a multiplicative model is appropriate

plot(stl_fit_efak_as_is)
# The seasonal looks a little more random here than it did in the previous model.  Although this invokes the same concern about the seasonality in this model.  It also looks like there is more random variation later in the time series

plot(stl_fit_wuge_as_is)
# we do still see seasonality here.  The seasonality does look a little more random.  The random variation looks like it might grow a little bit later on

plot(stl_fit_total_as_is)
# overall, nice looking decomposition.  I think that the overall seasonality does tend to grow over time here.

# now I want to see how the stl time series trend compares to the actual data, to visually confirm
par(mfrow = c(3,2))

plot(red_etel_as_is, main = "red etel trend")
lines(stl_fit_red_etel_as_is$time.series[,2], col = "red")

plot(blue_etel_as_is, main = "blue etel trend")
lines(stl_fit_blue_etel_as_is$time.series[,2], col = "blue")

plot(total_etel_as_is, main = "total etel trend")
lines(stl_fit_total_etel_as_is$time.series[,2], col = "purple")

plot(efak_as_is, main = "efak trend")
lines(stl_fit_efak_as_is$time.series[,2], col = "dark green")

plot(wuge_as_is, main = "wuge trend")
lines(stl_fit_wuge_as_is$time.series[,2], col = "gold")

plot(total_as_is, main = "total trend")
lines(stl_fit_total_as_is$time.series[,2], col = "magenta")


###### Forecast Section#####

# The first forecast model : simple exponential smoothing  (even though we know the data is seasonal)
# Just to see what the models look like, we will use red etel.  WE have established that there is seasonality present, so we expect and unreasonable model

red_etel_ses_1<- ses(red_etel_as_is, alpha = .2, initial = "simple", he = 12) # smoothing parameter = .2
red_etel_ses_2<- ses(red_etel_as_is, alpha = .6, initial = "simple", he = 12) # smoothing parameter = .6
red_etel_ses_3<- ses(red_etel_as_is, alpha = .8, initial = "simple", he = 12) # smoothing parameter = .8


par(mfrow = c(1,1))

plot(red_etel_ses_1, plot.conf = FALSE, ylab = "export_value",xlab = "period", fcol = "white",type = "o" )
lines(fitted(red_etel_ses_1), col = "blue", type = "o")
lines(fitted(red_etel_ses_2), col = "red", type = "o")
lines(fitted(red_etel_ses_3), col = "green", type = "o")
legend( "topleft", lty = 1, col = c("black", "blue","red","green"), c("data", expression(alpha==.2),expression(alpha ==.6),expression(alpha  ==.8)),pch = 1) 

# looks like there is a one period offset or lag in my fitted values.  This could lead to issues with getting the correct forecast values
# The 0.8 smoothing parameter does look best

# adding in the forecasted values

lines(red_etel_ses_1$mean, col = "blue", type = "o")
lines(red_etel_ses_2$mean, col = "red", type = "o")
lines(red_etel_ses_3$mean, col = "green", type = "o")

# we definitely cannot use a ses model, just as we thought.  WE need something that can take into account seasonality and potentially multiplicative models

# To be thorough, I want to see what holt's linear model looks like, once again, testing on red_etel first

red_etel_holt_linear_1 <- holt(red_etel_as_is, alpha = .8, beta = .2, initial = "simple", h = 12)
red_etel_holt_linear_2 <- holt(red_etel_as_is, alpha = .8, beta = .2, initial = "simple", exponential = TRUE, h = 12) # try a multiplicative model

plot(red_etel_holt_linear_1, ylab = "export value", xlab = "period", fcol = "white", type = "o",plot.conf = FALSE, main = "Forecast of Holt's linear")
lines(fitted(red_etel_holt_linear_1), col = "blue", type = "o")
lines(fitted(red_etel_holt_linear_2), col = "red", type = "o")

lines(red_etel_holt_linear_1$mean, col = "blue", type = "o")
lines(red_etel_holt_linear_2$mean, col = "red", type = "o")
legend( "topleft", lty = 1, col = c("black", "blue","red","green"), c("data", expression(alpha==.2),expression(alpha ==.6),expression(alpha  ==.8)),pch = 1) 

# WEll, these fitted values go off the charts for the multiplicative approach, but I notice that I straight line for the forecast.  This is probably not a good model.
# we also still see the period lag since the model uses some moving averages.  THis makes it not a great model for our purposes
# If we had to pick one model, we would use model 1, since the multiplicative tends to over-forecast.
# After seeing 2 models that do not work well for seasonality, it is time to try a seasonal approach


# we can conclude that a linear trend model is probably not the best approach, we will try a Holt Winters seasonal model next

### HOLT WINTERS SEASONAL FORECASTS

red_etel_holt_winters_1<- hw(red_etel_as_is, seasonal = "additive")
red_etel_holt_winters_2 <- hw(red_etel_as_is, seasonal = "multiplicative")

plot(red_etel_holt_winters_1, ylab = "export value", xlab = "period", plot.conf = FALSE, type = "o", fcol = "white", main = "Holt Winters Model")
lines(fitted(red_etel_holt_winters_1), col = "blue", lty = 2)
lines(fitted(red_etel_holt_winters_2), col = "red", lty = 2)
lines(red_etel_holt_winters_1$mean, type = "o", col = "blue")
lines(red_etel_holt_winters_2$mean, type = "o", col = "red")
legend("topleft", lty = 1, col = c("black","blue","red"), c("data", "Holt Winters-Add","Holt Winters-Multi"))

# visually, the Multiplicative seems to be best for red-etel

# let's look at the states of the model

red_etel_states<- cbind(red_etel_holt_winters_1$model$states[,1:3],red_etel_holt_winters_2$model$states[,1:3])

colnames(red_etel_states)<- c("level","slope","seasonal","level","slope","seasonal")

plot(red_etel_states)

# looks like the multiplicative does a better job of capturing the overall trend present in the data

fitted(red_etel_holt_winters_1) # shows the fitted values
red_etel_holt_winters_1$mean # shows predicted values


# residuals

mean(red_etel_holt_winters_1$residuals)
mean(red_etel_holt_winters_2$residuals)

sd(red_etel_holt_winters_1$residuals)
sd(red_etel_holt_winters_2$residuals)

accuracy(fitted(red_etel_holt_winters_1), red_etel_as_is)
accuracy(fitted(red_etel_holt_winters_2), red_etel_as_is)
# looks like multiplicative does a much better job and does not tend to severely under forecast like the additive linear

# check AIC and BIC
red_etel_holt_winters_1$model
red_etel_holt_winters_2$model
# I get better fits for the multiplicative model in this case.  I would go with the multi holt-winters for red_etel


# Seasonal model for blue_etel #

blue_etel_holt_winters_1<- hw(blue_etel_as_is, seasonal = "additive")
blue_etel_holt_winters_2 <- hw(blue_etel_as_is, seasonal = "multiplicative")

plot(blue_etel_holt_winters_1, ylab = "export value", xlab = "period", plot.conf = FALSE, type = "o", fcol = "white", main = "Holt Winters Model")
lines(fitted(blue_etel_holt_winters_1), col = "blue", lty = 2)
lines(fitted(blue_etel_holt_winters_2), col = "red", lty = 2)
lines(blue_etel_holt_winters_1$mean, type = "o", col = "blue")
lines(blue_etel_holt_winters_2$mean, type = "o", col = "red")
legend("topleft", lty = 1, col = c("black","blue","red"), c("data", "Holt Winters-Add","Holt Winters-Multi"))

# visually, it is hard to tell whether the additive or multiplicative model is better for blue etel.  We did have more irregularity in this model than others.


# let's look at the states of the model

blue_etel_states<- cbind(blue_etel_holt_winters_1$model$states[,1:3],blue_etel_holt_winters_2$model$states[,1:3])

colnames(blue_etel_states)<- c("level","slope","seasonal","level","slope","seasonal")

plot(blue_etel_states)

# These look virtually the same.  The multiplicative does seem to show a slightly more peaked seasonality

fitted(blue_etel_holt_winters_1) # shows the fitted values
blue_etel_holt_winters_1$mean # shows predicted values


# residuals

mean(blue_etel_holt_winters_1$residuals)
mean(blue_etel_holt_winters_2$residuals)

sd(blue_etel_holt_winters_1$residuals)
sd(blue_etel_holt_winters_2$residuals)

accuracy(fitted(blue_etel_holt_winters_1), blue_etel_as_is)
accuracy(fitted(blue_etel_holt_winters_2), blue_etel_as_is)

# it looks like that mape for the multiplicative is only slightly lower than the additive model, essentially the same value


# check AIC and BIC
blue_etel_holt_winters_1$model
blue_etel_holt_winters_2$model

# These values are really close.  Infact, nearly too close to call.  If I had to pick one, I might wind up with multiplicative to be consistent with the red model

# Seasonal model for total_etel#

total_etel_holt_winters_1<- hw(total_etel_as_is, seasonal = "additive")
total_etel_holt_winters_2 <- hw(total_etel_as_is, seasonal = "multiplicative")

plot(total_etel_holt_winters_1, ylab = "export value", xlab = "period", plot.conf = FALSE, type = "o", fcol = "white", main = "Holt Winters Model")
lines(fitted(total_etel_holt_winters_1), col = "blue", lty = 2)
lines(fitted(total_etel_holt_winters_2), col = "red", lty = 2)
lines(total_etel_holt_winters_1$mean, type = "o", col = "blue")
lines(total_etel_holt_winters_2$mean, type = "o", col = "red")
legend("topleft", lty = 1, col = c("black","blue","red"), c("data", "Holt Winters-Add","Holt Winters-Multi"))

# It looks like the multiplicative might be doing a slightly better job at picking up the peaks, which is in line with the multiplicative for the red etel.  Since red etel makes up the majority of total etel, this would be expected


# let's look at the states of the model

total_etel_states<- cbind(total_etel_holt_winters_1$model$states[,1:3],total_etel_holt_winters_2$model$states[,1:3])

colnames(total_etel_states)<- c("level","slope","seasonal","level","slope","seasonal")

plot(total_etel_states)

# Once again, the big difference can be seen in the slope calculation.  We miss the upward trend in the slope.

#fitted(total_etel_holt_winters_1) # shows the fitted values
#total_etel_holt_winters_1$mean # shows predicted values


# residuals

mean(total_etel_holt_winters_1$residuals)
mean(total_etel_holt_winters_2$residuals)

sd(total_etel_holt_winters_1$residuals)
sd(total_etel_holt_winters_2$residuals)

accuracy(fitted(total_etel_holt_winters_1), total_etel_as_is)
accuracy(fitted(total_etel_holt_winters_2), total_etel_as_is)


# looks like overall for the etel, the multiplicative is better with a mape of 9.7% versus 10.7% in the additive model

# check AIC and BIC
total_etel_holt_winters_1$model
total_etel_holt_winters_2$model

# the numbers are close for the AIC and BIC.  However, we would pick the multiplicative in this case based on red_etel and the visual observations we have made.


## Seasonal model for efac



efak_holt_winters_1<- hw(efak_as_is, seasonal = "additive")
efak_holt_winters_2 <- hw(efak_as_is, seasonal = "multiplicative")

plot(efak_holt_winters_1, ylab = "export value", xlab = "period", plot.conf = FALSE, type = "o", fcol = "white", main = "Holt Winters Model")
lines(fitted(efak_holt_winters_1), col = "blue", lty = 2)
lines(fitted(efak_holt_winters_2), col = "red", lty = 2)
lines(efak_holt_winters_1$mean, type = "o", col = "blue")
lines(efak_holt_winters_2$mean, type = "o", col = "red")
legend("topleft", lty = 1, col = c("black","blue","red"), c("data", "Holt Winters-Add","Holt Winters-Multi"))

# It is very hard to tell from the visual which model does the best, it appears that both models miss some of the extereme fluctuations in the efak as a whole



# let's look at the states of the model

efak_states<- cbind(efak_holt_winters_1$model$states[,1:3],efak_holt_winters_2$model$states[,1:3])

colnames(efak_states)<- c("level","slope","seasonal","level","slope","seasonal")

plot(efak_states)

# These look nearly the same.  However, we do notice that the multiplicative does appear to pick up fomr of the variation slightly better.  Additionally, the seasonality in the multiplicative looks more sensitive.


# residuals and accuracy

mean(efak_holt_winters_1$residuals)
mean(efak_holt_winters_2$residuals)

sd(efak_holt_winters_1$residuals)
sd(efak_holt_winters_2$residuals)

accuracy(fitted(efak_holt_winters_1), efak_as_is)
accuracy(fitted(efak_holt_winters_2), efak_as_is)


# The MAPEs are about the same. In this case, the multiplicative is a little sorse.  The Mean Percentage error is also higher for the multiplicative.  However, I still feel that since we chose the multiplicative for the other models that it makes sense to use the multiplicative


# check AIC and BIC
efak_holt_winters_1$model
efak_holt_winters_2$model

# The multiplicative is still a little worse in terms of AIC and BIC.  We are not talking about huge differences in general though


## Seasonal Model for WUGE ##

wuge_holt_winters_1<- hw(wuge_as_is, seasonal = "additive")
wuge_holt_winters_2 <- hw(wuge_as_is, seasonal = "multiplicative")

plot(wuge_holt_winters_1, ylab = "export value", xlab = "period", plot.conf = FALSE, type = "o", fcol = "white", main = "Holt Winters Model")
lines(fitted(wuge_holt_winters_1), col = "blue", lty = 2)
lines(fitted(wuge_holt_winters_2), col = "red", lty = 2)
lines(wuge_holt_winters_1$mean, type = "o", col = "blue")
lines(wuge_holt_winters_2$mean, type = "o", col = "red")
legend("topleft", lty = 1, col = c("black","blue","red"), c("data", "Holt Winters-Add","Holt Winters-Multi"))

# Once again, it is hard to tell which model is better.  The multiplicative wins in some cases, but is beat out by the additive model in many others




# let's look at the states of the model

wuge_states<- cbind(wuge_holt_winters_1$model$states[,1:3],wuge_holt_winters_2$model$states[,1:3])

colnames(wuge_states)<- c("level","slope","seasonal","level","slope","seasonal")

plot(wuge_states)

# There is a clear trend in both models.  The slopes of the models differ substanti


# residuals and accuracy

mean(wuge_holt_winters_1$residuals)
mean(wuge_holt_winters_2$residuals)

sd(wuge_holt_winters_1$residuals)
sd(wuge_holt_winters_2$residuals)

accuracy(fitted(wuge_holt_winters_1), wuge_as_is)
accuracy(fitted(wuge_holt_winters_2), wuge_as_is)


# It looks like the multiplicative model is worse in this case with a MAPE of 8.35 versus a MAPE of 7.97 in the additive model.  That being said, the difference is fairly negligible.


# check AIC and BIC
wuge_holt_winters_1$model
wuge_holt_winters_2$model

# However, the BIC is actually better for the multiplicative and the AIC is essentially the same.  We might be alright to go with the multiplicative here as well for consistency



## Seasonal Model for Total ##

total_holt_winters_1<- hw(total_as_is, seasonal = "additive")
total_holt_winters_2 <- hw(total_as_is, seasonal = "multiplicative")

plot(total_holt_winters_1, ylab = "export value", xlab = "period", plot.conf = FALSE, type = "o", fcol = "white", main = "Holt Winters Model")
lines(fitted(total_holt_winters_1), col = "blue", lty = 2)
lines(fitted(total_holt_winters_2), col = "red", lty = 2)
lines(total_holt_winters_1$mean, type = "o", col = "blue")
lines(total_holt_winters_2$mean, type = "o", col = "red")
legend("topleft", lty = 1, col = c("black","blue","red"), c("data", "Holt Winters-Add","Holt Winters-Multi"))

# The total is have to tell, but gutterally, it looks like the multiplicative hits the peaks better while the additive hits the trough better


# let's look at the states of the model

total_states<- cbind(total_holt_winters_1$model$states[,1:3],total_holt_winters_2$model$states[,1:3])

colnames(total_states)<- c("level","slope","seasonal","level","slope","seasonal")

plot(total_states)

# It looks like the differing factor, which is what we have previously seen falls in the area of the slope.  The mutliplicative maintains a higher level later in the curve.


# residuals and accuracy

mean(total_holt_winters_1$residuals)
mean(total_holt_winters_2$residuals)

sd(total_holt_winters_1$residuals)
sd(total_holt_winters_2$residuals)

accuracy(fitted(total_holt_winters_1), total_as_is)
accuracy(fitted(total_holt_winters_2), total_as_is)


# Once again, it could be a draw between the 2 models in terms of mape and mpe.  As usual, the MPE looks better in the additive and the MAPE is better in the multiplicative.  The differences are only slight though




# check AIC and BIC
total_holt_winters_1$model
total_holt_winters_2$model

# Both the AIC and the BIC are better for the additive model.  I wonder if doing the same analysis but flowing the 2014 data back in might impact the results

## Seasonal for total including 2014 ##


total_inc_2014_holt_winters_1<- hw(total_as_is_inc_2014, seasonal = "additive")
total_inc_2014_holt_winters_2 <- hw(total_as_is_inc_2014, seasonal = "multiplicative")

plot(total_inc_2014_holt_winters_1, ylab = "export value", xlab = "period", plot.conf = FALSE, type = "o", fcol = "white", main = "Holt Winters Model")
lines(fitted(total_inc_2014_holt_winters_1), col = "blue", lty = 2)
lines(fitted(total_inc_2014_holt_winters_2), col = "red", lty = 2)
lines(total_inc_2014_holt_winters_1$mean, type = "o", col = "blue")
lines(total_inc_2014_holt_winters_2$mean, type = "o", col = "red")
legend("topleft", lty = 1, col = c("black","blue","red"), c("data", "Holt Winters-Add","Holt Winters-Multi"))

# Still looks about the same as the 2014.  However, maybe something happens in the forecast accuracy that could change our minds


# let's look at the states of the model

total_inc_2014_states<- cbind(total_inc_2014_holt_winters_1$model$states[,1:3],total_inc_2014_holt_winters_2$model$states[,1:3])

colnames(total_inc_2014_states)<- c("level","slope","seasonal","level","slope","seasonal")

plot(total_inc_2014_states)

# It looks like the differing factor, which is what we have previously seen, falls in the area of the slope.  The multiplicative maintains a higher level later in the curve and doesn't dip as much.


# residuals and accuracy

mean(total_inc_2014_holt_winters_1$residuals)
mean(total_inc_2014_holt_winters_2$residuals)

sd(total_inc_2014_holt_winters_1$residuals)
sd(total_inc_2014_holt_winters_2$residuals)

accuracy(fitted(total_inc_2014_holt_winters_1), total_as_is_inc_2014)
accuracy(fitted(total_inc_2014_holt_winters_2), total_as_is_inc_2014)


# The MAPE looks slightly better for the multiplicative than it does for the additive




# check AIC and BIC
total_inc_2014_holt_winters_1$model
total_inc_2014_holt_winters_2$model

# we still see that the multiplicative model is not quite as good as the additive for the total data including 2014

## WEll, it looks like a bit of a draw as to which model to pick from the standpoint of MAPE, MPE, AIC, and BIC.  
## The parsimony principle would recommend that we go with the simplest model.  In this case, perhaps the additive is simpler to explain, but the implementation is not any different


########COMPARE FORECAST TO PLAN DATA##########


## Red etel ##
par(mfrow = c(1,1))
plot(fitted(red_etel_holt_winters_2), main = "red_etel forecast vs. red_etel plan", col = "blue")
lines(red_etel_plan, col = "red")

accuracy(fitted(red_etel_holt_winters_2), red_etel_plan)


# The multiplicative give a MAPE of 8.3% versus plan
# we get a MPE of 2.16% versus plan

## blue etel ##

plot(fitted(blue_etel_holt_winters_2), main = "blue_etel forecast vs. blue_etel plan", col = "blue")
lines(blue_etel_plan, col = "red")
#lines(fitted(blue_etel_holt_winters_1), col = "green")

accuracy(fitted(blue_etel_holt_winters_2),blue_etel_plan)

blue_etel_plan_v_actual<- (blue_etel_plan/blue_etel_as_is-1)*100


# MAPE of 12.2% and MPE of 10.72%
# This is not good, but the plan is just much more volatile than the real data used to forecast



## Total etel ##

plot(fitted(total_etel_holt_winters_2), main = "total_etel forecast vs. total_etel plan", col = "blue")
lines(total_etel_plan, col = "red")

accuracy(fitted(total_etel_holt_winters_2), total_etel_as_is)

# MAPE 9.74%, MPE -1.27%
# THe forecast is different from plan on an absolute basis by 9.7%.  However, we do tend to on average under forecast by 1.27%

## Total WUGE ##

plot(fitted(wuge_holt_winters_2), main = "wuge forecast vs. wuge plan", col = "blue")
lines(wuge_plan, col = "red")

accuracy(fitted(wuge_holt_winters_2), wuge_as_is)

# MAPE 8.35% , MPE -2.23%
# looks like we tend to under forecast overall, but our absolute error is 8.35% from plan


## Total ##

plot(fitted(total_inc_2014_holt_winters_2), main = "total forecast vs. total plan", col = "blue")
lines(total_plan_inc_2014, col = "red")


accuracy(fitted(total_inc_2014_holt_winters_2), total_plan_inc_2014)

# MAPE 4.8%, MPE 1.4%
# looks like we are pretty close to plan over all.  However, we know that plan versus actual is off.  This model still seems like it will do alright





