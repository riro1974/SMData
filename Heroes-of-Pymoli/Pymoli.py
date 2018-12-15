# Dependencies and Setup
import pandas as pd
import numpy as np

# File to Load
file_to_load = "C:/Data Science Bootcamp/Data Science Boot Camp/PANDAS_RT/purchase_data.csv"

# Read Purchasing File and store into Pandas data frame
purchase_data = pd.read_csv(file_to_load)
purchase_data

#print(len(purchase_data.SN.unique()))
#total number of players
players_dedup = purchase_data['SN'].nunique()
players_tot = pd.DataFrame({"Total Players": [players_dedup]}, columns= ["Total Players"])
players_tot

#number of unique items sold, purchase price, number of purchases and total revenue
purchase_items = purchase_data['Item ID'].nunique()
price_avg = (purchase_data['Price'].sum()/purchase_data['Price'].count()).round(2)
purchase_tot = purchase_data['Price'].count()
revenue_tot = purchase_data["Price"].sum()
purchase_analysis = pd.DataFrame({"Number of Unique Items": [purchase_items], "Average Purchase Price": [price_avg],
"Number of Purchases": [purchase_tot], "Total Revenue": [revenue_tot]}, columns= ["Number of Unique Items", "Average Purchase Price",
"Number of Purchases", "Total Revenue"])
print("Purchasing Analysis (Total)",end="\n")
print("-----------------------------")
purchase_analysis.style.format({"Average Purchase Price": "${:.2f}", "Total Revenue": "${:.2f}"})


tot_count = purchase_data["SN"].nunique()	
male_tot = purchase_data[purchase_data["Gender"] == "Male"]["SN"].nunique()
female_tot = purchase_data[purchase_data["Gender"] == "Female"]["SN"].nunique()
tot_other = tot_count - male_tot - female_tot
percent_male = ((male_tot/tot_count)*100)
percent_female = ((female_tot/tot_count)*100)
percent_other = ((tot_other/tot_count)*100)
gender_demo_df = pd.DataFrame({"Gender": ["Male", "Female", "Other / Non-Disclosed"], "Percentage of Players": [percent_male, percent_female, percent_other],
"Total Count": [male_tot, female_tot, tot_other]}, columns = ["Gender", "Total Count", "Percentage of Players"])
gender_demographics = gender_demo_df.set_index("Gender")
gender_demographics.style.format({"Percentage of Players": "{:.2f}%"})    

malepurch = purchase_data[purchase_data["Gender"] == "Male"]["Price"].count()
femalepurch = purchase_data[purchase_data["Gender"] == "Female"]["Price"].count()
otherpurch = purchase_tot - malepurch - femalepurch
mpriceavg = purchase_data[purchase_data["Gender"] == "Male"]['Price'].mean()
fpriceavg = purchase_data[purchase_data["Gender"] == "Female"]['Price'].mean()
opriceavg = purchase_data[purchase_data["Gender"] == "Other / Non-Disclosed"]['Price'].mean()
mpricetot = purchase_data[purchase_data["Gender"] == "Male"]['Price'].sum()
fpricetot = purchase_data[purchase_data["Gender"] == "Female"]['Price'].sum()
opricetot = purchase_data[purchase_data["Gender"] == "Other / Non-Disclosed"]['Price'].sum()
mnorm = mpricetot/male_tot
fnorm = fpricetot/female_tot
onorm = opricetot/tot_other

gender_purchase_df = pd.DataFrame({"Gender": ["Male", "Female", "Other / Non-Disclosed"], "Purchase Count": [malepurch, femalepurch, otherpurch],
"Average Purchase Price": [mpriceavg, fpriceavg, opriceavg], "Total Purchase Value": [mpricetot, fpricetot, opricetot],
"Avg Total Purchase per Person": [mnorm, fnorm, onorm]}, columns = ["Gender", "Purchase Count", "Average Purchase Price", "Total Purchase Value", "Avg Total Purchase per Person"])
gender_purchase_final = gender_purchase_df.set_index("Gender")
gender_purchase_final.style.format({"Average Purchase Price": "${:.2f}", "Total Purchase Value": "${:.2f}", "Avg Total Purchase per Person": "${:.2f}"})


#create age parameters - 4 year length
#create dataframe of unique players in each age group, find percentage against full count of players

