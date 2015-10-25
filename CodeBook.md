Source Data https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

stage1 Merge the following data sets into one
/train/subject_train.txt
/train/X_train.txt
/train/y_train.txt
/test/subject_test.txt
/test/X_test.txt
/test/y_test.txt
activity_labels.txt
features.txt

stage2 reduce metriccolumns to only mean and std dev

stage 3 merge activity name

stage 4 improve readability for metric columns

stage 5 average value over activity and subject

Result equals tidy dataset tidyData.txt 
