##load libraries needed in script
library(tidyr)
library(dplyr)

##create "data" folder in WD if it does not exist, download and unzip files in folder
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataset.zip")
unzip("./data/dataset.zip",exdir = "./data")

##select variables that contain measurements on the mean and standard deviation
features <- read.table("data/UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)[[2]]
selectedCols <- grep("mean[()]|std[()]",features)
features <- features[selectedCols]

##correct variable name
features <- gsub("BodyBody","Body",features)

##load test files and select columns that contain measurements on the mean and standard deviation
testFiles <- list.files("./data/UCI HAR Dataset/test", pattern="\\.txt",full.name=TRUE)
testData <- lapply(testFiles,read.table)
testData[[2]] <- testData[[2]][selectedCols]

##load training files and select columns that contain measurements on the mean and
##standard deviation
trainFiles <- list.files("./data/UCI HAR Dataset/train", pattern="\\.txt",full.name=TRUE)
trainData <- lapply(trainFiles,read.table)
trainData[[2]] <- trainData[[2]][selectedCols]

##prepare vectors for naming variables and labelling activities
colNames <- c("subject",features,"activity")
activityLabels <- read.table("data/UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)

##compile test and training files into two data sets, name variables, and label activities
compData <- list(bind_cols(testData),bind_cols(trainData))
colnames(compData[[1]]) <- colNames
colnames(compData[[2]]) <- colNames
compData <- lapply(compData,function(x) left_join(x,activityLabels,by=c("activity"="V1")))

##clean up Global Environment
rm(fileUrl,testFiles,testData,trainFiles,trainData,features,colNames,activityLabels,selectedCols)

##create one data set from test and trining sets, select and rearrange variables needed,
##name "activity" column, group by subject and activity,
##calculate average for each group/variable combination
data <- bind_rows(compData[[1]],compData[[2]]) %>% 
  select(subject,V2,2:67) %>% 
  rename(activity=V2) %>%
  group_by(subject,activity) %>%
  summarise_each(funs(mean))

##create file with tidy data set
write.table(data,"tidydataset.txt",row.name=FALSE)