# Set working directory
setwd("~/DataScience/Getting and Cleaning Data/Project")
# Clear global environment
rm(list=ls()) 

# create data directory if it doesn't exist, download data from the URL and unzip the data  
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")
unzip("./data/Dataset.zip", exdir = "./data")

# Read data from TEST directory
xTestData <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
dim(xTestData) # 2947  561
subjectTestData <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
dim(subjectTestData) # 2947    1
yTestData <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
dim(yTestData) # 2947    1

# Read data from TRAIN folder
xTrainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
dim(xTrainData) # 7352  561
subjectTrainData <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
dim(subjectTrainData) # 7352    1
yTrainData <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
dim(yTrainData) # 7352    1

## 1. Merges the training and the test sets to create one data set.

# Merging Test and Train data
xMergedData <- rbind(xTestData, xTrainData)
dim(xMergedData) # 10299   561

subjectMergedData <- rbind(subjectTestData, subjectTrainData)
dim(subjectMergedData) # 10299     1

yMergedData <- rbind(yTestData, yTrainData)
dim(yMergedData) # 10299     1

# Read features dataset
features <- read.table("./data/UCI HAR Dataset/features.txt")
dim(features) # 561   2
# rename Merged Dataset headers using features data
names(xMergedData) <- features[, 2]

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# filter only columns that contain "Mean" and Standard Deviation "Std" 
MeanStdData <- grep("-(mean|std)\\(\\)", features[, 2])
xMergedData <- xMergedData[, MeanStdData]
dim(xMergedData) # 10299    66

## 3. Uses descriptive activity names to name the activities in the data set

# Read activities data
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# update values in yMergedData with activity names
yMergedData[, 1] <- activities[yMergedData[, 1], 2]

names(yMergedData) <- "Activity"  
names(subjectMergedData) <- "Subject"

## 4. Appropriately labels the data set with descriptive variable names. 

# replacing t with Time, f with Frequency, mean() with Mean, std() with StandardDeviation, 
# BodyBody with Body, -X with _X, etc.
names(xMergedData) <- gsub("^t", "Time_", names(xMergedData))
names(xMergedData) <- gsub("^f", "Frequency_", names(xMergedData))
names(xMergedData) <- gsub("-mean\\(\\)", "_Mean", names(xMergedData))
names(xMergedData) <- gsub("-std\\(\\)", "_StandardDeviation", names(xMergedData))
names(xMergedData) <- gsub("-X", "_X", names(xMergedData))
names(xMergedData) <- gsub("-Y", "_Y", names(xMergedData))
names(xMergedData) <- gsub("-Z", "_Z", names(xMergedData))
names(xMergedData) <- gsub("BodyBody", "Body", names(xMergedData))

# Merge all data (xMergedData, yMergedData, subjectMergedData) together
allMergedData <- cbind(xMergedData, yMergedData, subjectMergedData)
dim(allMergedData) # 10299    68

## 5. From the data set in step 4, creates a second, independent tidy data set 
##   with the average of each variable for each activity and each subject.

# use plyr package
library(plyr)
tidyData <- ddply(allMergedData, .(Subject, Activity), function(x) colMeans(x[, 1:66]))

# write data
write.table(tidyData, "tidyData.txt", row.names = FALSE)
