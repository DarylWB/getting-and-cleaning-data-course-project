rm(list=ls())

##download and unzip files
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
unzip(temp)
unlink(temp)

##getwd()
##list.files()
##set working directory
##getwd()
setwd("UCI HAR Dataset")


##open training files
subjectTrain<-read.table("./train/subject_train.txt")
xTrain<-read.table("./train/X_train.txt")
yTrain<-read.table("./train/y_train.txt")

##open test files
subjectTest<-read.table("./test/subject_test.txt")
xTest<-read.table("./test/X_test.txt")
yTest<-read.table("./test/y_test.txt")

##open supporting files
activityLabels<-read.table("activity_labels.txt")
features<-read.table("features.txt")

##add columns
colnames(activityLabels)=c('activityId','activityType')
colnames(subjectTrain)= 'subjectId'
colnames(yTrain)= 'activityId'
colnames(xTrain)= features$V2

colnames(subjectTest)= 'subjectId'
colnames(yTest)= 'activityId'
colnames(xTest)= features$V2

##head(activityLabels)
##head(xTrain)

##combine data
testData<-cbind(subjectTest, yTest, xTest )
trainData<-cbind(subjectTrain, yTrain, xTrain )

##stage 1, merged training set
trainTestData<-rbind(testData,trainData)

##reduce columns
keepCols<-grep("subjectId|activityId|*mean*|*std*",colnames(trainTestData))
##stage 2. sunset to mean and std only
keepData<-trainTestData[,c(keepCols)]

##stage 3 merge activity name
mergeDataActivity= merge(keepData, activityLabels, by.x="activityId",by.y = "activityId", all=TRUE)

##head(mergeDataActivity)
##stage 4  
## Across all columns, make columns readable
names(mergeDataActivity) <- gsub("-mean*()", " Mean ", names(mergeDataActivity))
names(mergeDataActivity) <- gsub("-std()", " Std Dev ", names(mergeDataActivity))
names(mergeDataActivity) <- gsub("tBody", "Time Body ", names(mergeDataActivity))
names(mergeDataActivity) <- gsub("tGravity", "Time Gravity ", names(mergeDataActivity))
names(mergeDataActivity) <- gsub("fBodyBody", "Freq Body ", names(mergeDataActivity))
names(mergeDataActivity) <- gsub("fBody", "Freq Body ", names(mergeDataActivity))
names(mergeDataActivity) <- gsub("fGravity", "Freq Gravity ", names(mergeDataActivity))
names(mergeDataActivity) <- gsub("\\()", "", names(mergeDataActivity))
names(mergeDataActivity) <- gsub("activityType", "Activity", names(mergeDataActivity))
names(mergeDataActivity) <- gsub("subjectId", "Subject", names(mergeDataActivity))


##colnames(mergeDataActivity)
##stage 5 average value
keepColsActivity<-grep("*Mean*|*Std Dev*",colnames(mergeDataActivity))
activityAll<-melt(mergeDataActivity,id=c("Activity", "Subject"), measure.vars = keepColsActivity)## !c("Activity Type", "Subject Id", "Activity Id")))

activityAverage<-dcast(activityAll,Activity+Subject ~variable,mean)
write.table(activityAverage, "activityAverage.txt", row.names = FALSE)