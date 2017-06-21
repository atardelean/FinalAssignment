# Step 1: run_analysis.R 

- Sets current directory
- Read UCI HAR data into R and unzips the data
- Renames variables consistently across files
- Create a factor variable act_lab with descriptive activity names
- Merges the training and test sets to create one dataset
- Extracts only the measurements on the mean and standard deviations for each measurement 
- Rename data variables with descriptive names: replace t with time; f with frequency etc.
- write the dataset in the data.csv
- create a tidy dataset with the average of each variable for each activity and each subject. Write the dataset  in csv file.

