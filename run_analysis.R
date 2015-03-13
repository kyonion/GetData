test_data <- read.table("getdata/UCI HAR Dataset/test/X_test.txt")
train_data <- read.table("getdata/UCI HAR Dataset/train/X_train.txt")
test_activity <- read.table("getdata/UCI HAR Dataset/test/y_test.txt")
train_activity <- read.table("getdata/UCI HAR Dataset/train/y_train.txt")
test_subject <- read.table("getdata/UCI HAR Dataset/test/subject_test.txt")
train_subject <- read.table("getdata/UCI HAR Dataset/train/subject_train.txt")
col_names <- make.names(read.table("getdata/UCI HAR Dataset/features.txt")[[2]],unique=TRUE)
activity_labels <- read.table("getdata/UCI HAR Dataset/activity_labels.txt")

test_activity <- left_join(test_activity,activity_labels,by="V1")
train_activity <- left_join(train_activity,activity_labels,by="V1")

colnames(test_data) <- col_names
colnames(train_data) <- col_names
colnames(test_subject) <- "subject"
colnames(train_subject) <- "subject"
colnames(test_activity)[2] <- "activity"
colnames(train_activity)[2] <- "activity"

test <- tbl_df(bind_cols(test_subject,test_activity,test_data))
train <- tbl_df(bind_cols(train_subject,train_activity,train_data))

data_comp <- bind_rows(test,train) %>% 
  select(subject,activity,contains(".mean."),contains(".std.")) %>%
  arrange(subject,activity)

##gather X,Y,Z values