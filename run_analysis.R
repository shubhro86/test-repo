#The following R script does the following :
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

install.packages("data.table")
install.packages("reshape")
library(data.table)
library(reshape)

#Load features 

features <- read.table("./UCI HAR Dataset/features.txt")[,2];

#Extract mean and standard deviation features

extractFeatures <- grep("mean|std", features,value=T,ignore.case=T);

#Load Activity labels

activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2];

#Load test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt");
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt");
subject_Test <- read.table("./UCI HAR Dataset/test/subject_test.txt");

#Set Column names for X, Y and subject
names(X_test) = features;

Y_test[,2] = activityLabels[Y_test[,1]];
names(Y_test) = c("Activity_Id","Activity_Label");
names(subject_Test) = "Subject";

#Extract mean and std deviation features from X_test
X_test = X_test[,extractFeatures];


#Binds the columns together
data_test <- cbind(subject_Test,Y_test,X_test);

#Load train data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt");
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt");
subject_Train <- read.table("./UCI HAR Dataset/train/subject_train.txt");

#Set Column names for X, Y and subject
names(X_train) = features;

Y_train[,2] = activityLabels[Y_train[,1]];
names(Y_train) = c("Activity_Id","Activity_Label");
names(subject_Train) = "Subject";

#Extract mean and std deviation features from X_train
X_train = X_train[,extractFeatures];


#Binds the columns together
data_train <- cbind(subject_Train,Y_train,X_train);

#Merge test and train data sets together

data <- rbind(data_test,data_train);
dim(data)


#Reshape data for calculating means

id_labels   = c("Subject", "Activity_Id", "Activity_Label");
data_labels = setdiff(colnames(data), id_labels);
melt_data      = melt(data, id = id_labels, measure.vars = data_labels);

#Calculate means for each variable on Subject and Activity Label
tidyData <- cast(melt_data, Subject + Activity_Label~variable, mean)

write.table(tidyData, file = "./tidyData.txt")


