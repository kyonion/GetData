#Getting and Cleaning Data Course Project

##Tidy data set
Run the following code to load the tidy data set (instructions modified from "Tidy data and the Assignment" thread on course Discussion Forums (https://class.coursera.org/getdata-013/forum/thread?thread_id=31)):

address <- "https://s3.amazonaws.com/coursera-uploads/user-8eceb435220f3611f3051bcc/973500/asst-3/d270b710ec1811e4b004873bcd76f1bc.txt"

address <- sub("^https", "http", address)

data <- read.table(url(address), header = TRUE, stringsAsFactors= FALSE)

View(data)

A description of the 68 variables of the tidy data set can be found in the accompanying code book (https://github.com/kyonion/GetData/blob/master/CodeBook.md).

##Code to arrive at tidy data set
Run code contained in run_analysis.R (https://github.com/kyonion/GetData/blob/master/run_analysis.R) to download and unzip original data into a "data" folder in the working directory, and create a tidy data set containing only the averages of the mean and standard deviation of each variable.

Of the original data only certain files containing test and training data are used:

*subject_test/train: integer numbers identifying test and training subjects

*X_test/train: normalised measurement values

*y_test/train: integer numbers signifying activity

Any data contained in the "Inertial Signals" folders are ignored as these files/values would be filtered in later analysis steps anyway (also see "David's personal course project FAQ" (https://class.coursera.org/getdata-013/forum/thread?thread_id=30) on course Discussion Forums).

From the "features" file, that is part of the original data, a character vector is created. It serves two purposes simultaneously:
1) Of the 561 original features only those with "mean()" or "std()" in their name are chosen (using "grep" function). As per the description in the "features info" file those are the variables containing the mean and standard deviation values of the signals.
2) Once filtered for the mean/standard deviation values the character vector is used to give unique and distinctive, and therefore descriptive, names to the remaining variables.

A dataframe linking the numbers of the activities with the activity names is created from the "activity_labels" file of the original data. This dataframe is then joined together with the test and training data sets, respectively, in order to label the activities.

In the final step, the trainig and test data sets are joined together into one compiled data set. Variables are selected, rearranged, and renamed. The data is then grouped by subjects and activities, and the average for each measured signal is calculated, creating the final tidy data set.

For the tidy data set a wide format (68 variables, 180 rows) was chosen, as the measurements are viewed as independent of each other, an thus are considered "discrete members of the set of observations" (see "Tidy data and the Assignment" (https://class.coursera.org/getdata-013/forum/thread?thread_id=31) and "David's personal course project FAQ" (https://class.coursera.org/getdata-013/forum/thread?thread_id=30) threads on course Discussion Forums).