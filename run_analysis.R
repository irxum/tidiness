#
# Author:  Alex Kwan
#
# run_analysis.R
#
#
library(dplyr)
library(reshape2)


setwd("C:/Users/FS110729/Google Drive/Coursera/Getting and Cleaning Data/UCI HAR Dataset")


# load test and training data
X_test_ds <- read.table("./test/X_test.txt")
Y_test_ds <- read.table("./test/Y_test.txt")
subject_test_ds <- read.table("./test/subject_test.txt")
X_train_ds <- read.table("./train/X_train.txt")
Y_train_ds <- read.table("./train/Y_train.txt")
subject_train_ds <- read.table("./train/subject_train.txt")

#-----------
# 1.  Merges the training and the test sets to create one data set, "test_n_train"
#
# From the README.txt file, I understood the following:
# Y_test and Y_train contain labels
# X_test and X_train contain features
# subject_test and subject_train contain subject who performed the test,
# So merging would involve adding Y_test and subject_test as additional column to X_test
test_ds <- cbind(X_test_ds, Y_test_ds, subject_test_ds)

# and adding Y_train and subject_train as additional columns to and X_train
train_ds <- cbind(X_train_ds, Y_train_ds, subject_train_ds)

# and adding the resultant train dataset as addtional rows to the test dataset.
test_n_train <- rbind(test_ds, train_ds)
#-----------

#-----------
# 2. Extracts only the measurements on the mean and standard deviation for each measurement as "key_meas"
#
# features.txt explain the measurements
features <- read.table("./features.txt")

# find all measurements on the mean
features_mean <- grepl("mean()",features$V2,fixed=TRUE)

# find all measuremetns on the standard deviation
features_std <- grepl("std()", features$V2)

# all measurements on the mean and standard deviation is just a vector addition
features_mean_std <- features_mean + features_std

# all indices that represent measurements on the mean and standard deviation
features_mean_std_indices <- which(features_mean_std %in% 1)

# "key_meas" will contain all measurements on the mean and standard deviation
# as well as adding back in the Y and subject columns as the first two columns
key_meas <- test_n_train[,features_mean_std_indices]
key_meas <- cbind(test_n_train[,ncol(test_n_train)],test_n_train[,(ncol(test_n_train)-1)],key_meas)
names(key_meas)[1]<-"subject"
names(key_meas)[2]<-"act_code"
#-----------

#-----------
# 3. Uses descriptive activity names to name the activities in the data set, "key_meas"
#
# activity_labels.txt links the class labels with their activity name.
activity_labels <- read.table("./activity_labels.txt")
activity_labels <- rename(activity_labels, act_code = V1, activity = V2 )
key_meas <- merge(key_meas,activity_labels,all.x=TRUE)
#-----------

#-----------
# 4. Appropriately label the data set, "key_meas", with descriptive variable names
#
# features.txt explain the remaining variables in "key_meas" dataset
# set startcol and endcol as column indices we want to update with descriptive variable names
startcol <- 3
endcol <- startcol+length(features_mean_std_indices)-1

# var_names is a vector of strings that contain the appropriate names from features
var_names <- as.character(features[features_mean_std_indices,2])
names(key_meas)[startcol:endcol]<-var_names

# rearrange columns so that the activity column is second after the act_code instead of the end
# dropping act_code because it is redundant with activity and less descriptive
key_meas <- select(key_meas, activity, subject, contains("()"))
#------------


#------------
# 5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
#
# first use melt to reorganize data so that the measurements become a variable along with the values
key_meas_melt <- melt(key_meas, id=c("activity","subject"), measure.vars=var_names)

# then use dcast to reorganize the data and take average of each variable for each activity and subject
key_meas_cast <- dcast(key_meas_melt, activity + subject ~ variable, mean)

# then use melt again to reorganize into tidy format
key_meas_tidy <- melt(key_meas_cast, id=c("activity","subject"), measure.vars=var_names)

# finally write the tidy dataset to a file
write.table(key_meas_tidy, "./key_meas_tidy.txt", row.name = FALSE, sep="\t")
#------------
