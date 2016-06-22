# Coursera - Getting and Cleaning Data Course Project

This course project is for the Coursera Getting and Cleaning Data Course Project.  In addition to this readme file, this repository
contains the following:

**run_analysis.R** was used to do the following
- Download the necessary zip file from the web
- Extract all of the information from the zip file
- Read in features and activity labels
- Read in each of the necessary text files containing sampled values from the train and test folders
- Assign the feature headings to the train and test datasets containing samples and only extract those variables that contain means and standard deviations
- Attach the activity names to the activity IDs
- Combine subject IDs, activity IDs and names, and variable values separately for train and test
- Combine newly train and test sets where subject IDs and activity ID and names have been aggregated
- Transpose dataset such that all combinations of subject IDs, activity IDs and names, and variable names are represented as individual rows
- Calculate means by subject IDs and activity IDs and names
- The end result is **tidy.txt**
  
**CodeBook.md** provides descriptions of each of the variables in the final dataset **tidy.txt** as output by **run_analysis.R**

