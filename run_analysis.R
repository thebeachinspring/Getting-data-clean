## assume that zip file is downloaded and saved under work directory
## set up packages
library(plyr)
library(data.table)
## unzip the file
unzip("getdata%2Fprojectfiles%2FUCI HAR Dataset.zip")
## read in test data
Xtest<- read.table("UCI HAR Dataset/test/X_test.txt")
Ytest<- read.table("UCI HAR Dataset/test/Y_test.txt")
testsub<- read.table("UCI HAR Dataset/test/subject_test.txt")
## read in train data
Xtrain<- read.table("UCI HAR Dataset/train/X_train.txt")
Ytrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsub <-read.table("UCI HAR Dataset/train/subject_train.txt")
## merge datasets
Xdata<- rbind(Xtest,Xtrain)
Ydata<- rbind(Ytest, Ytrain)
Subdata<- rbind(testsub,trainsub)


##Extracts only the measurements on the mean and standard deviation for each measurement
## read in features and activities labels
features<- read.table("UCI HAR Dataset/features.txt")
act<- read.table("UCI HAR Dataset/activity_labels.txt")
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x.mean.sd <- x[, mean.sd]
