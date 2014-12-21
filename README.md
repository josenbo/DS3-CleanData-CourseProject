# Read Me 
(Data Science - Getting and Cleaning Data - Course Project)

The [Human Activity Recognition Using Smartphones Dataset (UCI HAR Dataset)](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "UCI HAR Dataset") [1] is cleaned up and rearranged as required in the [course project assigments](https://class.coursera.org/getdata-008/human_grading "Data Science - Getting and Cleaning Data - Course Project"). The advice given by the community teaching assistants has been taken into account, most notably [David's project FAQ](http://https://class.coursera.org/getdata-008/forum/thread?thread_id=24 "David's project FAQ"). 

## Insights and assumptions about the input data set

The UCI HAR Dataset Readme clarifies the setup of the underlying experiment. It states:
> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.
>   
> ...
> 
> The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The smartphone's girometer and accelerometer readings were sampled during the activity and further processed. The resulting 561 values, called features, were recorded for each sample.

### Peeking into the data

volunteer group | subject identification | activity identification | feature values
---|---|---|--- 
test | subject_test.txt <br><br> 2,947 observations of 1 variable | y_test.txt <br><br> 2,947 observations of 1 variable | X_test.txt <br><br> 2,947 observations of 561 variables
training | subject_train.txt <br><br> 7,352 observations of 1 variable | y_train.txt <br><br> 7,352 observations of 1 variable | X_train.txt <br><br> 7,352 observations of 561 variables

Each of the test and training group has three files capturing the results
* subject_*.txt : identifies the volunteer performing the activity
* y_*,txt : identifies the activity being observed
* X_*.txt : records the features sampled while the volunteer performed the activity

The strucure of these three file types is identical for both the test and the training group. It is part of the assignment to merge these file types. The distinction between test and training group is not needed in downstream analysis. So there is no need to introduce an additional variable capturing this information. 

For the volunteers in the subject_-files there is no information beyond the subject's id. 

The activities in the y-files are given as integers in the range 1:6. The corresponding activity names are listed in the file activity_labels.txt.

The sampled feature values are recorded in X-files (no pun intended) as lines of space delimited values without a header line. Descriptive names for the 561 columns are listed in the file features.txt.

The files in the **Inertial Signals**-subfolder can be ignored for this assignment, because only mean and standard deviation values will be used in downstream analysis. Check [David's project FAQ](http://https://class.coursera.org/getdata-008/forum/thread?thread_id=24 "David's project FAQ")  for more information on the choices for handling inertial signals data.        

## Prerequisites
The processing is accomplished by executing the R-script **run_analysis.R.**. It will read input files, transfrom data and produce the required output.
You will have to make sure R's working directory is pointed to the directory where that file resides. The following input files from the Human Activity Recognition Using Smartphones Dataset are expected to be in that same directory:

* subject_test.txt
* X_test.txt
* y_test.txt
* subject_train.txt
* X_train.txt
* y_train.txt 
* activity_labels.txt
* features.txt

In order to produce output files, this directory has to be writable. The script **run_analysis.R.** does not require any arguments but the following packages have to be installed:

* [dplyr](http://cran.r-project.org/web/packages/dplyr/index.html "dplyr - A fast, consistent tool for working with data frame like objects, both in memory and out of memory.") (version 0.3.0.2 used)
* [tidyr](http://cran.r-project.org/web/packages/tidyr/index.html "tidyr - Easily tidy data with spread and gather functions") (version 0.1 used)
 

## Processing

In a first step the three data set types will be merged for the test and training group   
 
subject identification | activity identification | feature values
---|---|--- 
subject_test.txt + subject_train.txt<br><br>10,299 observations of 1 variable | y_test.txt + y_train.txt<br><br>10,299 observations of 1 variable | X_test.txt + X_train.txt<br><br>10,299 observations of 561 variables

The next step is adding descriptive variable names for each of the three data sets. The single variable in the subject identification dataset will be labeled "subject". For the activity identification dataset the single variable will be named "activity". Names for the 561 features in the feature values dataset are taken from the features.txt. Feature labels are lowercased before being assigned as variable names, following the guidance in [Week 4 Lesson "Editing Text Variables"](https://class.coursera.org/getdata-008/lecture/43 "Getting and Cleaning Data - Week 4 - Lesson 1 - Editing Text Variables"). 

For the activity variable in the activity identification dataset, the numerial value is replaced with the descriptive activity names listed in activity_labels.txt.   

From the feature value dataset only the variables containing mean and standard deviation are extracted. The descriptive variable names assigned from features.txt are used to filter the corresponding columns. It appears that mena values contain the text "mean()", like in "fbodyacc-mean()-z". Equally, for standard deviation variables the text "std()" should appear in the variable name (e.g. "tbodygyrojerk-std()-x"). There are 66 variable names satisfying the selection criteria for mean and standard deviation.

The three data sets will then be horizontally joined to form a consolidated data set comprising subject, activity, mean values and standard deviation values.

consolidated mean and standard deviation dataset |
---|
subject_*.txt + y_*.txt + X_*.txt<br><br>10,299 observations of 68 variables (1 subject + 1 activity + 66 features)|
 
In a final step a second, independent tidy data set will be created with the average of each variable for each activity and each subject. The data set is saved as a text file for uploading into the course project assignment form.

As outlined in this [discussion forum thread](https://class.coursera.org/getdata-008/forum/thread?thread_id=239 "Test case(s) to validate the project"), we should be expecting 180 observations for 30 subjects performing 6 activities each. 

final grouped dataset |
---|
consolidated mean and standard deviation dataset grouped by subject and activity<br><br>180 observations of 68 variables (1 subject + 1 activity + 66 features)|

## Results

The file **result.txt** contains the dataset derived from the Human Activity Recognition Using Smartphones Dataset by excuting the R script **run_analysis.R.**.

The file **CodeBook.md** is a manually edited markdown document describing original and derived data in **result.txt** along with units and any other relevant information.


----------
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
