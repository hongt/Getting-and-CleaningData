# Step1. Merges the training and the test sets to create one data set.

dataActivityTrain <- read.table("./data/train/X_train.txt")
dataFeaturesTrain <- read.table("./data/train/y_train.txt")
dataSubjectTrain <- read.table("./data/train/subject_train.txt")

dataActivityTest <- read.table("./data/test/X_test.txt")
dataFeaturesTest <- read.table("./data/test/y_test.txt") 
dataSubjectTest <- read.table("./data/test/subject_test.txt")

joined_Data <- rbind(dataActivityTrain, dataActivityTest)
joined_Label <- rbind(dataFeaturesTrain, dataFeaturesTest)
joined_Subject <- rbind(dataSubjectTrain, dataSubjectTest)


# Step2. Extracts only the measurements on the mean and standard 
# deviation for each measurement. 
features <- read.table("./data/features.txt")

meanStdInd <- grep("mean\\(\\)|std\\(\\)", features[, 2])

joined_Data <- joined_Data[, meanStdInd]

names(joined_Data) <- gsub("\\(\\)", "", features[meanStdInd, 2]) # remove "()"
names(joined_Data) <- gsub("mean", "Mean", names(joined_Data)) # capitalize M
names(joined_Data) <- gsub("std", "Std", names(joined_Data)) # capitalize S
names(joined_Data) <- gsub("-", "", names(joined_Data)) # remove "-" in column names 


# Step3. Uses descriptive activity names to name the activities in 
# the data set
activity <- read.table("./data/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", "", activity[, 2]))

substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8))
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8))

activityLabel <- activity[joined_Label[, 1], 2]

joined_Label[, 1] <- activityLabel
names(joined_Label) <- "activity"


# Step4. Appropriately labels the data set with descriptive activity 
# names. 
names(joined_Subject) <- "subject"
cleanedData <- cbind(joined_Subject, joined_Label, joined_Data)
write.table(cleanedData, "merged_data.txt") # write out the 1st dataset


# Step5. Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
subjectLen <- length(table(joined_Subject)) 
activityLen <- dim(activity)[1] 
columnLen <- dim(cleanedData)[2]

result <- matrix(NA, nrow=subjectLen*activityLen, ncol=columnLen) 
result <- as.data.frame(result)

colnames(result) <- colnames(cleanedData)
row <- 1
for(y in 1:subjectLen) {
  for(z in 1:activityLen) {
    result[row, 1] <- sort(unique(joined_Subject)[, 1])[y]
    result[row, 2] <- activity[z, 2]
    boolean1 <- y == cleanedData$subject
    cleanedData$subject
    boolean2 <- activity[j, 2] == cleanedData$activity
    result[row, 3:columnLen] <- colMeans(cleanedData[boolean1&boolean2, 3:columnLen])
    row <- row + 1
  }
}

# write out the second,independent tidy data set
write.table(result, "mean_data.txt") 
