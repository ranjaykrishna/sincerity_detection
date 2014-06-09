NUM_NON_PREDICTORS = 24
PROS_COLS = 25:58

setwd("/home/sidd/Documents/CS224s/Analysis/Data");
#setwd("~/CS 224S/Final Project/Analysis");
#setwd('~/Documents/workspace/sincerity/sincerity_detection')
dat <- read.table('final_features.csv', sep = ';', header = TRUE, na.strings = c('NA', ' . ', ' .','. '))
#dat <- dat[, c(437, 1:436, 438:ncol(dat))] #Reorder so maleBool near beginning
#dat$maleBool = as.numeric(dat$maleBool) #Get numeric malebool

#Sparse PCA
if(FALSE){
  library(elasticnet)
  male_dat <- dat[dat$maleBool == 1,]
  tot_pros <- male_dat[, 27:218]
  tot_pros <- tot_pros[complete.cases(tot_pros),]
  tot_pros <- scale(tot_pros, scale = TRUE, center = TRUE)
  tot_pros <- tot_pros[, complete.cases(t(as.matrix(tot_pros)))]
  sp.pca <- spca(tot_pros, K = 10, type = 'predictor',  para = rep(20, 10), sparse = 'varnum')
  sp.pca.loads = sp.pca$loadings  
}

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

#Get prosodic features of male speakers to determine factor analysis for males
male_dat <-  dat[dat$selfid < dat$otherid, ]
female_dat <- dat[dat$otherid > dat$selfid, ]

#Get Prosodic Factors for Males
#male_pros <- male_dat[, c(195, 196, 200, 204, (440:471))]  
male_pros <- male_dat[,PROS_COLS]
j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD', 'voiceProb_sma_min', 'voiceProb_sma_amean', 'voiceProb_sma_max', 'voiceProb_sma_stddev')
male_pros <- male_pros[, which(colnames(male_pros) %in% j_columns)]

fa_data = male_pros[complete.cases(male_pros),]
fa_data = scale(fa_data, center = TRUE, scale = TRUE)

library(nFactors)
ev <- eigen(cor(fa_data))
ap <- parallel(subject=nrow(fa_data),var=ncol(fa_data),rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS, main = '') 

fit <- factanal(fa_data, 5, rotation = 'varimax')
l_male <- fit$loadings
colnames(l_male) = c('Intensity', 'Pitch.Max', 'Pitch.Min', 'Turn.Duration', 'Intensity.Var')
colnames(l_male) = paste('Male', colnames(l_male), sep = '.')
write.table(l_male, 'FactAnal/maleLoadingsMatrix.csv', sep = ';', col.names = TRUE, row.names = TRUE)

fa_vals_male = as.matrix(fa_data) %*% l_male


#Get prosodic factors for Females fem_dat <- dat[dat$maleBool == 0,]
fem_dat <- dat[dat$selfid > dat$otherid,]
fem_pros <- fem_dat[,PROS_COLS]  
j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD', 'voiceProb_sma_min', 'voiceProb_sma_amean', 'voiceProb_sma_max', 'voiceProb_sma_stddev')
fem_pros <- fem_pros[, which(colnames(fem_pros) %in% j_columns)]

fa_data = fem_pros[complete.cases(fem_pros),]
fa_data = scale(fa_data, center = TRUE, scale = TRUE)
#write.table(fa_data, 'fem_fa_data.csv', col.names = TRUE, row.names = FALSE, sep = ';')

library(nFactors)
ev <- eigen(cor(fa_data))
ap <- parallel(subject=nrow(fa_data),var=ncol(fa_data),rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS, main = "") 

fit <- factanal(fa_data, 5, rotation = 'varimax')
l_fem <- fit$loadings
colnames(l_fem) = c("PitchMax", "Intensity.Var", "Turn Duration", 'Pitch Min', 'Intensity')
colnames(l_fem) = paste('Fem', colnames(l_fem), sep = '.')
write.table(l_fem, 'FactAnal/femLoadingsMatrix.csv', sep = ';', col.names = TRUE, row.names = TRUE)

