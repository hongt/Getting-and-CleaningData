This file describes the variables and any processing work completed to do the data cleaning.

The site where data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The data project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The run_analysis.R script performs the following steps to clean the data:
Read X_train.txt, y_train.txt and subject_train.txt from the "data/train" folder and store in dataActivityTrain, dataFeaturesTrain and dataSubjectTrain variables respectively.
Read X_test.txt, y_test.txt and subject_test.txt from the "data/test" folder and store in dataActivityTest, dataFeaturesTest and dataSubjectTest variables respectively.
Concatenate dataActivityTest to dataActivityTrain to generate joined_Data; 
Concatenate dataFeaturesTest to dataFeaturesTrain to generate joined_Label;  
concatenate dataSubjectTest to dataSubjectTrain to generate joined_Subject.
Read the features.txt file from the "data" folder and store the data in a variable called dataFeaturesNames. The measurements on the mean and standard deviation are retrieved. 
Clean the column names of the subset. Remove the "()" and "-" symbols in the names, as well as make the first letter of "mean" and "std" a capital letter "M" and "S" respectively.
Read the activity_labels.txt file from the  data folder and store the data in a variable called activityLabel.
Extracts only the measurements on the mean and standard deviation for each measurement.
Combine the joined_Data, joined_Label and joined_Subject by column to get a new data frame, cleanedData.
Lastly generate a second independent tidy data set with the average of each measurement for each activity and each subject.
Write the cleanedData out to "merged_data.txt" file.
