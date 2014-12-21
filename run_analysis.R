#---------------------------------------------------------- 
# Data Science - Getting and Cleaning Data
# Course Project Assignment 
# 
# 1. Merges the training and the test sets to 
#    create one data set.
# 2. Extracts only the measurements on the mean 
#    and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the 
#    activities in the data set
# 4. Appropriately labels the data set with 
#    descriptive variable names.
# 5. From the data set in step 4, creates a second, 
#    independent tidy data set with the average of 
#    each variable for each activity and each subject.
#
# The code should have a file run_analysis.R in the 
# main directory that can be run as long as the 
# Samsung data is in your working directory. The 
# output should be the tidy data set you submitted 
# for part 1 (result from step 5)
#---------------------------------------------------------- 
# 
# See README.md         for an outline of the data 
#                       processing and clarification 
#                       of choices 
#
# See CodeBook.md       for a description of the 
#                       resulting data set
#
#---------------------------------------------------------- 

library(dplyr)
library(tidyr)

# set the name of the output file produced by this script
outputFileName <- "result.txt"

# read input files
testSubject <- read.table("subject_test.txt")
trainSubject <- read.table("subject_train.txt")

testY <- read.table("y_test.txt")
trainY <- read.table("y_train.txt")

testX <- read.table("X_test.txt")
trainX <- read.table("X_train.txt")

# merging test and training data per input file type and
# wrap the resulting data sets for usage with dplyr
subjectSet <- tbl_df(rbind(testSubject, trainSubject))
activitySet <- tbl_df(rbind(testY, trainY))
featureSet <- tbl_df(rbind(testX, trainX))

# remove original data sets as they are no longer needed
rm(testSubject, trainSubject, testY, trainY, testX, trainX)

# adding a descriptive variable name to the subject data set
names(subjectSet) <- "subject"

# treat the numerical subject value as as factor
subjectSet$subject <- factor(subjectSet$subject)

# adding a descriptive variable name to the activity data set
names(activitySet) <- "activity"

# replace the numerical activity values with descriptive 
# activity labels from activity_labels.txt
activityLabels <- read.table("activity_labels.txt")
names(activityLabels) <- c("id", "name")

# we can take advantage of the row index being identical
# to the activity id, so activitySet$name[i] will give 
# the name for the activity with the id i. The original
# data frame will be replaced.
activitySet = tbl_df(data.frame(activity = 
                     sapply(activitySet,
                     function(e) {activityLabels$name[e]})))

# remove activityLabels data set as it is no longer needed
rm(activityLabels)

# read feature labels for column extraction and labeling
featureLabels <- read.table("features.txt")
names(featureLabels) <- c("id", "name")

# Prepare extraction of measurements on the mean and standard 
# deviation for each measurement in the featureSet.
# Only variable names containing mean() or std() are retained.
# Get the names for mean and deviation variables
nameMeanStd <- grep("std\\(\\)|mean\\(\\)", featureLabels$name, value = TRUE)
# Get the index for mean and deviation variables
indexMeanStd  <- grep("std\\(\\)|mean\\(\\)", featureLabels$name)

# Extracting only mean and standard deviation columns
featureSet <- select(featureSet, indexMeanStd)

# Adding descriptive variable names to the feature data set
names(featureSet) <- tolower(nameMeanStd)

# remove local variables which are no longer needed
rm(featureLabels, nameMeanStd, indexMeanStd)

# combine subject, activity and feature datasets into one dataset
allData <- cbind(subjectSet, cbind(activitySet, featureSet))

# Creating a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
# Group by subject and activity

