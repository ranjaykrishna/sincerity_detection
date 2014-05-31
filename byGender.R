#setwd("/home/sidd/Documents/CS224s/Analysis");
#setwd("~/CS 224S/Final Project/Analysis");
setwd('~/Documents/workspace/sincerity/sincerity_detection')
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

#Get prosodic features of male speakers to determine factor analysis for males
male_dat <-  dat[dat$maleBool == 1, ]

#Get Prosodic Factors for Males
#male_pros <- male_dat[, c(195, 196, 200, 204, (440:471))]  
male_pros <- male_dat[,(440:471)]  
j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD', 'voiceProb_sma_min', 'voiceProb_sma_amean', 'voiceProb_sma_max', 'voiceProb_sma_stddev')
male_pros <- male_pros[, which(colnames(male_pros) %in% j_columns)]

fa_data = male_pros[complete.cases(male_pros),]
fa_data = scale(fa_data, center = TRUE, scale = TRUE)

library(nFactors)
ev <- eigen(cor(fa_data))
ap <- parallel(subject=nrow(fa_data),var=ncol(fa_data),rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)

fit <- factanal(fa_data, 5, rotation = 'varimax')
l <- fit$loadings
write.table(l, 'FactAnal/maleLoadingsMatrix.csv', sep = ';', col.names = TRUE, row.names = TRUE)

#Get prosodic factors for Females
fem_dat <- dat[dat$maleBool == 0,]
fem_pros <- fem_dat[,(440:471)]  
j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD', 'voiceProb_sma_min', 'voiceProb_sma_amean', 'voiceProb_sma_max', 'voiceProb_sma_stddev')
fem_pros <- fem_pros[, which(colnames(fem_pros) %in% j_columns)]

fa_data = fem_pros[complete.cases(fem_pros),]
fa_data = scale(fa_data, center = TRUE, scale = TRUE)
write.table(fa_data, 'fem_fa_data.csv', col.names = TRUE, row.names = FALSE, sep = ';')

library(nFactors)
ev <- eigen(cor(fa_data))
ap <- parallel(subject=nrow(fa_data),var=ncol(fa_data),rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)

fit <- factanal(fa_data, 5, rotation = 'varimax')
l <- fit$loadings
write.table(l, 'FactAnal/femLoadingsMatrix.csv', sep = ';', col.names = TRUE, row.names = TRUE)

#fem_lambda <- read.table('FactAnal/femLambda.txt', header = FALSE, sep = ',')
#rownames(fem_lambda) = colnames(fa_data)

#Get Factors for Pooled
pros <- dat[, (440:471)]
j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD', 'voiceProb_sma_min', 'voiceProb_sma_amean', 'voiceProb_sma_max', 'voiceProb_sma_stddev')
pros <- pros[, which(colnames(pros) %in% j_columns)]
fa_data = pros[complete.cases(pros),]
fa_data = scale(fa_data, center = TRUE, scale = TRUE)

library(nFactors)
ev <- eigen(cor(fa_data))
ap <- parallel(subject=nrow(fa_data),var=ncol(fa_data),rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)

###########################################
# Lex Analysis
male_feats <- dat[dat$maleBool == 0, ]
lex_feats <- cbind(male_feats[,9:22], male_feats[, 411:439], male_feats[, 472:ncol(dat)])
fa_data = scale(lex_feats, center = TRUE, scale = TRUE)
fa_data = (fa_data[, complete.cases(t(as.matrix(fa_data)))])

##########################################################################################
# Create Data Frame for Prosodic Prediction
#tot_dat = cbind(dat$maleBool, dat[,9:22], dat[, 440:471], other_features[, 413:444])

# Create Data Frame for Lexical Prediction
#tot_dat = cbind(dat$maleBool, dat[,9:22], dat[, 411:439], dat[, 472:ncol(dat)], other_features[, 446:ncol(other_features)])

# Create Data Frame for Lexical & Prosodic Prediction
tot_dat = cbind(dat$maleBool, dat[,9:22], dat[, 411:ncol(dat)], other_features[, 413:444], other_features[, 446:ncol(other_features)])

tot_dat <- tot_dat[complete.cases(tot_dat),]
factors = tot_dat[, 16:ncol(tot_dat)]
#factors = scale(factors, center = TRUE, scale = TRUE)

male_dat = tot_dat[tot_dat[, 1] == 1,]
female_dat = tot_dat[tot_dat[, 1] == 0,]

male_factors = factors[tot_dat[, 1] == 1,]
female_factors = factors[tot_dat[, 1] == 0,]

cur_dat = male_dat
cur_dat = scale(female_dat, center = TRUE, scale = TRUE)
cur_dat = (cur_dat[, complete.cases(t(as.matrix(cur_dat)))])
cur_factors = male_factors
cur_factors = scale(cur_factors, center = TRUE, scale = TRUE)
cur_factors = (cur_factors[, complete.cases(t(as.matrix(cur_factors)))])


library(e1071)
library(ada)
library(LiblineaR)
final_scores <- matrix(rep(0, 14 * 4), nrow = 14)
rownames(final_scores) <- colnames(cur_dat)[1:14]
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
write.table(final_scores, 'male_all_new_results.csv', sep = ';')

