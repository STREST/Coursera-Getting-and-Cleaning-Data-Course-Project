#READ IN DATA
#activity and feature info
activity_labels <- read.table("~/Coursera/week 8/UCI HAR Dataset/activity_labels.txt")
feature_names <- read.table("~/Coursera/week 8/UCI HAR Dataset/features.txt")

#train data
X_train <- read.table("~/Coursera/week 8/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("~/Coursera/week 8/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("~/Coursera/week 8/UCI HAR Dataset/train/subject_train.txt")

#test data
X_test <- read.table("~/Coursera/week 8/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("~/Coursera/week 8/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("~/Coursera/week 8/UCI HAR Dataset/test/subject_test.txt")

#merge data
X_total <- rbind(X_train, X_test) 
colnames(X_total) = feature_names[,2]
index_mean_or_std = grepl("mean()",feature_names[,2],fixed=TRUE) | grepl("std()",feature_names[,2],fixed=TRUE)
X_total_select = X_total[,index_mean_or_std]

y_total <- rbind(y_train, y_test) 
y_total = merge(y_total,activity_labels,by="V1")
colnames(y_total)[2] = "activity" 

subject_total = rbind(subject_train,subject_test)
colnames(subject_total) = "subject"

total = data.frame(subject_total,X_total_select,y_total$activity)
colnames(total)[68] = "activity"

#independent tidy data set with the average of each variable for each activity and each subject                 
aggregate_total=aggregate(total[,!(colnames(total) == c("subject","activity"))], list(total$subject,total$activity), mean)
colnames(aggregate_total)[1:2] = c("subject","activity") 

#make colnames readable and delete . and upper cases
colnames(aggregate_total) = tolower(colnames(aggregate_total))
colnames(aggregate_total)=gsub("[.]","",colnames(aggregate_total))

#write to txt file
write.table(aggregate_total,"aggregate_total.txt",row.name=FALSE)