fa_vals_fem = fa_data %*% l_fem
#fem_lambda <- read.table('FactAnal/femLambda.txt', header = FALSE, sep = ',')
#rownames(fem_lambda) = colnames(fa_data)

#Get Factors for Pooled
pros <- dat[, (PROS_COLS)]
j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD', 'voiceProb_sma_min', 'voiceProb_sma_amean', 'voiceProb_sma_max', 'voiceProb_sma_stddev')
pros <- pros[, which(colnames(pros) %in% j_columns)]
fa_data = pros[complete.cases(pros),]
fa_data = scale(fa_data, center = TRUE, scale = TRUE)

library(nFactors)
ev <- eigen(cor(fa_data))
ap <- parallel(subject=nrow(fa_data),var=ncol(fa_data),rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)

fa_sol <- factanal(fa_data, factors=4)
l <- fa_sol$loadings
###########################################
# Lex Analysis
male_feats <- dat[dat$maleBool == 0, ]
lex_feats <- cbind(male_feats[,9:22], male_feats[, 411:439], male_feats[, 472:ncol(dat)])
#Removes True NAs -- actually missing data. 
lex_feats <- lex_feats[complete.cases(lex_feats), ] 
fa_data = scale(lex_feats, center = TRUE, scale = TRUE)
#Removes columns with any NAs in them.  But because of our previous complete.cases call, only columns with any NAs are all NA (these NAs do not represent missing data, but 0-variance columns.  NAs created by scaling with 0 variance)
fa_data = (fa_data[, complete.cases(t(as.matrix(fa_data)))])

##########################################################################################
# Create Data Frame for Prosodic Prediction
#tot_dat = cbind(dat$maleBool, dat[,9:22], dat[, 440:471], other_features[, 413:444])

# Create Data Frame for Lexical Prediction
#tot_dat = cbind(dat$maleBool, dat[,9:22], dat[, 411:439], dat[, 472:ncol(dat)], other_features[, 446:ncol(other_features)])

# Create Data Frame for Lexical & Prosodic Prediction

#Everything
LAB_COLS = 8:21
SELF_PROS_COLS = 25:58
OTHER_PROS_COLS = 1:34 
SELF_LEX_COLS = 59:153
OTHER_LEX_COLS = 35:129
NUM_LABS = 14

tot_dat = cbind(dat[, LAB_COLS], dat[, SELF_PROS_COLS], dat[,SELF_LEX_COLS], other_features)
#Just self pros
#tot_dat = cbind(dat[, LAB_COLS], dat[, SELF_PROS_COLS])
#Just other pros
#tot_dat = cbind(dat[, LAB_COLS], other_features[, OTHER_PROS_COLS])
#Both people, but pros only
#tot_dat = cbind(dat[, LAB_COLS], dat[, PROS_COLS], other_features[, OTHER_PROS_COLS])

#Testing Adaboost

#Just Self Lex Feats
#tot_dat = cbind(dat[, LAB_COLS], dat[, SELF_LEX_COLS])
#Just Other Lex Feats
#tot_dat = cbind(dat[, LAB_COLS], other_features[, OTHER_LEX_COLS])
#Both  Lex Feats
#tot_dat = cbind(dat[, LAB_COLS], dat[, SELF_LEX_COLS], other_features[, OTHER_LEX_COLS])

#factors = scale(factors, center = TRUE, scale = TRUE)
factors = tot_dat[, (NUM_LABS + 1):ncol(tot_dat)]

male_dat = tot_dat[dat$selfid < dat$otherid,]
female_dat = tot_dat[dat$otherid < dat$selfid,]

male_factors = factors[dat$selfid < dat$otherid,]
female_factors = factors[dat$otherid < dat$selfid,]

cur_dat = female_dat
cur_factors = female_factors

keep_rows = complete.cases(cur_dat)
cur_dat = cur_dat[keep_rows,]
cur_factors= cur_factors[keep_rows,]

cur_factors = scale(cur_factors, center = TRUE, scale = TRUE)
cur_factors = (cur_factors[, complete.cases(t(as.matrix(cur_factors)))])

#Dimensionality Reduction for Lex Features

