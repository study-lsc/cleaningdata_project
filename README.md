# Cleaningdata - run_analysis.R

## Script Description

The script has multiple stages, which are documented with comments in the code.  You can run this code by typing source("run_analysis.R") at the R console.  Some commands in the script will take several seconds to run, due to the size of the data.

Summarizing the steps:

1.  Setup - This sets up data that will be needed in subsequent stages.
    + Loads the dplyr library.  This is needed to bind the two datasets together by row, and to apply processing to sub-groups within the dataset.
    + Reads in the features.txt file and makes a header row out of it, including new column names prepended for subject and activity.

2.  Load test and training datasets and add subject/activity columns
    + This stage reads in the x_test (the 561 column measurement data), the y_test actvity data (will become the activity column), and the subject_test data (will become the subject column).
    + It reads in the activity_labels.txt and uses this to create descriptive labels for the levels in y_test.
    + It prepends the subject and activity columns to the 561 column measurement data using cbind (column bind)
    + Column names are made identical between the test and training datasets.  This is necessary to ensure the rows can be concatenated.  Note:  At this stage, the column names, are subject, new_y, V1, V2, V3....v561.  Since the 561 column x_data had no column names, R assigned generic variable names.
    + The same processing is applied for the training data files.

3.  Merge test and training data sets
    + This stage adds the rows of the test and training sets together using dplyr rbind_list
    + Replaces the existing header row, composed of generic variable names, with the real measurement names created in the Setup stage
    + Note:  While there are 561 columns, there are only 477 unique column names.  Some column names are duplicated in the features.txt file.  Fortunately, none of the duplicate column names contain "mean" or "std", and will be removed before data is further processed.

4.  Extract columns of interest
    + This stage finds the columns that have "subject, activity, mean, or std" strings within the column name. These are the columns to be extracted into a new data frame called step4
    + Note: Columns with duplicate names are removed at this step.  This is important as dplyr functions check for duplicate column names and will reject data frames with duplicate column names.
    
5.  Group step4 data by subject and activity, then calculate column means
    + Use group_by to segment the rows into groups of interest, and calculate the mean of all columns
    + write out the resultant table to step5.txt, without row names.
    
