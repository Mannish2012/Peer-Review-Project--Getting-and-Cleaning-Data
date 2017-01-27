library(tidyr)
library(dplyr)



features <- read.csv("features.txt", sep = "", header = FALSE, stringsAsFactors = F)
#STRUCTURE:
#data.frame':	561 obs. of  2 variables
#$ V1: int  1 2 3 4 5 6 7 8 9 10 ...
#$ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X"

activity_labels <- read.csv("activity_labels.txt", sep = "", header = FALSE ) 
#STRUCTURE:
#data.frame':	6 obs. of  2 variables
#$ V1: int  1 2 3 4 5 6 7 8 9 10 ...
#$ V2: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1



#Reading and Merging test, train Sets

testSet <- read.csv("X_test.txt", sep = "", header = FALSE) 
#2947 by 561 matrix. Columns correspond to features matrix. Rows are obversations
#STRUCTURE:
#data.frame':	2947 obs. of  561 variables:
#$ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
#$ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...

trainSet <- read.csv("X_train.txt", sep = "", header = FALSE)
#STRUCTURE:
#'data.frame':7352 obs. of  561 variables:
#$ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
#$ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
#$ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
#$ V4  : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...

merged_training_test <- rbind(testSet,trainSet) #combination of testSet, trainSet
#STRUCTURE:
#'data.frame':	10299 obs. of  561 variables:
#$ V1  : num  0.257 0.286 0.275 0.27 0.275 ...
#$ V2  : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
#$ V3  : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
#$ V4  : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...


## Reading and Merging test, train Movement Sets



testMoves <- read.csv("y_test.txt", sep = "", header = FALSE) #2947 by 1 matrix. Columns 
#STRUCTURE:
#'data.frame':	2947 obs. of  1 variable:
#$ V1: int  5 5 5 5 5 5 5 5 5 5 ...

trainMoves <- read.csv("y_train.txt", sep = "", header = FALSE)
#STRUCTURE:
#'data.frame':	7352 obs. of  1 variable:
#$ V1: int  5 5 5 5 5 5 5 5 5 5 ...


merged_Movement <- rbind(testMoves, trainMoves)


## Reading and Merging Person ID Sets

testPerson <- read.csv("subject_test.txt", sep = "", header = FALSE)
#STRUCTURE:
#'data.frame':	2947 obs. of  1 variable:
#$ V1: int  2 2 2 2 2 2 2 2 2 2 ...

trainPerson <- read.csv("subject_train.txt", sep = "", header = FALSE)
#STRUCTURE:
#'data.frame':	7352 obs. of  1 variable:
#$ V1: int  1 1 1 1 1 1 1 1 1 1 ...

all_Persons <- rbind(testPerson, trainPerson)



labelled_Movements <- merge(merged_Movement, activity_labels)   
#STRUCTURE:
#'data.frame':	10299 obs. of  2 variables:
# $ V1: int  1 1 1 1 1 1 1 1 1 1 ...
#$ V2: Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...




locations = grep(pattern = "-mean|-std", x = features[,c(2)])   #1 by 79 Matrix of locations of required features:
#STRUCTURE:
#int [1:79] 1 2 3 4 5 6 41 42 43 44

req_features <- grep(pattern = "-mean|-std", x = features[,c(2)], value = T) #1 by 79 Matrix of required features
#STRUCTURE:
# chr [1:79] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y"....

a1 =  merged_training_test[locations]                #Creates a dataframe a1 that applies values of locations(1 by 79) to the 
#dataframe merged_training_test (10299 by 561) creating a (10299 by 79) dataframe
#STRUCTURE:
#'data.frame':	10299 obs. of  79 variables:
#$ tBodyAcc-mean()-X              : num  0.257 0.286 0.275 0.27 0.275 ...
#$ tBodyAcc-mean()-Y              : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
#$ tBodyAcc-mean()-Z              : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
#$ tBodyAcc-std()-X               : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...

b1 <- t(req_features)                           # Creates a chr dataframe b1 that stores the names of the required features and transforms it 
#STRUCTURE:
#chr [1, 1:79] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z"

names(a1) <- b1                                 # Assigns the names of b1 to a1

a2 <- bind_cols(all_Persons, a1)                    # Binds a1(required features) with all_Persons(set of all Persons) to get a2
#STRUCTURE:
#Classes 'tbl_df', 'tbl' and 'data.frame':	10299 obs. of  80 variables:
#$ V1                             : int  2 2 2 2 2 2 2 2 2 2 ...
#$ tBodyAcc-mean()-X              : num  0.257 0.286 0.275 0.27 0.275 ...
#$ tBodyAcc-mean()-Y              : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...

c2 <- bind_cols(labelled_Movements[2], a2)       # binds a2 with activity description to create complete dataset c2. 
#STRUCTURE:
#Classes 'tbl_df', 'tbl' and 'data.frame':	10299 obs. of  81 variables:
#$ Activity                       : Factor w/ 6 levels "LAYING","SITTING",..: 4 4 4 4 4 4 4 4 4 4 ...
#$ Person_Number                  : int  2 2 2 2 2 2 2 2 2 2 ...
#$ tBodyAcc-mean()-X              : num  0.257 0.286 0.275 0.27 0.275 ...
#$ tBodyAcc-mean()-Y              : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...

names(c2)[1] = "Activity"
names(c2)[2] = "Person_Number"


#Extractng the Means of all the variables for all Persons and all Activities
summ1 <- summarise_each(group_by(c2, Activity, Person_Number ), funs(mean)) 
ordered_summ1 <- summ1[order(summ1$Person_Number),] 



#OUTPUT

write.table(summ1[order(summ1$Person_Number),] , row.names = TRUE, col.names = TRUE)



