#Getting and Cleaning Data - Course Project

###Files

This repository hosts the following files:

CodeBook.md:  Describes input/output variables and transformation steps performed to get tidy dataset.

run_analysis.R: Contains all the code to perform the analysis described in the following steps. 

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
-	Uses descriptive activity names to name the activities in the data set
-	Appropriately labels the data set with descriptive variable names. 
-	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###Running run_analysis.R
- Create a directory and copy R script to this directory
- Download datafile (Human Activity Recognition Using Smartphones Data Set) and unzip into a new ‘data’ directory
- Run the  R ‘run_analysis.R’ script which would create ‘tidyData.txt file in the current working directory. 

###Transformation performed by the R script

- Download data from the URL and unzip the data and create data directory if it doesn't exist
- Read data from TEST directory
- Read data from TRAIN folder
- Merging Test and Train data
- Read features dataset
- Rename Merged Dataset headers using features data
- Filter only columns that contain "Mean" and Standard Deviation "Std"
- Read activities data and update values with activity names
- Label the data set with descriptive variable names (by replacing t with Time, f with Frequency, mean() with Mean, std() with StandardDeviation, BodyBody with Body, -X with _X, etc.)
- Merge all datasets together
- Create a tidy data set with the average of each variable for each activity and each subject
- ddply() from the plyr package is used to calculate colMeans()
- Write the tidyData.txt in the current working directory
