# libraries used for this assignment
library(data.table)
library(dplyr)

# Reading supporting metadata from the working directory
featureNames <- read.table("./data/features.txt")
activityLabels <- read.table("./data/activity_labels.txt", header = FALSE)

## formating training and test data sets
# reading training data
subjectTrain <- read.table("./data/subject_train.txt", header = FALSE)
activityTrain <- read.table("./data/y_train.txt", header = FALSE)
featuresTrain <- read.table("./data/X_train.txt", header = FALSE)

# reading test data
subjectTest <- read.table("./data/subject_test.txt", header = FALSE)
activityTest <- read.table("./data/y_test.txt", header = FALSE)
featuresTest <- read.table("./data/X_test.txt", header = FALSE)

# merging the training data and the test data set using rbind function
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

# naming columns
colnames(features) <-t(featureNames[2])

# merging the data
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

## extracts only the measurements on the mean and standard deviation for each measurement

#extract the column indiices that have either mean or std in them
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

#add activity and subject columns to the list and look at the dimension of completeData
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)

#create extractedData with the selected columns in requiredColumns
extractedData <- completeData[,requiredColumns]
dim(extractedData)


## Uses descriptive activity names to name the activities in the data set
# changing the type of activity to character so that it can accept activity names.
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
 extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}
extractedData$Activity <- as.factor(extractedData$Activity)

## the names of the variables in extractedData
names(extractedData)

#examining extractedData, the following acronyms can be replaced:
# Acc - Accelerometer
# Gyro- Gyroscope
# BodyBody - Body
# Mag- Magnitude
# Character f - Frequency
# Character t - Time
names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))

# the names of the variables in extractedData after editing
names(extractedData)


##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

# create tidyData as a data set with average for each activity and subject.
# Then we order the entiles in tidyData and write it into data file Tidy.txt that contains the processed data
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
