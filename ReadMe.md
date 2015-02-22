---
title: "ReadMe"
author: "Diego Brusetti"
date: "Sunday, February 22, 2015"
output: html_document
---

## Course 3 Project assignment ##
You should create one R script called **run_analysis.R** that does the following:

- Merges the training and the test sets to create one data set
- Extracts only the measurements on the mean and standard deviation for each measurement
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

## Development ##

First step, this script will work only if the **UCI HAR Dataset** is unzipped in the same folder (working directory).
An error message is shown in case this condition is not satisfied.

``` 
if (!file.exists("UCI HAR Dataset")) stop("Please unzip data into \"UCI HAR Dataset\" folder in the current dicrectory.")
``` 
Then, I load the **dplyr** function library, required for my script to run:

```
library("dplyr")
``` 

Second step, I load the measurement collections into two tables, test.x and train.x:

``` 
test.x <- read.table("UCI HAR Dataset//test//X_test.txt", header = FALSE, dec = ".")
train.x <- read.table("UCI HAR Dataset//train/X_train.txt", header = FALSE, dec = ".")
``` 
> As you can see, I keep the "UCI HAR Dataset" original archive structure.

Then, I merged the measurements into one dataset:
`merged.x <- rbind(test.x, train.x)`

Now that I have all measurements in one table, I want to add the activity names column:
``` 
# Load activity names
activity.l <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, col.names = c("Activity_ID", "Activity_Name"))
# Load activities for test and training sessions
test.y <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("Activity_ID"))
train.y <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = c("Activity_ID"))
# Merge activities with their labels
merged.y <- rbind(test.y, train.y)
merged.l <- merge(merged.y, activity.l)
# Add activity labels to merged dataset
myDataset <- cbind(merged.l$Activity_Name, merged.x)
# Rename column
names(myDataset)[1] <- c("Activity_Name")
``` 

Now I want to name all the measurement columns as well: I get the variable names from the file *features.txt*.
``` 
features.l <- read.table("UCI HAR Dataset/features.txt", col.names = c("Feat_ID", "Feat_Name"))
features.n <- as.character(features.l$Feat_Name)
names(myDataset) <- c("Activity_Name", features.n)
``` 

Somewhere in the code, I wanted to keep clean the memory by deleting unused structures, like this:
``` 
rm(activity.l, features.l, features.n, merged.l, merged.x, merged.y)
rm(test.x,test.y,train.x,train.y)
``` 

Let's recap for a while: I have a table colleting all measurements, I have named the activity related to each observation, and I have also named all variables in a readable manner. Now, I want to add the person's ID (*Subject_ID*) to each observation:
``` 
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject_ID"))
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject_ID"))
subjects <- rbind(subject.test, subject.train)
myDataset <- cbind(subjects, myDataset)
myDataset <- tbl_df(myDataset) # better look
``` 
> Since I am using the "dplyr" library, I want to use the table_df function in order to make better looking datasets.

Well, I've made quite extensive use of temporary variables, I'll clean some off:
`rm(subject.test, subject.train, subjects)`

Now, I want to shrink the dataset to only important values I need to observe: this is the first tidy dataset containing only standard deviation and average measurements.
``` 
myDataset.cn <- names(myDataset)
stdCols <- grep("std()", myDataset.cn)
meanCols <- grep("mean()", myDataset.cn)
selectedCols <- c(1, 2, stdCols, meanCols) # keep subject ID and activity name
MeansAndStdDevs <- myDataset[, selectedCols]
MeansAndStdDevs <- tbl_df(MeansAndStdDevs) # better look
``` 

Again, I clean off temporary sets: `rm(meanCols, stdCols, selectedCols, myDataset.cn, myDataset)` 

Here I come with the final product: from the previous shrinked dataset, I am extracting a tidy dataset containing the means of all the variables grouped by activity and subject.
``` 
Groups <- group_by(MeansAndStdDevs, Activity_Name, Subject_ID)
# Calculate mean for each numeric variable
TidyDataset <- summarise_each(Groups, funs(mean), 3:81)
# Order by actvity and subject
TidyDataset <- arrange(TidyDataset, Activity_Name, Subject_ID)
``` 

Finally, I want my script to make visible the tidy dataset by opening it in a View() window:
``` 
# Show the result
View(TidyDataset)
``` 

Good luck with my **TidyDataset**!