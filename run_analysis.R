#read in the data points, subjects and activities for test and train
library(dplyr)
test_x<-read.table("test/X_test.txt")
test_y <- read.table("test/y_test.txt")
train_x<-read.table("train/X_train.txt")
train_y <- read.table("train/y_train.txt")
test_sub <- read.table("test/subject_test.txt")
train_sub <- read.table("train/subject_train.txt")

#join together the main data data 
x <- rbind(test_x, train_x)

#join together the activity data
y <- rbind(test_y, train_y)

#create a mapping of number to activity label
activity_map <- read.table("activity_labels.txt",stringsAsFactors = FALSE)
#update y to have activity labels
for(i in 1:nrow(activity_map))
  y<- replace(y,y==activity_map[i,1],activity_map[i,2])

#join together the subject data
sub <- rbind(test_sub,train_sub)

#join the columns together into one table
main_data <- cbind(x,y,sub)

#get the column headings
headings<- read.table("features.txt",stringsAsFactors = FALSE)
colnames(main_data)<- c(headings[,2],"activities", "subject")

#get rid of duplicated columns
main_data<- main_data[!duplicated(names(main_data))]

#select the subjects, activities and columns with mean or std in header (but not the angles)
#also don't want the meanfreq, so only select mean() and std() to just get the mean and std of each original measurement 

main_data<- select(main_data, contains("mean()"),contains("std()"),-contains("angle"),subject,activities)

##tidy up the column names:
##make mean/std more readable
colnames(main_data)<- gsub("-mean\\(\\)[-]?", " Mean ",colnames(main_data))
colnames(main_data)<- gsub("-std\\(\\)[-]?", " Standard Deviation ",colnames(main_data))

#swap t for (time) and f for (fft) to show the difference clearly
colnames(main_data)<- gsub("^t", "\\(time\\) ",colnames(main_data))
colnames(main_data)<- gsub("^f", "\\(fft\\) ",colnames(main_data))

#aggregate by mean of activities
a <- aggregate(.~activities,main_data[,which(names(main_data)!="subject")],mean) 

#aggregate by mean of subject
b <- aggregate(.~subject,main_data[,which(names(main_data)!="activities")],mean) 

#transpose to get by columns of activties/subjects (these are now the variables, each mean is an observation)
ta<-t(a)
tb<-t(b)

#set the column names to the activity or the subject
colnames(tb)<-tb[1,]
tb<-tb[-1,]

colnames(ta)<-ta[1,]
ta<-ta[-1,]

#join the two tables together to get rows of variables names, by activity/subject mean
final_data <- cbind(rownames(ta),ta,tb)
colnames(final_data)[1]<-"variables"
#write to a text file
write.table(final_data,file="final_data.txt",row.names = FALSE)