#setwd("/home/sidd/Documents/CS224s/Analysis");
#setwd("~/CS 224S/Final Project/Analysis");
setwd('~/Documents/workspace/sincerity/sincerity_detection')
library(e1071)
library(rpart)
library(ada)
library(LiblineaR)

NUM_NON_PREDICTORS = 24
PROS_COLS = 25:58

# Create the training data
dat <- read.table('Data/final_features.csv', sep = ';', header = TRUE, na.strings = c('NA', ' . ', ' .','. '))
#Create Features for Other Speaker
n_features = ncol(dat) - NUM_NON_PREDICTORS 
other_features = data.frame(matrix(rep(0, nrow(dat) * n_features), ncol = n_features))
for(i in 1:nrow(dat)){
  self = dat$selfid[i]
  other = dat$otherid[i]
  corres_row = which(dat$selfid == other & dat$otherid == self)
  if(length(corres_row) > 0){
    other_features[i,] = as.vector(dat[corres_row, ((NUM_NON_PREDICTORS  + 1):ncol(dat))])
  } else {
    other_features[i,] = rep(NA, n_features)
  }
}
names(other_features) <- paste("Other", names(dat)[(NUM_NON_PREDICTORS + 1):ncol(dat)], sep = '.')

#Everything
LAB_COLS = 8:21
SELF_PROS_COLS = 25:58
OTHER_PROS_COLS = 1:34 
SELF_LEX_COLS = 59:153
OTHER_LEX_COLS = 35:129
NUM_LABS = 14

# Create Data Frame for Prosodic Prediction
#tot_dat = cbind(dat[, LAB_COLS], dat[, SELF_PROS_COLS], dat[,SELF_LEX_COLS], other_features)
#Just self pros
#tot_dat = cbind(dat[, LAB_COLS], dat[, SELF_PROS_COLS])
#Just other pros
#tot_dat = cbind(dat[, LAB_COLS], other_features[, OTHER_PROS_COLS])
#Both people, but pros only
tot_dat = cbind(dat[, LAB_COLS], dat[, PROS_COLS], other_features[, OTHER_PROS_COLS])
#Just Self Lex Feats
#tot_dat = cbind(dat[, LAB_COLS], dat[, SELF_LEX_COLS])
#Just Other Lex Feats
#tot_dat = cbind(dat[, LAB_COLS], other_features[, OTHER_LEX_COLS])
#Both  Lex Feats
#tot_dat = cbind(dat[, LAB_COLS], dat[, SELF_LEX_COLS], other_features[, OTHER_LEX_COLS])

factors = tot_dat[, (NUM_LABS + 1):ncol(tot_dat)]

male_dat = tot_dat[dat$selfid < dat$otherid,]
female_dat = tot_dat[dat$otherid < dat$selfid,]

male_factors = factors[dat$selfid < dat$otherid,]
female_factors = factors[dat$otherid < dat$selfid,]

cur_dat = tot_dat
cur_factors = factors

keep_rows = complete.cases(cur_dat)
cur_dat = cur_dat[keep_rows,]
cur_factors= cur_factors[keep_rows,]

cur_factors = scale(cur_factors, center = TRUE, scale = TRUE)
cur_factors = (cur_factors[, complete.cases(t(as.matrix(cur_factors)))])

for (num in 1:10) {
col = 14 # This is the label we are trying to predict
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
get_names <- function(tree) {return (names(tree$variable.importance)[[1]])}
top_variables = Map(get_names, trees)
alphas = ada.mod$model$alpha
ada_vars = matrix(rep(0, length(top_variables) * 2), nrow = length(top_variables))
for (index in 1:length(top_variables)) {
  ada_vars[index, 1] = top_variables[[index]]
  ada_vars[index, 2] = alphas[[index]]
}
write.table(ada_vars, 'ada_vars.csv', sep = ',', append=TRUE)
}
