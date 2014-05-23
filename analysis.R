#This R Script does the analysis part
setwd("/home/sidd/Documents/CS224s/feats/fixedFeats");
dat <- read.table('ForAnalysis.csv', header = TRUE, sep = ';')
keep_indices <- complete.cases(dat)
dat = dat[keep_indices,] #Get rid of NAs


#Prosodic Features
pro <- dat[, c(194, 195, 199, 203, (440:ncol(dat)))]
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


#Gap Statistic
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


#Factor Analysis
pca <- princomp(fa_data)
fa_data <- centered_pros[, -grepl('*prange*', colnames(centered_pros))]
fit <- factanal(fa_data, 7, rotation = 'varimax')
l <- fit$loadings
factors <- fa_data %*% l


#Extract 0-1 boundaries for data
gt_sinc <- dat$o_sincre #Sincerity ground truth
q_sinc <- quantile(gt_sinc)
#We see cutoffs are 6 and 1
ones = which(gt_sinc >= 8) #
zeros = which(gt_sinc <= 6)
gt = rep(0, length(ones) + length(zeros)) #Ground Truth
gt[1:length(ones)] = 1







#Lexical Features
lex <- dat[, 410:436]