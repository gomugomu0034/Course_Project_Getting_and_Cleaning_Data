# Course Project Getting and Cleaning Data

This repository contains:

README.md - provides overview    
CodeBook.md = the code book, which describes the contents of the data set    
run_analysis.R - the R script to create tidy data set     
tidy_data.txt - contains the final output of run_analysis.R.     

## Source
The source data set that this project was based on was obtained from the Human Activity Recognition Using Smartphones Data Set  

Training and test data were first merged together to create one data set, then the measurements on the mean and standard deviation were extracted for each measurement (79 variables extracted from the original 561), and then the measurements were averaged for each subject and activity, resulting in the final data set.  

## Script
The R script run_analysis.R can be used to create the data set. It retrieves the source data set and transforms it to produce the final data set by implementing the following steps:   
* Download and unzip source data if it doesn't exist.
* Read data.
* Merge the training and the test sets to create one data set.
* Extract only the measurements on the mean and standard deviation for each measurement.
* Use descriptive activity names to name the activities in the data set.
* Appropriately label the data set with descriptive variable names.
* Create a second, independent tidy set with the average of each variable for each activity and each subject.
* Write the data set to the tidy_data.txt file.