allDataGrouped <- group_by(allData, subject, activity)
allDataAggregate <- summarize(allDataGrouped
                              ,"mean-fbodyacc-mean()-x" = mean(allDataGrouped$"fbodyacc-mean()-x")
                              ,"mean-fbodyacc-mean()-y" = mean(allDataGrouped$"fbodyacc-mean()-y")
                              ,"mean-fbodyacc-mean()-z" = mean(allDataGrouped$"fbodyacc-mean()-z")
                              ,"mean-fbodyacc-std()-x" = mean(allDataGrouped$"fbodyacc-std()-x")
                              ,"mean-fbodyacc-std()-y" = mean(allDataGrouped$"fbodyacc-std()-y")
                              ,"mean-fbodyacc-std()-z" = mean(allDataGrouped$"fbodyacc-std()-z")
                              ,"mean-fbodyaccjerk-mean()-x" = mean(allDataGrouped$"fbodyaccjerk-mean()-x")
                              ,"mean-fbodyaccjerk-mean()-y" = mean(allDataGrouped$"fbodyaccjerk-mean()-y")
                              ,"mean-fbodyaccjerk-mean()-z" = mean(allDataGrouped$"fbodyaccjerk-mean()-z")
                              ,"mean-fbodyaccjerk-std()-x" = mean(allDataGrouped$"fbodyaccjerk-std()-x")
                              ,"mean-fbodyaccjerk-std()-y" = mean(allDataGrouped$"fbodyaccjerk-std()-y")
                              ,"mean-fbodyaccjerk-std()-z" = mean(allDataGrouped$"fbodyaccjerk-std()-z")
                              ,"mean-fbodyaccmag-mean()" = mean(allDataGrouped$"fbodyaccmag-mean()")
                              ,"mean-fbodyaccmag-std()" = mean(allDataGrouped$"fbodyaccmag-std()")
                              ,"mean-fbodybodyaccjerkmag-mean()" = mean(allDataGrouped$"fbodybodyaccjerkmag-mean()")
                              ,"mean-fbodybodyaccjerkmag-std()" = mean(allDataGrouped$"fbodybodyaccjerkmag-std()")
                              ,"mean-fbodybodygyrojerkmag-mean()" = mean(allDataGrouped$"fbodybodygyrojerkmag-mean()")
                              ,"mean-fbodybodygyrojerkmag-std()" = mean(allDataGrouped$"fbodybodygyrojerkmag-std()")
                              ,"mean-fbodybodygyromag-mean()" = mean(allDataGrouped$"fbodybodygyromag-mean()")
                              ,"mean-fbodybodygyromag-std()" = mean(allDataGrouped$"fbodybodygyromag-std()")
                              ,"mean-fbodygyro-mean()-x" = mean(allDataGrouped$"fbodygyro-mean()-x")
                              ,"mean-fbodygyro-mean()-y" = mean(allDataGrouped$"fbodygyro-mean()-y")
                              ,"mean-fbodygyro-mean()-z" = mean(allDataGrouped$"fbodygyro-mean()-z")
                              ,"mean-fbodygyro-std()-x" = mean(allDataGrouped$"fbodygyro-std()-x")
                              ,"mean-fbodygyro-std()-y" = mean(allDataGrouped$"fbodygyro-std()-y")
                              ,"mean-fbodygyro-std()-z" = mean(allDataGrouped$"fbodygyro-std()-z")
                              ,"mean-tbodyacc-mean()-x" = mean(allDataGrouped$"tbodyacc-mean()-x")
                              ,"mean-tbodyacc-mean()-y" = mean(allDataGrouped$"tbodyacc-mean()-y")
                              ,"mean-tbodyacc-mean()-z" = mean(allDataGrouped$"tbodyacc-mean()-z")
                              ,"mean-tbodyacc-std()-x" = mean(allDataGrouped$"tbodyacc-std()-x")
                              ,"mean-tbodyacc-std()-y" = mean(allDataGrouped$"tbodyacc-std()-y")
                              ,"mean-tbodyacc-std()-z" = mean(allDataGrouped$"tbodyacc-std()-z")
                              ,"mean-tbodyaccjerk-mean()-x" = mean(allDataGrouped$"tbodyaccjerk-mean()-x")
                              ,"mean-tbodyaccjerk-mean()-y" = mean(allDataGrouped$"tbodyaccjerk-mean()-y")
                              ,"mean-tbodyaccjerk-mean()-z" = mean(allDataGrouped$"tbodyaccjerk-mean()-z")
                              ,"mean-tbodyaccjerk-std()-x" = mean(allDataGrouped$"tbodyaccjerk-std()-x")
                              ,"mean-tbodyaccjerk-std()-y" = mean(allDataGrouped$"tbodyaccjerk-std()-y")
                              ,"mean-tbodyaccjerk-std()-z" = mean(allDataGrouped$"tbodyaccjerk-std()-z")
                              ,"mean-tbodyaccjerkmag-mean()" = mean(allDataGrouped$"tbodyaccjerkmag-mean()")
                              ,"mean-tbodyaccjerkmag-std()" = mean(allDataGrouped$"tbodyaccjerkmag-std()")
                              ,"mean-tbodyaccmag-mean()" = mean(allDataGrouped$"tbodyaccmag-mean()")
                              ,"mean-tbodyaccmag-std()" = mean(allDataGrouped$"tbodyaccmag-std()")
                              ,"mean-tbodygyro-mean()-x" = mean(allDataGrouped$"tbodygyro-mean()-x")
                              ,"mean-tbodygyro-mean()-y" = mean(allDataGrouped$"tbodygyro-mean()-y")
                              ,"mean-tbodygyro-mean()-z" = mean(allDataGrouped$"tbodygyro-mean()-z")
                              ,"mean-tbodygyro-std()-x" = mean(allDataGrouped$"tbodygyro-std()-x")
                              ,"mean-tbodygyro-std()-y" = mean(allDataGrouped$"tbodygyro-std()-y")
                              ,"mean-tbodygyro-std()-z" = mean(allDataGrouped$"tbodygyro-std()-z")
                              ,"mean-tbodygyrojerk-mean()-x" = mean(allDataGrouped$"tbodygyrojerk-mean()-x")
                              ,"mean-tbodygyrojerk-mean()-y" = mean(allDataGrouped$"tbodygyrojerk-mean()-y")
                              ,"mean-tbodygyrojerk-mean()-z" = mean(allDataGrouped$"tbodygyrojerk-mean()-z")
                              ,"mean-tbodygyrojerk-std()-x" = mean(allDataGrouped$"tbodygyrojerk-std()-x")
                              ,"mean-tbodygyrojerk-std()-y" = mean(allDataGrouped$"tbodygyrojerk-std()-y")
                              ,"mean-tbodygyrojerk-std()-z" = mean(allDataGrouped$"tbodygyrojerk-std()-z")
                              ,"mean-tbodygyrojerkmag-mean()" = mean(allDataGrouped$"tbodygyrojerkmag-mean()")
                              ,"mean-tbodygyrojerkmag-std()" = mean(allDataGrouped$"tbodygyrojerkmag-std()")
                              ,"mean-tbodygyromag-mean()" = mean(allDataGrouped$"tbodygyromag-mean()")
                              ,"mean-tbodygyromag-std()" = mean(allDataGrouped$"tbodygyromag-std()")
                              ,"mean-tgravityacc-mean()-x" = mean(allDataGrouped$"tgravityacc-mean()-x")
                              ,"mean-tgravityacc-mean()-y" = mean(allDataGrouped$"tgravityacc-mean()-y")
                              ,"mean-tgravityacc-mean()-z" = mean(allDataGrouped$"tgravityacc-mean()-z")
                              ,"mean-tgravityacc-std()-x" = mean(allDataGrouped$"tgravityacc-std()-x")
                              ,"mean-tgravityacc-std()-y" = mean(allDataGrouped$"tgravityacc-std()-y")
                              ,"mean-tgravityacc-std()-z" = mean(allDataGrouped$"tgravityacc-std()-z")
                              ,"mean-tgravityaccmag-mean()" = mean(allDataGrouped$"tgravityaccmag-mean()")
                              ,"mean-tgravityaccmag-std()" = mean(allDataGrouped$"tgravityaccmag-std()")
                              )

# save result
write.table(allDataAggregate, outputFileName, row.names = FALSE, col.names=FALSE)





