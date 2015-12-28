if(!file.exists("./data")){dir.create("./data")}

filename <- "Dataset.zip"
wtmpfile <- "data/Dataset.zip"

# Download, and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

# Read the Subject files
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)

# Read Features files
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

# 1.Concatenate the data tables by rows
# 1. Merges the training and the test sets to create one data set.

dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

names(dataSubjectTest)<-c("subject")
names(dataActivityTest)<- c("activity")
names(dataFeaturesTest)<- dataFeaturesNames$V2
TestData <- cbind(dataSubjectTest,dataActivityTest,dataFeaturesTest)
head(TestData)

names(dataSubjectTrain)<-c("subject")
names(dataActivityTrain)<- c("activity")
names(dataFeaturesTrain)<- dataFeaturesNames$V2
TrainData <- cbind(dataSubjectTrain,dataActivityTrain,dataFeaturesTrain)
head(TrainData)

data_All <- rbind(TestData, TrainData)

write.table(data_All, file = "tidy_data.txt",row.name=FALSE)

#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
data_All8<-subset(data_All,select=selectedNames)

write.table(data_All8, file = "tidy_data_filter.txt",row.name=FALSE)

#3. Uses descriptive activity names to name the activities in the data set
All_dataActivity <- rbind(dataActivityTest, dataActivityTrain)
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
activityLabels[, 2] <- tolower(gsub("_", " ", activityLabels[, 2]))

substr(activityLabels[2, 2], 8, 8) <- toupper(substr(activityLabels[2, 2], 8, 8))
substr(activityLabels[3, 2], 8, 8) <- toupper(substr(activityLabels[3, 2], 8, 8))

activityLabel <- activityLabels[All_dataActivity[, 1], 2]
All_dataActivity[, 1] <- activityLabel
names(All_dataActivity) <- "activity"

#4. Appropriately labels the data set with descriptive variable names. 
All_Subject <- rbind(dataSubjectTest, dataSubjectTrain)
All_dataFeatures <- rbind(dataFeaturesTest, dataFeaturesTrain)

names(All_Subject) <- "subject"
cleanedData <- cbind(All_Subject, All_dataActivity, All_dataFeatures)
write.table(cleanedData, "Mergeddata.txt") # write out the 1st dataset

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
subjectLen <- length(table(All_Subject)) 
activityLen <- dim(All_dataActivity)[1] 
columnLen <- dim(cleanedData)[2]

result <- matrix(NA, nrow=subjectLen*activityLen, ncol=columnLen) 
result <- as.data.frame(result)
colnames(result) <- colnames(cleanedData)
row <- 1
for(i in 1:subjectLen) {
  for(j in 1:activityLen) {
    result[row, 1] <- sort(unique(All_Subject)[, 1])[i]
    result[row, 2] <- activityLabels[j, 2]
    bool1 <- i == cleanedData$subject
    bool2 <- activityLabels[j, 2] == cleanedData$activity
    result[row, 3:columnLen] <- colMeans(cleanedData[bool1&bool2, 3:columnLen])
    row <- row + 1
    row
  }
}

write.table(result, "tidydata2.txt") # write out the 2nd dataset

