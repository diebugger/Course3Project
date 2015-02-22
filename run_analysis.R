### course 3 project ###

# Check file exists
if (!file.exists("UCI HAR Dataset")) stop("Please unzip data into \"UCI HAR Dataset\" folder in the current dicrectory.")

# Load function libraries
library("dplyr")

# Load files
test.x <- read.table("UCI HAR Dataset//test//X_test.txt", header = FALSE, dec = ".")
train.x <- read.table("UCI HAR Dataset//train/X_train.txt", header = FALSE, dec = ".")

## Merges the training and the test sets to create one data set
merged.x <- rbind(test.x, train.x)

## Uses descriptive activity names to name the activities in the data set
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

## Appropriately labels the data set with descriptive variable names
features.l <- read.table("UCI HAR Dataset/features.txt", col.names = c("Feat_ID", "Feat_Name"))
features.n <- as.character(features.l$Feat_Name)
names(myDataset) <- c("Activity_Name", features.n)

# Clean up some dirt
rm(activity.l, features.l, features.n, merged.l, merged.x, merged.y)
rm(test.x,test.y,train.x,train.y)

# Add subjects IDs to the dataset
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject_ID"))
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject_ID"))
subjects <- rbind(subject.test, subject.train)
myDataset <- cbind(subjects, myDataset)
myDataset <- tbl_df(myDataset) # better look

# Clean up some dirt
rm(subject.test, subject.train, subjects)

## Extracts only the measurements on the mean and standard deviation for each measurement
myDataset.cn <- names(myDataset)
stdCols <- grep("std()", myDataset.cn)
meanCols <- grep("mean()", myDataset.cn)
selectedCols <- c(1, 2, stdCols, meanCols) # keep subject ID and activity name
MeansAndStdDevs <- myDataset[, selectedCols]
MeansAndStdDevs <- tbl_df(MeansAndStdDevs) # better look

# Clean up some dirt
rm(meanCols, stdCols, selectedCols, myDataset.cn, myDataset)

## From the data set MeansAndStdDev, creates a second, independent tidy data set with 
## the average of each variable for each activity and each subject
Groups <- group_by(MeansAndStdDevs, Activity_Name, Subject_ID)
# Calculate mean for each numeric variable
TidyDataset <- summarise_each(Groups, funs(mean), 3:81)
# Order by actvity and subject
TidyDataset <- arrange(TidyDataset, Activity_Name, Subject_ID)

# Show the result
View(TidyDataset)
