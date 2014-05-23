#This R Script does the analysis part
setwd("/home/sidd/Documents/CS224s/feats/fixedFeats");
dat <- read.table('ForAnalysis.csv', header = TRUE, sep = ';')
keep_indices <- complete.cases(dat)
dat = dat[keep_indices,] #Get rid of NAs


#Prosodic Features
pro <- dat[, c(194, 195, 199, 203, (440:ncol(dat)))]
centered_pros <- scale(pro, scale = TRUE, center = TRUE) #Mean-centers data and makes unit variance
j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD', 'voiceProb_sma_min', 'voiceProb_sma_amean', 'voiceProb_sma_stddev')
fa_data <- centered_pros[, which(colnames(centered_pros) %in% j_columns)]

#How many factors to extract?
  #Do this with gap statistic on Variance Explained
for(i in 1:100){
  null_dat <- matrix(runif(nrow(fa_data) * ncol(fa_data), min = -1, max = 1), nrow = nrow(fa_data))
  null_pca <- princomp(null_dat)
  
}


pca <- princomp(fa_data)
fa_data <- centered_pros[, -grepl('*prange*', colnames(centered_pros))]
fit <- factanal(fa_data, 7, rotation = 'varimax')
l <- fit$loadings
factors <- fa_data %*% l

#Extract 0-1 boundaries for 


#Lexical Features
lex <- dat[, 410:436]