### This script is will open the Human Activity Recognition Using Smartphones Data Set from UC Irvine
### the data can be downloaded at http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip

### For more information about the data please view http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### ************ Please ensure the the folder 'UCI HAR Dataset' is in your working directory ******************************

### The data has been separated into a training, and a testing set already. For the purpose of our analyis we would like to see the 
### full data as a single table.
### The column associated with the test subjects and the column of data with a code for the activity type are stored in th 'testsubjects' 
### and the 'ytest' files respectively.  The accelerometer data is stored in the xtest file.

testsubjects <- read.table('./UCI HAR Dataset/test/subject_test.txt') # Each file is read in separately
ytest <- read.table('./UCI HAR Dataset/test/y_test.txt')
xtest <- read.table('./UCI HAR Dataset/test/X_test.txt')

testfull <- cbind(testsubjects,ytest,xtest)                           # Then the three files are combined into one data frame.

### The training data is stored in a similar fashion.  So it is read in and combined in the same manner.

trainsubjects <- read.table('./UCI HAR Dataset/train/subject_train.txt')
ytrain <- read.table('./UCI HAR Dataset/train/y_train.txt')
xtrain <- read.table('./UCI HAR Dataset/train/X_train.txt')

trainfull <- cbind(trainsubjects,ytrain,xtrain)

allrecords <- rbind(trainfull,testfull)                 #The full data set is brought together as one for all 30 subjects in the study
                                                            
features <- read.table('./UCI HAR Dataset/features.txt', stringsAsFactors = FALSE)  # The column headings for the xtest and xtrain are
cols <- c("subject","activity")                                              # features file.  heading for the subject and the activity
cols = append(cols, features$V2)                                             # are added and appended to a list of the headings
colnames(allrecords) <- cols

meanstdcols <- grepl("mean()|std()",cols)        # the cols with the phrase mean() or std() are identified and stored in a new variable
meanstdcols[1:2] = TRUE                          # the subject and activity columns are not captured in the RegEx, so they are included

meanstddata <- allrecords[,meanstdcols == TRUE]  # The full data set is subset to only capture the cols that 
                                                 # contain means() and std)() in the col header

activitylabels <- read.table('./UCI HAR Dataset/activity_labels.txt')  # read in the activity labels so we can translate the activty
                                                                      # codes into text

meanstddata$activity <- activitylabels$V2[meanstddata$activity] ## this will convert the the activity code into the words

#Then remove all stray cahracters from the col names, change t to time and f to freq
cleancols <- gsub("^t","time.",colnames(meanstddata))
cleancols <- gsub("^f","freq.",cleancols)
cleancols <- gsub("-",".",cleancols)
cleancols <- gsub("\\(\\)","",cleancols)
colnames(meanstddata) <- cleancols

## The last thing to do is create the tidy summary table
activityMelt <- melt(meanstddata, id=c("subject","activity"))            # melt on subject and activity
summarytable <- dcast(activityMelt, subject + activity ~ variable, mean)  # then get the mean for each col by activity for each subject

rm(list=setdiff(ls(), c("summarytable","meanstddata", "allrecords")))  # at the very end a bit of housekeeping, remove all the 
                                                                      # intermediate variables and tables
