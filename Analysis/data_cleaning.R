
library("reshape2")
library("reshape")
library("tidyr")
library("gdata")
#install.packages("tidyr")

#setwd("C:/personnal/SMU/Final")

getwd()

###### CLEANING THE AS IS DATA########
data_test<- read.csv("Analysis/data/ImportedAsIsDataChulwalar.csv", sep = ";")



data_test<- data_test[c(-13,-14, -27, -28, -41, -42, -55, -56, -69, -70, -83, -84, -97),]



x<- c("total_as_is","efak_as_is","wuge_as_is", "total_etel_as_is","blue_etel_as_is", "red_etel_as_is", "total_yearly_exports_as_is")

y<-rep(x, each = 12)

data_test["new_col"]<- y


#data_test$value<- data_test$total_amount


data_new<- reshape2::melt(data_test, c("Total.As.Is", "new_col"))

names(data_new)<- c("month","variable","year","total_amount")

#data_new<- na.omit(data_new)

data_new$month[data_new$month=="Dez"] <- "Dec"

data_new$month[data_new$month=="Mai"] <- "May"

data_new_new<- spread(data_new, key= variable, value = total_amount)


data_new_new$year<- substr(data_new_new$year, 2, 5)

data_new_new$year<- as.numeric(data_new_new$year)

# We would like to have a month number in the tidy data, so I will create the variable here

data_new_new["month_number"]<- match(data_new_new$month, month.abb)

# Great, now, let's make it look more like a dimension by moving it up to the front of the dataset

data_new_new<-data_new_new[,c("month", "month_number", "year", "blue_etel_as_is", "red_etel_as_is", "total_etel_as_is", "efak_as_is", "wuge_as_is", "total_as_is", "total_yearly_exports_as_is")]

# now, let's sort the data appropriately

data_new_new<- data_new_new[order(data_new_new$year, data_new_new$month_number),]


as_is_data<-data_new_new


##### CLEANING THE PLAN DATA######

plan_base<- read.csv("Analysis/data/ImportedPlanDataChulwalar.csv", sep = ";")

plan_base<- plan_base[c(-13,-14, -27, -28, -41, -42, -55, -56, -69, -70, -83, -84),]

plan_names<- c("total_plan","efak_plan","wuge_plan", "total_etel_plan","blue_etel_plan", "red_etel_plan", "total_yearly_exports_plan")

# told not to use the names that were in the dataset itself
#plan_names<- c("total_plan","coffee_plan","spices_plan", "total_tea_plan","loose_tea_plan", "teabag_plan", "total_yearly_sales_plan")

plan_names_blowout<- rep(plan_names, each = 12)

plan_base["new_col"]<- plan_names_blowout


plan_base_new<- reshape2::melt(plan_base, c("Total.Plan", "new_col"))

names(plan_base_new)<- c("month","variable","year","total_amount")

plan_base_new_wide<- spread(plan_base_new, key= variable, value = total_amount)

plan_base_new_wide$year<- substr(plan_base_new_wide$year, 2, 5)

plan_base_new_wide$year<- as.numeric(plan_base_new_wide$year)

# Add in the month number for reference

plan_base_new_wide["month_number"]<- match(plan_base_new_wide$month, month.abb)

# move the column around

plan_base_new_wide<-plan_base_new_wide[,c("month", "month_number", "year", "blue_etel_plan", "red_etel_plan", "total_etel_plan", "efak_plan", "wuge_plan", "total_plan", "total_yearly_exports_plan")]



# Sort the plan data

plan_base_new_wide<- plan_base_new_wide[order(plan_base_new_wide$year, plan_base_new_wide$month_number),]


##### CLEANING THE ECONOMIC InDICATOR DATA#####

ind_base<- read.csv("Analysis/data/ImportedIndicatorsChulwalar.csv", sep = ";")

# remove blank rows and header repeats
ind_base<- ind_base[c(-13,-14, -27, -28, -41, -42, -55, -56, -69, -70, -83, -84, -97, -98, -111, -112, -125, -126, -139, -140, -153, -154, -167, -168, -181, -182),]

# names vector
ind_names<- c("chg_in_export_prices","satisfaction_index_gov","average_temperature", "births","satisfaction_index_indep", "total_exports_from_urbano", "globalisation_party_members", "average_export_price", "etel_production_price_index", "chulwalar_index", "inflation", "spending_for_chul_days", "chul_days", "infl_of_chul_days")

# blowout the names of variables for the columns
ind_names_blowout<- rep(ind_names, each = 12)

# create column for chulwar indicators

ind_base["new_col"]<- ind_names_blowout

# melt the data down

ind_base_new<- reshape2::melt(ind_base, c("Change.in.export.prices", "new_col"))

# rename the columns

names(ind_base_new)<- c("month","variable","year","total_amount")

# correct the month names

ind_base_new$month[ind_base_new$month=="Mai"] <- "May"

# widen the data out

ind_base_new_wide<- spread(ind_base_new, key= variable, value = total_amount)

# format the year column

ind_base_new_wide$year<- substr(ind_base_new_wide$year, 2, 5)

ind_base_new_wide$year<- as.numeric(ind_base_new_wide$year)


# add in the month number for reference

ind_base_new_wide["month_number"]<- match(ind_base_new_wide$month, month.abb)


# move the column around

ind_base_new_wide<-ind_base_new_wide[,c("month", "month_number", "year", "chg_in_export_prices","satisfaction_index_gov","average_temperature", "births","satisfaction_index_indep", "total_exports_from_urbano", "globalisation_party_members", "average_export_price", "etel_production_price_index", "chulwalar_index", "inflation", "spending_for_chul_days", "chul_days", "infl_of_chul_days")]

# sort it out

ind_base_new_wide<- ind_base_new_wide[order(ind_base_new_wide$year, ind_base_new_wide$month_number),]


# now, let's make the cleaned up files

write.csv(as_is_data, "analysis/data/tidy_as_is_data.csv", row.names = FALSE)

write.csv(plan_base_new_wide, "analysis/data/tidy_plan_data.csv", row.names = FALSE)

write.csv(ind_base_new_wide, "analysis/data/tidy_indicator_data.csv", row.names = FALSE)




