df_infection=read.csv("/Users/anam/Documents/First/Masters/UW/Thesis/WoundInf_Train_Tests.tsv",sep="\t",header = TRUE)
df_labels=read.csv("/Users/anam/Documents/First/Masters/UW/Thesis/WoundInf_Train_Labels.tsv",sep="\t",header = TRUE)
df_infection=merge(df_infection,df_labels)
df_infection$dateofsurgery=as.Date(as.character(df_infection$t.IndexSurgery, format = "%m/%d/%y") ) 
df_infection$dateofTest=as.Date(df_infection$Date, format = "%d/%m/%y")  


df_infection=subset(df_infection,dateofTest>=(dateofsurgery-90) & dateofTest<=dateofsurgery+30 )
df_infection$dateofTest=NULL
df_infection$dateofsurgery=NULL
mean_df=aggregate(NumAnswer ~ PID + TestType, data = df_infection, mean)
sd_df=aggregate(NumAnswer ~ PID + TestType, data = df_infection, sd) #if only 1 test then SD is NA 
df_infection_agg <- merge(mean_df,sd_df,by=c("PID","TestType"))
names(df_infection_agg)=c("PID","TestType","Mean","SD")


library(dplyr)
library(reshape2)
flattened_df = melt(df_infection_agg, id.vars = c("PID","TestType"), 
                     measure.vars = c("Mean", "SD"))
flattened_df = dcast(flattened_df, PID ~ TestType + variable, value.var = "value")
write.csv(flattened_df,"/Users/anam/Documents/First/Masters/UW/Thesis/WoundInf_Tests_Flattened_New.csv")


# library(plyr)
# Numb_tests=count(df_infection,PID)
# flattened_df$Numb_tests_taken=Numb_tests$n
# 
# Date= sapply(strsplit(as.character(df_infection$Date), '/'), function(x) x[3])
# Date= sapply(strsplit(as.character(Date), ' '), function(x) x[1])
# df_infection$YearOfTest=Date
# Numb_tests_peryear=count(df_infection,c("PID","YearOfTest"))
# min_numb_tests=ddply(Numb_tests_peryear, .(PID), summarize,
#       min_numb_tests = min(freq))
# max_numb_test=ddply(Numb_tests_peryear, .(PID), summarize,
#                max_numb_tests = max(freq))
# sd_numb_test=ddply(Numb_tests_peryear, .(PID), summarize,
#                     sd_numb_tests = round(sd(freq),2))
# mean_numb_test=ddply(Numb_tests_peryear, .(PID), summarize,
#                     mean_numb_tests = round(mean(freq),2))
# df_infection_agg=read.csv("/Users/anam/Documents/First/Masters/UW/Thesis/WoundInf_Tests_Flattened.csv")
# df_infection_agg= cbind(df_infection_agg,min_numb_tests$min_numb_tests,max_numb_test$max_numb_tests,sd_numb_test$sd_numb_tests,mean_numb_test$mean_numb_tests)



# library(plyr)
# sorted <- arrange(mean_df,desc(PID),TestType)
# sorted2 <- arrange(df_infection,desc(PID),TestType)
# sorted <- arrange(sd_df,desc(PID),TestType)
# sorted2 <- arrange(df_infection,desc(PID),TestType)

############ CORRELATION ################
df_infection=read.csv("/Users/anam/Documents/First/Masters/UW/Thesis/WoundInf_Tests_Flattened.csv")
labels=read.csv("/Users/anam/Documents/First/Masters/UW/Thesis/WoundInf_Train_Labels.tsv",sep="\t",header = TRUE)
labels$Infection[labels$Infection==2] = 1
labels$Infection=as.integer(labels$Infection)
library(stats)
df_infection[is.na(df_infection)]=0
corr=cor(df_infection,labels$Infection,method = "pearson")
write.csv(corr,"/Users/anam/Documents/First/Masters/UW/Thesis/PearsonCorr.csv")

corr=cor(df_infection,labels$Infection,method = "kendall")
write.csv(corr,"/Users/anam/Documents/First/Masters/UW/Thesis/KendallCorr.csv")

corr=cor(df_infection,labels$Infection,method = "spearman")
write.csv(corr,"/Users/anam/Documents/First/Masters/UW/Thesis/SpearmanCorr.csv")

