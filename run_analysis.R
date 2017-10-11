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
Xdata<- bind_rows(Xtest,Xtrain)
Ydata<- bind_rows(Ytest, Ytrain)
Subdata<- bind_rows(testsub,trainsub)


##Extracts only the measurements on the mean and standard deviation for each measurement
## read in features and activities labels
features<- read.table("UCI HAR Dataset/features.txt")
mean.sd <- grep("mean\\(\\)|std\\(\\)", features[, 2])
x.mean.sd <- Xdata[mean.sd]

# Uses descriptive activity names to name the activities in the data set
names(x.mean.sd) <- features[mean.sd, 2]
names(x.mean.sd) <- tolower(names(x.mean.sd)) 
names(x.mean.sd) <- gsub("\\(|\\)", "", names(x.mean.sd))

act<- read.table("UCI HAR Dataset/activity_labels.txt")
act[, 2] <- tolower(as.character(act[, 2]))
act[, 2] <- gsub("_", "", act[, 2])
Ydata[, 1]<- act[Ydata[, 1], 2]


# Appropriately labels the data set with descriptive activity names.
names<- features[mean.sd,2]
names(x.mean.sd)<-names
colnames(Ydata) <- 'activity'
colnames(Subdata) <- 'subjectid'


data <- bind_cols(Subdata, Ydata, x.mean.sd)
str(data)
write.table(data, './week4/merged.txt', row.names = F)

# Creates a second, independent tidy data set with the average of each variable for each 
#activity and each subject. 
data2<- data.table(data)
tidydata <- data2[,lapply(.SD,mean), by = 'subjectid,activity']
str(tidydata)
write.table(tidydata, './week4/tidy.txt', row.names = F)
