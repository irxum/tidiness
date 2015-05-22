---
title: "README.md"
author: "AKwan"
date: "Friday, May 22, 2015"
output: html_document
---

## GNC_project


Contents of this repo:

- README.md (this document)

- run_analysis.R:   
  This is the R script performing analysis.  No inputs are required.
  The script sets the working directory to contain the the Human
  Activity Recognition Using Smartphons Dataset.  It uses the dplyr
  and reshape2 libraries.  It consumes the
  training and test data, extracts only the measurements related to mean
  and standard deviation, converts the activity code to useful activity names,
  apply appropriate names to variables, and outputs a tidy data set that 
  has the average of each variable for each activity and each subject.  

- code_book.txt:  
  This code book describes the contents of key_meas_tidy.txt

- key_meas_tidy.txt:  
  This text file contains the tidy dataset which is output of run_analysis.R.
  This is considered a tidy dataset because it fulfills the three conditions:
  - Each variable measured in one column
  - Each different observation of variable in different row.
  - One table (the text file) for each kind of variable
  The "variable" column details the name of measurement.
  The "value" column is the average of the mean or standard deviation
  of measurement.  These values are unitless.  