#setwd("/home/sidd/Documents/CS224s/Analysis");
#setwd("~/CS 224S/Final Project/Analysis");
setwd('~/Documents/workspace/sincerity/sincerity_detection')
library(e1071)
library(ada)
library(LiblineaR)

# Create the training data
dat <- read.table('all_new_features.csv', sep = ';', header = TRUE, na.strings = c('NA', ' . ', ' .','. '))
dat <- dat[, c(437, 1:436, 438:ncol(dat))] #Reorder so maleBool near beginning
dat$maleBool = as.numeric(dat$maleBool) #Get numeric malebool
#Create Features for Other Speaker
n_features = ncol(dat) - 26 #26 non-predictor features 
other_features = data.frame(matrix(rep(0, nrow(dat) * n_features), ncol = n_features))
for(i in 1:nrow(dat)){
  self = dat$selfid[i]
  other = dat$otherid[i]
  corres_row = which(dat$selfid == other & dat$otherid == self)
  if(length(corres_row) > 0){
    other_features[i,] = as.vector(dat[corres_row, (27:ncol(dat))])
  } else {
    other_features[i,] = rep(NA, n_features)
  }
}
names(other_features) <- paste("Other", names(dat)[27:ncol(dat)], sep = '.')

# Create Data Frame for Prosodic Prediction
tot_dat = cbind(dat$maleBool, dat[,9:22], dat[, 440:471], other_features[, 413:444])

tot_dat <- tot_dat[complete.cases(tot_dat),]
factors = tot_dat[, 16:ncol(tot_dat)]

male_dat = tot_dat[tot_dat[, 1] == 1,]
female_dat = tot_dat[tot_dat[, 1] == 0,]

male_factors = factors[tot_dat[, 1] == 1,]
female_factors = factors[tot_dat[, 1] == 0,]

cur_dat = female_dat
cur_factors = female_factors
cur_factors = scale(cur_factors, center = TRUE, scale = TRUE)
cur_factors = (cur_factors[, complete.cases(t(as.matrix(cur_factors)))])

col = 15 # This is the label we are trying to predict
print(paste("Label: ", colnames(cur_dat)[col]))
gt_sinc <- cur_dat[, col] #Get right col
q_sinc <- quantile(gt_sinc, probs = seq(0, 1, 0.1))
ones = which(gt_sinc >= q_sinc[10])#Top and Bottom Decile
zeros = which(gt_sinc <= q_sinc[2])
gt = rep(0, length(ones) + length(zeros)) #Ground Truth
gt[1:length(ones)] = 1
split_factors <- cur_factors[c(ones, zeros), ]
outcome = as.factor(gt)
control <- rpart.control(cp = -1, maxdepth = 1,maxcompete = 1,xval = 0)
ada.mod <- ada(split_factors, outcome, control=control)

trees = ada.mod$model$trees

