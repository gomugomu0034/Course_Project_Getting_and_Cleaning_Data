#including library 'dplyr' to perform operations on data frame
library(dplyr)

#downloading data from the given link
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataFile <- "UCI HAR Dataset.zip"
if (!file.exists(dataFile)) {
        download.file(fileUrl,dataFile)
}

#unzipping the zip file
if (!file.exists("UCI HAR Dataset")) {
        unzip(dataFile)
}

#reading training data files, 3 data files available
#training subects, training values and training activities
train_Subj <- read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"))
train_Val <- read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"))
train_Activ <- read.table(file.path("UCI HAR Dataset", "train", "y_train.txt"))

#reading test data files, 3 data files available
#test subects, test values and test activities
test_Subj <- read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"))
test_Val <- read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"))
test_Activ <- read.table(file.path("UCI HAR Dataset", "test", "y_test.txt"))

#reading features and activities characters from respective data files
features <- read.table(file.path("UCI HAR Dataset", "features.txt"), as.is = TRUE)
activities <- read.table(file.path("UCI HAR Dataset", "activity_labels.txt"))

#assigning colnames to activity table
colnames(activities) <- c("activityId", "activityLabel")

#binding training and test data tables, all the training data tables are 
#column binded, test data tables are row binded with training data tables
merged_table <- rbind(
        cbind(train_Subj, train_Val, train_Activ),
        cbind(test_Subj, test_Val, test_Activ)
)

#saving RAM memory
rm(train_Subj, train_Val, train_Activ, 
   test_Subj, test_Val, test_Activ)

#assigning names to columns in merged table
colnames(merged_table) <- c("subject", features[, 2], "activity")

#filtering merged_table to select only those tables that have mean and
#standard deviation data
columns_required <- grepl("subject|activity|mean|std", colnames(merged_table))
new_merged_table <- merged_table[, columns_required]

#adding labels to activity data
new_merged_table$activity <- factor(new_merged_table$activity, 
                                    levels = activities[, 1], labels = activities[, 2])


#removing unneeded strings from the column names
#making column names as descriptive as possible
new_merged_table_Cols <- colnames(new_merged_table)

new_merged_table_Cols <- gsub("[\\(\\)-]", "", new_merged_table_Cols)

new_merged_table_Cols <- gsub("^f", "frequencyDomain", new_merged_table_Cols)
new_merged_table_Cols <- gsub("^t", "timeDomain", new_merged_table_Cols)
new_merged_table_Cols <- gsub("Acc", "Accelerometer", new_merged_table_Cols)
new_merged_table_Cols <- gsub("Gyro", "Gyroscope", new_merged_table_Cols)
new_merged_table_Cols <- gsub("Mag", "Magnitude", new_merged_table_Cols)
new_merged_table_Cols <- gsub("Freq", "Frequency", new_merged_table_Cols)
new_merged_table_Cols <- gsub("mean", "Mean", new_merged_table_Cols)
new_merged_table_Cols <- gsub("std", "StandardDeviation", new_merged_table_Cols)
new_merged_table_Cols <- gsub("BodyBody", "Body", new_merged_table_Cols)

colnames(new_merged_table) <- new_merged_table_Cols

#generating means for various activities in the merged table
Activity_Means <- new_merged_table %>% 
        group_by(subject, activity) %>%
        summarise_each(list(mean))

#printing the newly formed data table to a text file
write.table(Activity_Means, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)