#Factor Classifier
#First get male factor values
if(FALSE){
  j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD', 'voiceProb_sma_min', 'voiceProb_sma_amean', 'voiceProb_sma_max', 'voiceProb_sma_stddev')
  male_pros <- male_factors[, which(colnames(male_factors) %in% j_columns)]
  fa_pros <- scale(male_pros, scale = TRUE, center = TRUE)
  fa_vals_male = fa_pros %*% l_male
  
  
  other_j_columns = paste('Other', j_columns, sep = '.')
  other_pros <- male_factors[, which(colnames(male_factors) %in% other_j_columns)]
  other_fa_pros <- scale(other_pros, scale = TRUE, center = TRUE)
  fa_vals_other = fa_pros %*% l_fem
  
  cur_factors = cbind(fa_vals_male, fa_vals_other)
}


#Funniness and Awkwardness Only
#Get all Labels
library(e1071)
library(ada)
library(LiblineaR)
final_scores <- matrix(rep(0, 2 * 4), nrow = 2)
rownames(final_scores) <- c("Funny", "Courteous")
colnames(final_scores) <- c("SVM_RBF", "SVM_Linear", "AdaBoost", "LibliearR_with_L1")
label_cols = c(which(colnames(cur_dat) == 'o_funny'), which(colnames(cur_dat)  == 'o_crteos'))
for(col in 1:2){ #Iterate through output columns
  print(paste("Label: ", colnames(cur_dat)[label_cols[col]]))
  gt_sinc <- cur_dat[, label_cols[col]] #Get right col
  q_sinc <- quantile(gt_sinc, probs = seq(0, 1, 0.1))
  ones = which(gt_sinc >= q_sinc[10])#Top and Bottom Decile
  zeros = which(gt_sinc <= q_sinc[2])
  gt = rep(0, length(ones) + length(zeros)) #Ground Truth
  gt[1:length(ones)] = 1
  split_factors <- cur_factors[c(ones, zeros), ]
  #split  actors <- scale(split_factors, center = TRUE, scale = TRUE) #Center and scale to unit-variance
  outcome = as.factor(gt)
  scores = matrix(rep(0, 10 * 4), nrow = 10) #4 is number of methods
  for(iter in 1:10){ #Do 5-fold CV 10 times
    print(paste("Iteration: ", toString(iter)))
    k = 5
    reorder = sample(1:nrow(split_factors), nrow(split_factors))
    split_factors = split_factors[reorder,]
    outcome = outcome[reorder]
    n = nrow(split_factors)
    per_sample = as.integer(n/5)
    accs_ada <- rep(0, k)
    accs_svm_rbf <- rep(0, k)
    accs_svm_linear <- rep(0, k)
    accs_liblineaR <- rep(0, k)
    for(i in 1:k){      
      #print(paste(toString(i), '...'))
      sample_rows_start = (i - 1) * per_sample + 1  
      sample_rows_end = min(n, sample_rows_start + per_sample - 1)
      sample_rows = (sample_rows_start):(sample_rows_end)
      #sample_rows = sample(1:nrow(split_factors), nrow(split_factors)/k)
      predict_train = split_factors[-sample_rows,]
      predict_test = split_factors[sample_rows,]
      outcome_train = outcome[-sample_rows]
      outcome_test = outcome[sample_rows]
      
      #SVM with radial kernel
      svm.mod <- svm(predict_train, outcome_train, kernel = 'radial')
      test_pred <- predict(svm.mod, predict_test)
      accs_svm_rbf[i] = sum(test_pred == outcome_test)/length(outcome_test)
      
      #rf <- randomForest(predict_train, y = outcome_train, xtest = predict_test, ytest = outcome_test, ntree = 500, importance = TRUE)
      control <- rpart.control(cp = -1, maxdepth = 14,maxcompete = 1,xval = 0)
      ada.mod <- ada(predict_train, outcome_train, test.x = predict_test, test.y = outcome_test, control=control)
      accs_ada[i] = sum(predict(ada.mod, data.frame(predict_test)) == outcome_test)/length(outcome_test)
      
      svm.mod.lin <- svm(predict_train, outcome_train, kernel = 'linear')
      test_pred <- predict(svm.mod.lin, predict_test)
      accs_svm_linear[i] = sum(test_pred == outcome_test)/length(outcome_test)
      
      lin=LiblineaR(data=predict_train,labels=outcome_train,type=6,cost=heuristicC(predict_train),bias=TRUE,verbose=FALSE)
      test_pred <- predict(lin, predict_test)
      accs_liblineaR[i] = sum(as.integer(unlist(test_pred)) == outcome_test)/length(outcome_test)
    }
    scores[iter, 1] = mean(accs_svm_rbf)
    scores[iter, 2] = mean(accs_svm_linear)
    scores[iter, 3] = mean(accs_ada)
    scores[iter, 4] = mean(accs_liblineaR)
  }
  final_scores[col,] = apply(scores, 2, mean) #-1 is to make 1-index
}
write.table(final_scores, '../results/final_female_both_both.csv', sep = ';')


