# PROGRAM DESCRIPTION
# This program will download acceleromenter data from the web and load files to a
#   pre-specified directory. This program will download the appropriate zip file,
#   extract it, and load in all available files.

# The data is organized such that the training and test sets are separated as well
#   as the 3-axial signals (X, Y, Z). In addition, the column headings are separated.

# This program will merge all of the datasets together, filter for the desired
#   values needed (mean and standard deviation), and attach the activity names to the
#   activity ID numbers.

# A final dataset will be output that provides the means of each desired variable
#   by subject ID and activity.

# Load libraries
library(reshape)
library(dplyr)
library(data.table)
library(reshape2)

# Identify working directory to download data to
download <- c("C:\\Users\\Warren\\Desktop\\Coursework\\Coursera\\Getting and Cleaning Your Data\\Repository")

# Identify directory of UCI HAR Dataset
datadir <- c("C:\\Users\\Warren\\Desktop\\Coursework\\Coursera\\Getting and Cleaning Your Data\\Repository\\UCI HAR Dataset")

# Set working directory to download data to
setwd(download)

# Download accelerometer data from Samsung Galaxy S
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "project_data.zip")

# Unzip the contents to the current working directory
unzip("project_data.zip")

# Revise the working directory to include the extracted contents from zip file
setwd(datadir)

#########################################################################
# CREATE FEATURES
# The following section brings in the features.txt file and cleans it up

# Read in the features.txt data and provide column names
# These provide specific labels for the values coming from the train/text_X files
features <- read.table(file = "features.txt")
                       
names(features) <- c("Feature_Index","Feature_Variable")

# This column will be used as column heading for variable values
features$Feature_Variable <- gsub("[-()]","",features$Feature_Variable)

#########################################################################
# CREATE ACTIVITY LABELS
# The following section brings in the activity_labels.txt files and cleans
#   it up.

# Read in the activity_labels.txt file and provide column names
# These labels will label the code from the train/test_Y files
activity_labels <- read.table(file = "activity_labels.txt")
names(activity_labels) <- c("Act_Index","Activity_Name")

#########################################################################
# GET FILES FROM TRAIN FOLDER

train_files <- list.files(path = "train",
                          pattern = "txt",
                          full.names = TRUE,
                          recursive = TRUE,
                          include.dirs = TRUE)
                    
# Loop through file list and parse the names
for (i in 1:length(train_files)) {
  
  # Read in text file data based on vector of directory/file combos
  temp <- read.table(train_files[i])
  
  # Assigns temp to table name with directory removed
  file_name <- gsub(".*/","",train_files[i])
  file_name <- gsub(".txt","",file_name)
  assign(file_name, temp)
}

#########################################################################
# GET FILES FROM TEST FOLDER

test_files <- list.files(path = "test",
                          pattern = "txt",
                          full.names = TRUE,
                          recursive = TRUE,
                          include.dirs = TRUE)

# Loop through file list and parse the names
for (i in 1:length(test_files)) {
  
  # Read in text file data based on vector of directory/file combos
  temp <- read.table(test_files[i])
  
  # Assigns temp to table name with directory removed
  file_name <- gsub(".*/","",test_files[i])
  file_name <- gsub(".txt","",file_name)
  assign(file_name, temp)
}

#########################################################################
# START PUTTING FILES TOGETHER
# At this point, all necessary files have been read in. This section will
#   make the datasets tidy.

# The ACTIVITY labels will re-code the y_train and y_test tables.
# The FEATURES labels provide the column headings for the x_train and x_test
#   tables.

# TABLE DESCRIPTIONS

# Column labels
#   features: column headings to be used with X_train and X_test
#   activity_labels: descriptions to be used with y_train and y_test

# Sample values
#   subject_: person who performed activity
#   total_acc_: acceleration signal
#   body_acc_: body acceleration signal
#   body_gyro_: angular velocity vector


# Assign labels to features
names(X_train) <- features[,"Feature_Variable"]
names(X_test) <- features[,"Feature_Variable"]

# Create filter for columns with "mean" or "std"
include_flag <- grepl("mean|std", features$Feature_Variable)

# Filter columns to only include those columns with "mean" or "std"
X_train <- X_train[,include_flag]
X_test <- X_test[,include_flag]

# Assign activity and subject IDs
names(y_train) <- "Activity_ID"
names(y_test) <- "Activity_ID"

names(subject_train) <- "Subject_ID"
names(subject_test) <- "Subject_ID"

# Combine subject_, y_, and x_ tables for train and test separately
train_combine <- cbind(subject_train, y_train, X_train)
test_combine <- cbind(subject_test, y_test, X_test)

# Combine train_combine and test_combine into a single table
combine <- rbind(train_combine, test_combine)

# Attach legitimate activity names
combine <- merge(x = combine,
                 y = activity_labels,
                 by.x = "Activity_ID",
                 by.y = "Act_Index",
                 sort = FALSE)

# Re-sort columns such that activity is in front
combine <- combine[c(82,1:81)]

# Reshape data while holding subject and activity constant
combine_avg <- melt(combine, id = c("Subject_ID", "Activity_ID", "Activity_Name"))

# Calculate means by Subject_ID and Activity
combine_avg <- dcast(combine_avg, Subject_ID + Activity_ID + Activity_Name ~ variable, mean)

# Set working directory back to where this R program is located
setwd(download)

# Write final, full dataset to working directory
write.csv(combine, file = "tidy.csv", row.names = FALSE)

# Write dataset containing the averages by Subject_ID and Activity to working directory
write.csv(combine_avg, file = "averages.csv", row.names = FALSE)
