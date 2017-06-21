#Setting current directory
setwd("/Users/aardelean/Google Drive/MyFiles/ProfDev/Coursera-Data Science/Getting and Cleaning Data")
getwd()
# Reading the data into R
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp<-tempfile()
download.file(fileUrl,temp, method="curl")
#unzipping the data and extracting subject_train.txt, features.txt, activity_labels.txt,
#X_train.txt, y_train.txt, subject_test.txt, X_test.txt, y_test
train_s<-read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
features<-read.table(unz(temp, "UCI HAR Dataset/features.txt"))
act_lab<-read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))
train_x <-read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
train_y <-read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
test_s<-read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
test_x <-read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
test_y <-read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
unlink(temp)

library(dplyr)
# rename variable V1 to subject in data frame train_s
train_s<-dplyr::rename(train_s, subject=V1)
# create a variable "n" which equals the number of rows in data frame train_s
train_s$n<-rownames(train_s)

#rename variable V1 to subject in data frame test_s
test_s<-dplyr::rename(test_s, subject=V1)
# create a variable "n" which equals the number of rows in data frame test_s
test_s$n<-rownames(test_s)

#rename variable V1 to activity in data frame train_y
train_y<-dplyr::rename(train_y, activity=V1)
# create a variable "n" which equals the number of rows in data frame train_y
train_y$n<-rownames(train_y)

#rename variable V1 to activity in data frame test_y
test_y<-dplyr::rename(test_y,activity=V1)
# create a variable "n" which equals the number of rows in data frame test_y
test_y$n<-rownames(test_y)

# rename variable V1 and V2 to activity and act_lab, respectively in data frame act_lab
act_lab<-dplyr::rename(act_lab, activity=V1)
act_lab<-dplyr::rename(act_lab, act_lab=V2)

library(plyr)

#name variables in train_x
l_train<-list(features$V2)
names(train_x)<-tolower(l_train[[1]])
train_x$n<-rownames(train_x)

#merge train_s, train_y and train_x to create train_syx with 7352 observations and 481 variables
dlist_train<-list(train_s, train_y, train_x)
train_syx<-join_all(dlist_train, "n")
train_syx$type="train"

#name variables in train_y
names(test_x)<-tolower(l_train[[1]])
test_x$n<-rownames(test_x)
#merge test_s, test_y and test_x to create test_syx with 2947 observations and 481 variables
dlist_test<-list(test_s, test_y, test_x)
test_syx<-join_all(dlist_test, "n")
test_syx$type="test"

#append train_syx and test_syx data frames
mydata<-rbind(train_syx, test_syx)
#merge mydata with act_lab data frame by variable activity
mydata<-merge(mydata, act_lab, by.x="activity")

#keep only variable subject, act_lab, and mean and std of measurements. 
#The resulting data frame has 10,299 observations and 68 variables
mydata<-select(mydata, subject, act_lab, contains("mean()"), contains("std()"))

#check that all data is non-missing
all(colSums(is.na(mydata))==0)

#rename variables in mydata"
names(mydata)<-gsub("^t", "time", names(mydata))
names(mydata)<-gsub("^f", "frequency", names(mydata))
names(mydata)<-gsub("BodyBody", "Body", names(mydata))

# write mydata data frame to a csv file named data.csv
write.csv(mydata, file="data.csv")

# create a data frame with means of measurements by subject and activity
# The resulting data frame has 180 observations and 68 variables
mydata_mean<-aggregate(select(mydata, -matches("subject|act_lab")),list(act_lab=mydata$act_lab,subject=mydata$subject),FUN = "mean")

# write mydata_mean data frame to a csv file named tidy_data.csv
write.csv(mydata_mean, file="tidy_data.csv")