tenyears = purchase_data[purchase_data["Age"] <10]
loteens = purchase_data[(purchase_data["Age"] >=10) & (purchase_data["Age"] <=14)]
hiteens = purchase_data[(purchase_data["Age"] >=15) & (purchase_data["Age"] <=19)]
lotwent = purchase_data[(purchase_data["Age"] >=20) & (purchase_data["Age"] <=24)]
hitwent = purchase_data[(purchase_data["Age"] >=25) & (purchase_data["Age"] <=29)]
lothirt = purchase_data[(purchase_data["Age"] >=30) & (purchase_data["Age"] <=34)]
hithirt = purchase_data[(purchase_data["Age"] >=35) & (purchase_data["Age"] <=39)]
fortyplus = purchase_data[(purchase_data["Age"] >=40)]
age_demo_df = pd.DataFrame({"Age": ["<10", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40+"],
"Percentage of Players": [(tenyears["SN"].nunique()/tot_count)*100, (loteens["SN"].nunique()/tot_count)*100, (hiteens["SN"].nunique()/tot_count)*100, (lotwent["SN"].nunique()/tot_count)*100, (hitwent["SN"].nunique()/tot_count)*100, (lothirt["SN"].nunique()/tot_count)*100, (hithirt["SN"].nunique()/tot_count)*100, (fortyplus["SN"].nunique()/tot_count)*100],
"Total Count": [tenyears["SN"].nunique(), loteens["SN"].nunique(), hiteens["SN"].nunique(), lotwent["SN"].nunique(), hitwent["SN"].nunique(), lothirt["SN"].nunique(), hithirt["SN"].nunique(), fortyplus["SN"].nunique()]})
age_demo_final = age_demo_df.set_index("Age")
age_demo_final.style.format({"Percentage of Players": "{:.2f}%"})  


age_purchasing_df = pd.DataFrame({"Age": ["<10", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40+"],
"Purchase Count": [tenyears["Price"].count(), loteens["Price"].count(), hiteens["Price"].count(), lotwent["Price"].count(), hitwent["Price"].count(), lothirt["Price"].count(), hithirt["Price"].count(), fortyplus["Price"].count()],
"Average Purchase Price": [tenyears["Price"].mean(), loteens["Price"].mean(), hiteens["Price"].mean(), lotwent["Price"].mean(), hitwent["Price"].mean(), lothirt["Price"].mean(), hithirt["Price"].mean(), fortyplus["Price"].mean()],
"Total Purchase Value": [tenyears["Price"].sum(), loteens["Price"].sum(), hiteens["Price"].sum(), lotwent["Price"].sum(), hitwent["Price"].sum(), lothirt["Price"].sum(), hithirt["Price"].sum(), fortyplus["Price"].sum()],
"Avg Total Purchase per Person": [tenyears["Price"].sum()/tenyears['SN'].nunique(), loteens["Price"].sum()/loteens['SN'].nunique(), hiteens["Price"].sum()/hiteens['SN'].nunique(),lotwent["Price"].sum()/lotwent['SN'].nunique(), hitwent["Price"].sum()/hitwent['SN'].nunique(),lothirt["Price"].sum()/lothirt['SN'].nunique(), hithirt["Price"].sum()/hithirt['SN'].nunique(),fortyplus["Price"].sum()/fortyplus['SN'].nunique()]},
columns = ["Age", "Purchase Count", "Average Purchase Price", "Total Purchase Value", "Avg Total Purchase per Person"])

age_purchasing_final = age_purchasing_df.set_index("Age")

age_purchasing_final.style.format({"Average Purchase Price": "${:.2f}", "Total Purchase Value": "${:.2f}", "Avg Total Purchase per Person": "${:.2f}"})

sn_total_purchase = purchase_data.groupby('SN')['Price'].sum().to_frame()
sn_purchase_count = purchase_data.groupby('SN')['Price'].count().to_frame()
sn_purchase_avg = purchase_data.groupby('SN')['Price'].mean().to_frame()

sn_total_purchase.columns=["Total Purchase Value"]
join_one = sn_total_purchase.join(sn_purchase_count, how="left")
join_one.columns=["Total Purchase Value", "Purchase Count"]

join_two = join_one.join(sn_purchase_avg, how="inner")
join_two.columns=["Total Purchase Value", "Purchase Count", "Average Purchase Price"]

top_spenders_df = join_two[["Purchase Count", "Average Purchase Price", "Total Purchase Value"]]
top_spenders_final = top_spenders_df.sort_values('Total Purchase Value', ascending=False).head()
top_spenders_final.style.format({"Average Purchase Price": "${:.2f}", "Total Purchase Value": "${:.2f}"})

#merge dataframes to find purchase count, total purchase value for items
#reset indices to dataframes can be merged on specific elements
premergeone = purchase_data.groupby("Item Name").sum().reset_index()
premergetwo = purchase_data.groupby("Item ID").sum().reset_index()
premergethree = purchase_data.groupby("Item Name").count().reset_index()

#merge dataframes
mergeone = pd.merge(premergeone, premergetwo, on="Price")
mergetwo = pd.merge(premergethree, mergeone, on="Item Name")

#start to create final dataframe by manipulating data
mergetwo["Gender"] = (mergetwo["Price_y"]/mergetwo["Item ID"]).round(2)

mergetwo_renamed = mergetwo.rename(columns={"Age": "Purchase Count", "Gender": "Item Price", "Item ID": "null", "Price_y": "Total Purchase Value", "Item ID_y": "Item ID"})

#grab columns we are looking for
clean_df = mergetwo_renamed[["Item ID", "Item Name", "Purchase Count", "Item Price", "Total Purchase Value"]]

prefinal_df = clean_df.set_index(['Item ID', 'Item Name'])
popular_items_final = prefinal_df.sort_values(['Purchase Count','Item ID'], ascending=[False,False]).head(5)
popular_items_final.style.format({"Item Price": "${:.2f}", "Total Purchase Value": "${:.2f}"})

#use prefinal dataframe from prior to step to find most profitable items

profit_items_final = prefinal_df.sort_values('Total Purchase Value', ascending=False).head()
profit_items_final.style.format({"Item Price": "${:.2f}", "Total Purchase Value": "${:.2f}"})