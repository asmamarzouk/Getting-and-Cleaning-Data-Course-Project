#download the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./Dataset.zip",exdir="./data")

## STEP 1- Merge the training and the test sets to create one data set.
# Read the files :
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table('./data/UCI HAR Dataset/features.txt')
activity_label = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Assign names to the columns 
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_label) <- c('activityId','activityType')

#Merge the data in one set
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

## STEP 2 - Extracts only the measurements on the mean and standard deviation for each measurement

#Read the columns :
colNames <- colnames(setAllInOne)

#extract the mean and std deviation
mean_stdDev <- (grepl("activityId" , colNames) 
                | grepl("subjectId" , colNames) 
                | grepl("mean.." , colNames) 
                | grepl("std.." , colNames))

set_mean_stdDev <- setAllInOne[ , mean_stdDev == TRUE]

## STEP 3 - Use descriptive activity names to name the activities in the data set
Activity_with_Names <- merge(set_mean_stdDev, activity_label, by='activityId', all.x=TRUE)

## STEP 4- label the data set with descriptive variable names.
TidyDataSet <- aggregate(. ~subjectId + activityId, Activity_with_Names, mean)
TidyDataSet <- TidyDataSet[order(TidyDataSet$subjectId, TidyDataSet$activityId),]

## STEP 5 - Write a second tidy data set

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)