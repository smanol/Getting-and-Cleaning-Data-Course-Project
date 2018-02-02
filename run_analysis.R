#Download and Unzip dataset

if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "./data/Data.zip")
unzip(zipfile = "./data/Data.zip",exdir="./data")

#Merge the training and the test sets to create master data set

#Read files
xTrain<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
yTrain<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjectTrain<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
xTest<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
yTest<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjectTest<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features<- read.table('./data/UCI HAR Dataset/features.txt')
activityLabels<-read.table("./data/UCI HAR Dataset/activity_labels.txt")

#Assign column names

colnames(xTrain)<- features[,2]
colnames(yTrain)<- "activityId"
colnames(subjectTrain)<-"subjectId"

colnames(xTest)<- features[,2]
colnames(yTest)<- "activityId"
colnames(subjectTest)<-"subjectId"
colnames(activityLabels)<-c("activityId","activityType")

#Merge Data in one set
mergedTrain <- cbind(yTrain, subjectTrain, xTrain)
mergedTest<- cbind(yTest, subjectTest, xTest)
masterSet <- rbind(mergedTrain, mergedTest)

#Extract Mean & Standar Deviation 
columnNames <- colnames(masterSet)
meanNstd <- (grepl("activityId" , columnNames) | 
                   grepl("subjectId" , columnNames) | 
                   grepl("mean.." , columnNames) | 
                   grepl("std.." , columnNames) 
)

setMeanNstd<- masterSet[ , meanNstd == TRUE]

#Use descriptive activity names 

setActivityNames <- merge(setMeanNstd, activityLabels,
                              by='activityId',
                              all.x=TRUE)



#Create indipendent tidy data set with average
IndySet <- aggregate(. ~subjectId + activityId, setActivityNames, mean)
IndySet <- IndySet[order(IndySet$subjectId, IndySet$activityId),]
write.table(IndySet, "IndySet.txt", row.name=FALSE)
