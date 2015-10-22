# Cleaningdata Code Book

The raw data from the UCI HAR Dataset has two parts - a training data set and a test data set.  The description below is for the files in the test data set (filename contains _test), but the training data is identical with filenames containing _train.  Each of these data sets has:

* x_test.txt - a file containing 561 columns of data, where each row of data is a record.  Each row corresponds to the set of 561 measurements collected for a single experiment.

* subject_test.txt - contains a single numeric column.  Each row identifies the subject associated with the corresponding row of measurement data in x_test.txt.  There are 30 volunteers, so the numeric ranges from 1-30.

* y_test.txt - contains a single numeric column.  Each number (1-6) represents a specific activity performed.  Each row identifies the activity associated with the corresponding row of measurement data in x_test.txt

In the UCI HAR directory, the following files are used:

* activity_labels.txt - this provides a description fo the 6 numeric activities referenced in y_test.txt and y_train.txt

* features.txt - this contains 561 rows of character strings.  Each row identifies a measurement name associated with the each column in x_test.txt and x_train.txt

## Processing the UCI HAR Dataset
The training and test data sets have data split across 3 files (e.g. x_test, y_test, and subject_test).  The processing does the following:

1.  Combines the data from the 3 files into 1 single data frame, where the subject (subject_test) and activity (y_test) are prepended as columns 1 and 2 to the remaining x_test data (561 columns)

2.  In the processing, a descriptive activity label is inserted in place of the numeric used to indicate activity.  The mapping of numeric to activity description is specified in the activity_labels.txt file.

3.  Steps are taken to ensure all column names are unique - even though they are represented as generic variable names at some points in the processing (see code comments).

4.  The same processing is applied to both training and test data files.

5.  The training and test data frames are then bound together by row.

6.  A proper header row is created by inserting subject, activity, and the 561 feature names from the file features.txt.  This character vector that properly describes each column in the combined data set is then used as the final set of column names.

7.  Note that some column names from the features.txt file are duplicate.  None of these duplicates contain the words "mean" or "std" and are removed at the next step

8.  The resultant data frame is then filtered to only include columns that contain the strings "mean" or "std".  Hence any duplicate column names are removed in this process (see code comments).  This data frame is referred to as "step4" in the script.

9. The script then groups the data in the step4 frame by subject and activity, and computes the mean for each column.  The resultant data set is referred to as "step5" in the script.

## Description of variables in the final data set.
There are 81 columns in the data, each described below.:

1.  subject - contains a numeric from 1-30 identifying which of the 30 volunteers is associated with a row of data.  This is of type numeric.

2.  activity - contains a description of the activity associated with the row of data.  This is one of the 6 values identified in the HAR activity_labels.txt file.

3.  columns 3-81 - These columns are the measurements in the original HAR dataset that contain the words "mean" or "std".  Each column in the final dataset contains the average value (mean) computed for the measurement name, for the combination of subject/activity identified in columns 1 and 2.  Each column is of type numeric.

