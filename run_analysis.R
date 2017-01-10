#From the head folder of the unzipped file, I plunge in and begin loading datasets

setwd("UCI HAR Dataset")
features=read.table("features.txt")
activities = read.table("activity_labels.txt")
X.test = read.table("test/X_test.txt")
Y.test = read.table("test/Y_test.txt")
S.test = read.table("test/subject_test.txt")
X.train = read.table("train/X_train.txt")
Y.train = read.table("train/Y_train.txt")
S.train = read.table("train/subject_train.txt")


#Then I merge them
X = rbind(X.test, X.train)
Y = rbind(Y.test, Y.train)
S = rbind(S.test, S.train)

#Then I give them descriptive names
colnames(S) = "Subject"
colnames(Y)="Activity"
colnames(X) = features[,2]

#Then I replace all the numbers in the Activity column with descriptive names
all = cbind(S, Y, X)
all[,2] = as.factor(all[,2])
levels(all[,2]) = activities[,2]

#Then I find all the means and standard deviation columns. Going to use only those and also the Subject and Activity columns
meansandstds = sort(c(grep("mean()",features[,2], fixed = 1),grep("std()",features[,2], fixed = 1))) + 2
meansandstds = c(1,2,meansandstds)

#Then I sort by Subject and Activity and take the mean of my variables of interest for every subject-activity combination
all[,meansandstds] %>%
  group_by(Subject, Activity) %>%
  summarize_each(funs(mean)) -> final.data

#Write it to a text file, voila!
write.table(final.data, "final.data.txt", row.names = FALSE)
