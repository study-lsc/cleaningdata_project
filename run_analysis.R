

#  This script is the project for the JHDS Cleaning Data course
#  The program assumes your R working directory has the UCI HAR dataset in it (e.g. the working dir has
#  the features.txt, activity_labels.txt, the test folder, and the train folder).  It assumes
#  the dplyr package has already been installed, so the library can just be loaded.
#  v1.0 - 10/22/15

#setwd("/Users/lchin/Documents/cleaningdata/UCI HAR Dataset")

library(dplyr)

# first read the features list.  You need this to create the column names for the target file
# note:  there are duplicate feature names.  This will create problems later, as some
# R commands (e.g. the dplyr commands) check the validity of your data frames, and will error
# out if there are duplicate column names.  However, none of the duplicates have the words "mean" or "std"
# in them, and the columns with duplicate names will be removed before processing hits that stage
features<-read.table("features.txt", sep=" ", stringsAsFactors = FALSE)
myheader<-features[,2]

# create the column names for the target data by prepending the subject and activity labels as 1st 2 columns
myheader<-c("subject", "activity",myheader)

# read in the test data set
x_test<-read.table("test/X_test.txt")
y_test=read.table("test/y_test.txt")
subject_test=read.table("test/subject_test.txt")

# note:  apply the proper column name to this data set so you can bind columns later
names(subject_test)<-c("subject")

activity<-read.table("activity_labels.txt")
# turn numeric y_test into factors.  This lets you add "labels" easily using the levels command
new_y<-factor(y_test[,1])
# add the descriptive activity labels as levels
levels(new_y)<-activity[,2]

# create a frame with the subject and new_y columns, along with the 561 column "test" data set.
# note:.  new_y will be re-used when the training data set is read, but that is ok since we only
# used it to create the test data set.  The column name for new_y defaults to "new_y", the name
# of the variable.
temp_test<-cbind(new_y, x_test)
temp_test<-cbind(subject_test, temp_test)

# At this point data frame temp_test has column names subject, new_y, V1, V2, V3, etc.
# The proper column names associated with final combined data set will be inserted at a later step
#names(temp_test)<-myheader

# read in the training data set
x_train<-read.table("train/X_train.txt")
y_train=read.table("train/y_train.txt")

subject_train=read.table("train/subject_train.txt")

# note:  apply the proper column name to this data set so you can bind columns later
names(subject_train)<-c("subject")

# turn numeric y_train into factors.  This lets you add "labels" easily using the levels command
new_y<-factor(y_train[,1])
# add the descriptive activity labels as levels
levels(new_y)<-activity[,2]

# create a frame with the subject and new_y columns, along with the 561 column "test" data set.
temp_train<-cbind(new_y, x_train)
temp_train<-cbind(subject_train, temp_train)

# note: At this point, both temp_train and temp_test have the identical column names.  They have subject, new_y,
# and generic column names V1, V2, V3, etc (up to V561)  Having identical column names
# is important when binding rows together.

both_sets<-rbind_list(temp_train, temp_test)

# Earlier, a vector myheader was created containing subject, activity, and the 561 measurement names from features.txt
# Use this vector to insert the correct column names
names(both_sets)<-myheader

#  At this point, the data.frame both_sets contains the training set and test set concatenated together by row
#  The headers which were the generic V1, V2, V3, etc have been replaced with the feature names from features.txt
#  with two additional column names at the far left (subject and activity)

# the grep statement below identifies the indices in the myheader vector that are of interest and will be extracted for step 4
just_meanstd<-grep("subject|activity|mean|std", myheader, value=FALSE)
step4<-both_sets[,just_meanstd]

# using dplyr, group the rows by subject and activity, then summarize eaach of those groups by calculating
# the mean of all columns
step5<-group_by(step4, subject, activity) %>% summarize_each(funs(mean))


write.table(step5, file="step5.txt", row.names=FALSE)
