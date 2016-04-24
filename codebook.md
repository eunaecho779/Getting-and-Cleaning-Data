# Process
The script run_analysis.R performs these 5 process.

1. Merges the training and the test sets to create one data set.
  : used rbind() function
2. Extracts only the measurements on the mean and standard deviation for each measurement.
  : used grep() function
3. Uses descriptive activity names to name the activities in the data set
  : the activity names and IDs were taken from activity_labels.txt, and changed them into character using as.character() function.
4. Appropriately labels the data set with descriptive variable names.
  : renamed them using gsub() function
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  : created a tidy data set using write.data() function

# Variables
