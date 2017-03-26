This script creates a dataset with the average values for each mean and standard deviation variable from the UCI HAR dataset for each activity and subject

run_analysis.R needs to be run from inside the UCI HAR dataset folder
This script will first create a dataset with the test and training data joined together, and with columns added for subject and activity
It will also change the activity column to have more descriptive activity labels (as descibed in the file "activity_labels.txt"
It will then select only the data on mean and standard deviation of variables (any feature ending in "mean()" or "std()")
It will then rename each column to have more readable headings
This data set is called 'main_data' 

The script will then create anotehr data set 'final_data' 
final_data has a first column of variable name (just for the mean/std of variables)
then 6 columns for the different activity types and 30 for the differnt subjects
The values are the mean for each variable by the column heading (either type of activity or particular subject)
This data is then written to the file "final_data.txt" which will be saved within the UCI HAR dataset  folder
# gettingAndCleaningData