#Funny Only
library(e1071)
library(ada)
library(LiblineaR)
gt_funny <- cur_dat$o_funny
q_funny <- quantile(gt_funny, probs = seq(0, 1, 0.1)) 
ones = which(gt_funny >= q_funny[10])
zeros = which(gt_funny <= q_funny[2])
gt = rep(0, length(ones) + length(zeros)) #Ground Truth
gt[1:length(ones)] = 1
split_factors <- cur_factors[c(ones, zeros), ]
outcome = as.factor(gt)

#Test Full AdaBoost
control <- rpart.control(cp = -1, maxdepth = 1,maxcompete = 1,xval = 0)
ada.mod.full = ada(split_factors, gt, control = control)

scores = matrix(rep(0, 10 * 4), nrow = 10)
for(iter in 1:10){ #Do 5-fold CV 10 times
  print(paste("Iteration: ", toString(iter)))
  k = 5
  reorder = sample(1:nrow(split_factors), nrow(split_factors))
  split_factors = split_factors[reorder,]
  outcome = outcome[reorder]
  n = nrow(split_factors)
  per_sample = as.integer(n/5)
  accs_ada <- rep(0, k)
  accs_svm_rbf <- rep(0, k)
  accs_svm_linear <- rep(0, k)
  accs_liblineaR <- rep(0, k)
  for(i in 1:k){
    #print(paste(toString(i), '...'))
    sample_rows_start = (i - 1) * per_sample + 1  
    sample_rows_end = min(n, sample_rows_start + per_sample - 1)
    sample_rows = (sample_rows_start):(sample_rows_end)
    #sample_rows = sample(1:nrow(split_factors), nrow(split_factors)/k)
    predict_train = split_factors[-sample_rows,]
    predict_test = split_factors[sample_rows,]
    outcome_train = outcome[-sample_rows]
    outcome_test = outcome[sample_rows]
    
    #SVM with radial kernel
    svm.mod <- svm(predict_train, outcome_train, kernel = 'radial')
    test_pred <- predict(svm.mod, predict_test)
    accs_svm_rbf[i] = sum(test_pred == outcome_test)/length(outcome_test)
    
    #rf <- randomForest(predict_train, y = outcome_train, xtest = predict_test, ytest = outcome_test, ntree = 500, importance = TRUE)
    control <- rpart.control(cp = -1, maxdepth = 14,maxcompete = 1,xval = 0)
    ada.mod <- ada(predict_train, outcome_train, test.x = predict_test, test.y = outcome_test, control=control)
    accs_ada[i] = sum(predict(ada.mod, data.frame(predict_test)) == outcome_test)/length(outcome_test)
    
    svm.mod.lin <- svm(predict_train, outcome_train, kernel = 'linear')
    test_pred <- predict(svm.mod.lin, predict_test)
    accs_svm_linear[i] = sum(test_pred == outcome_test)/length(outcome_test)
    
    lin=LiblineaR(data=predict_train,labels=outcome_train,type=6,cost=heuristicC(predict_train),bias=TRUE,verbose=FALSE)
    test_pred <- predict(lin, predict_test)
    accs_liblineaR[i] = sum(as.integer(unlist(test_pred)) == outcome_test)/length(outcome_test)
  }
  scores[iter, 1] = mean(accs_svm_rbf)
  scores[iter, 2] = mean(accs_svm_linear)
  scores[iter, 3] = mean(accs_ada)
  scores[iter, 4] = mean(accs_liblineaR)
}
#Get all Labels
library(e1071)
library(ada)
library(LiblineaR)
final_scores <- matrix(rep(0, 14 * 4), nrow = 14)
rownames(final_scores) <- colnames(cur_dat)[2:15]
colnames(final_scores) <- c("SVM_RBF", "SVM_Linear", "AdaBoost", "LibliearR_with_L1") 
for(col in 2:15){ #Iterate through output columns
  print(paste("Label: ", colnames(cur_dat)[col]))
  gt_sinc <- cur_dat[, col] #Get right col
  q_sinc <- quantile(gt_sinc, probs = seq(0, 1, 0.1))
  ones = which(gt_sinc >= q_sinc[10])#Top and Bottom Decile
  zeros = which(gt_sinc <= q_sinc[2])
  gt = rep(0, length(ones) + length(zeros)) #Ground Truth
  gt[1:length(ones)] = 1
  split_factors <- cur_factors[c(ones, zeros), ]
  #split  actors <- scale(split_factors, center = TRUE, scale = TRUE) #Center and scale to unit-variance
  outcome = as.factor(gt)
  scores = matrix(rep(0, 10 * 4), nrow = 10) #4 is number of methods
  for(iter in 1:10){ #Do 5-fold CV 10 times
    print(paste("Iteration: ", toString(iter)))
    k = 5
    reorder = sample(1:nrow(split_factors), nrow(split_factors))
    split_factors = split_factors[reorder,]
    outcome = outcome[reorder]
    n = nrow(split_factors)
    per_sample = as.integer(n/5)
    accs_ada <- rep(0, k)
    accs_svm_rbf <- rep(0, k)
    accs_svm_linear <- rep(0, k)
    accs_liblineaR <- rep(0, k)
    for(i in 1:k){
      #print(paste(toString(i), '...'))
      sample_rows_start = (i - 1) * per_sample + 1  
      sample_rows_end = min(n, sample_rows_start + per_sample - 1)
      sample_rows = (sample_rows_start):(sample_rows_end)
      #sample_rows = sample(1:nrow(split_factors), nrow(split_factors)/k)
      predict_train = split_factors[-sample_rows,]
      predict_test = split_factors[sample_rows,]
      outcome_train = outcome[-sample_rows]
      outcome_test = outcome[sample_rows]
      
      #SVM with radial kernel
      svm.mod <- svm(predict_train, outcome_train, kernel = 'radial')
      test_pred <- predict(svm.mod, predict_test)
      accs_svm_rbf[i] = sum(test_pred == outcome_test)/length(outcome_test)
      
      #rf <- randomForest(predict_train, y = outcome_train, xtest = predict_test, ytest = outcome_test, ntree = 500, importance = TRUE)
      control <- rpart.control(cp = -1, maxdepth = 14,maxcompete = 1,xval = 0)
      ada.mod <- ada(predict_train, outcome_train, test.x = predict_test, test.y = outcome_test, control=control)
      accs_ada[i] = sum(predict(ada.mod, data.frame(predict_test)) == outcome_test)/length(outcome_test)
      
      svm.mod.lin <- svm(predict_train, outcome_train, kernel = 'linear')
      test_pred <- predict(svm.mod.lin, predict_test)
      accs_svm_linear[i] = sum(test_pred == outcome_test)/length(outcome_test)
      
      lin=LiblineaR(data=predict_train,labels=outcome_train,type=6,cost=heuristicC(predict_train),bias=TRUE,verbose=FALSE)
      test_pred <- predict(lin, predict_test)
      accs_liblineaR[i] = sum(as.integer(unlist(test_pred)) == outcome_test)/length(outcome_test)
    }
    scores[iter, 1] = mean(accs_svm_rbf)
    scores[iter, 2] = mean(accs_svm_linear)
    scores[iter, 3] = mean(accs_ada)
    scores[iter, 4] = mean(accs_liblineaR)
  }
  final_scores[col - 1,] = apply(scores, 2, mean) #-1 is to make 1-index
}
write.table(final_scores, 'results/male_self_lex.csv', sep = ';')


#Get Adaboost interpretation