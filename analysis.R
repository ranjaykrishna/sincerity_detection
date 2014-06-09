#This R Script does the analysis part
setwd("/home/sidd/Documents/CS224s/Analysis");
library(randomForest)

dat <- read.table('ForAnalysis.csv', header = TRUE, sep = ';')
keep_indices <- complete.cases(dat)
dat = dat[keep_indices,] #Get rid of NAs


#Prosodic Features
pro <- dat[, c(194, 195, 199, 203, (440:471))]  
centered_pros <- scale(pro, scale = TRUE, center = TRUE) #Mean-centers data and makes unit variance
j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD', 'voiceProb_sma_min', 'voiceProb_sma_amean', 'voiceProb_sma_max', 'voiceProb_sma_stddev')
fa_data <- centered_pros[, which(colnames(centered_pros) %in% j_columns)]


#How many factors to extract?
  #Do this with gap statistic on Variance Explained by PCA components
library(nFactors)
ev <- eigen(cor(fa_data))
ap <- parallel(subject=nrow(fa_data),var=ncol(fa_data),rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS) 


#Gap Statistic -- Bad results! Don't want to use!
if(FALSE){
  objs = princomp(fa_data)$sdev
  objs = objs^2
  objs = objs/sum(objs)
  objs = cumsum(objs)
  
  vals = matrix(rep(0, 100 * ncol(fa_data)), ncol = ncol(fa_data))
  for(i in 1:100){
    null_dat <- matrix(runif(nrow(fa_data) * ncol(fa_data), min = -4, max = 4), nrow = nrow(fa_data))
    null_pca <- princomp(null_dat)  
    vars = (null_pca$sdev)^2  
    vars = vars/sum(vars)
    vals[i,] = log(1 - cumsum(vars))
  }
  avgs = colSums(vals)/nrow(vals)
  sds = apply(vals, 2, sd)
  gaps = objs - avgs  
}


#Factor Analysis
fa_data <- fa_data[, -grepl('*prange*', colnames(centered_pros))]
fit <- factanal(fa_data, 5, rotation = 'varimax')
l <- fit$loadings
write.table(l, 'loadingsMatrix.csv', sep = ';', col.names = TRUE, row.names = TRUE)
factors <- fa_data %*% l
    
#Extract 0-1 boundaries for data
gt_sinc <- dat$o_sincre #Sincerity ground truth
q_sinc <- quantile(gt_sinc)
#We see cutoffs are 6 and 8
ones = which(gt_sinc > 8) #
zeros = which(gt_sinc < 6)
gt = rep(0, length(ones) + length(zeros)) #Ground Truth
gt[1:length(ones)] = 1
split_set <- dat[c(ones, zeros),] #Data set that corresponds to 0-1 sincerity values
split_factors <- factors[c(ones, zeros),]  

#Extract Lexical Features -- Obsolete...uses factors instead of all predictors (this is why it's commented out)
if(FALSE){
  split_lex <- split_set[, 410:436]
  split_lex <- scale(split_lex, center = TRUE, scale = TRUE)
  
  predictor = cbind(split_factors, split_lex) #Predictor Matrix
  outcome = as.factor(gt) #Outcome variable
  sample_rows = sample(1:nrow(predictor), nrow(predictor)/5)
  predict_train = predictor[-sample_rows,]
  predict_test = predictor[sample_rows,]
  outcome_train = outcome[-sample_rows]
  outcome_test = outcome[sample_rows]
  
  rf <- randomForest(predict_train, y = outcome_train, xtest = predict_test, ytest = outcome_test, ntree = 500)
}

#Now try random forest without replacing by factors
split_set_all_predict = split_set[, 26:ncol(split_set)] #All predictors in the split set (no output)
split_set_all_predict = split_set_all_predict[,-(193:384)] #Get rid of deltas
split_set_all_predict = scale(split_set_all_predict, center = TRUE, scale = TRUE)
predictor = split_set_all_predict #Predictor Matrix
outcome = as.factor(gt) #Outcome variable
sample_rows = sample(1:nrow(predictor), nrow(predictor)/5)
predict_train = predictor[-sample_rows,]
predict_test = predictor[sample_rows,]
outcome_train = outcome[-sample_rows]
outcome_test = outcome[sample_rows]

rf <- randomForest(predict_train, y = outcome_train, xtest = predict_test, ytest = outcome_test, ntree = 500, importance = TRUE)
sum(diag(rf$confusion))/sum(rf$confusion) #Gets 67-70% accuracy
imp = rf$importance