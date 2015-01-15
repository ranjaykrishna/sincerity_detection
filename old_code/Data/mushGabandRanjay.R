setwd("/home/sidd/Documents/CS224s/feats/fixedFeats");
ac <- read.table('Aggregate.csv', sep = ';', header = FALSE)
stringers <- scan('strings.txt', sep = ';', what = character())
colnames(ac) = c(stringers[2:386], "MaleID", "FemaleID", "MaleBool")

lex <- read.table('lex_feat_reformatted.csv', sep = ',', header = FALSE)
lex_strings <- scan('lex_strings.txt', sep = ';', what = character())
colnames(lex) = lex_strings

#Get rid of redundant rows
remove_rows = rep(FALSE, nrow(lex))
for(i in 1:nrow(lex)){
  m = as.numeric(substr(lex[i, 28], 5, 7))
  f = as.numeric(substr(lex[i, 29], 7, 9))
  gen = lex[i, 30]
  opp_gen = 'False'
  if(gen == 'False'){
    opp_gen = 'True'
  }
  #nrow(lex[lex[, 28] == paste('male', toString(f), sep = '') & lex[, 29] == paste('female', toString(m), sep = '') & lex[, 30] == opp_gen,])
  opp_row = (1:nrow(lex))[lex[, 28] == paste('male', toString(f), sep = '') & lex[, 29] == paste('female', toString(m), sep = '') & lex[, 30] == gen]
  #print(rbind(lex[i,25:30], lex[opp_row,25:30]))
  if(remove_rows[i] != TRUE){ #Only remove one of the rows
    remove_rows[opp_row] = TRUE
  }
}

lex_new = lex[remove_rows == FALSE,]
#Make sure male ID and female ID are always right -- when order is wrong, swap them
new_male = rep(0, nrow(lex_new))
new_female = rep(0, nrow(lex_new))
for(i in 1:nrow(lex_new)){
  m = as.numeric(substr(lex_new[i, 28], 5, 7)) 
  f = as.numeric(substr(lex_new[i, 29], 7, 9)) 
  new_male[i] = m 
  new_female[i] = f 
  if(m > f){ 
    new_male[i] = f
    new_female[i] = m 
  } 
} 
lex_new[, 28] = new_male
lex_new[, 29] = new_female

#We want our lexical features to be:
# (1): #Hedge words
# (2): #Academic Words
# (3): syllables per word
# (4): syllables per turn
# (5): 
lex_new$hedge = lex_new$sortOf + lex_new$kindOf + lex_new$iGuess + lex_new$iThink + lex_new$aLittle + lex_new$maybe + lex_new$possibly + lex_new$probably
lex_new$academics = lex_new$work + lex_new$program + lex_new$phd + lex_new$research + lex_new$professor + lex_new$advisor

#Change gender column in AC and lex_new to fit each otehr
ac$MaleBool = (ac$MaleBool == 1)
lex_new$maleBool = (lex_new$maleBool == 'True')

#Reorder lex_new to accord with ac
merge_indices = rep(0, nrow(ac))
for(i in 1:nrow(ac)){
  ac_male = ac$MaleID[i]
  ac_female = ac$FemaleID[i]
  ac_gen = ac$MaleBool[i]
  corres_row = (1:nrow(lex_new))[lex_new$male == ac_male & lex_new$female == ac_female & lex_new$maleBool == ac_gen]
  merge_indices[i] = corres_row
}

lex_r = lex_new[merge_indices,]
cbind(ac[, 386:388], lex_r[, 28:30])
m_set = cbind(ac[, 1:385], lex_r)


#Get labels
lab <- read.table('labels.csv', sep = ',', header = TRUE, na.strings = ".")
merge_indices = rep(0, nrow(m_set))
for(i in 1:nrow(m_set)){
  m_male = m_set$male[i]
  m_female = m_set$female[i]
  m_gen = m_set$maleBool[i]
  corre_row = -1
  if(m_gen){
    corres_row = (1:nrow(lab))[lab$selfid == m_male & lab$otherid == m_female]
  } else {
    corres_row = (1:nrow(lab))[lab$selfid == m_female & lab$otherid == m_male]
  }
  merge_indices[i] = corres_row
}
lab_r = lab[merge_indices,]
#cbind(m_set[, 412:415], lab_r[1:2])
merged <- cbind(lab_r, m_set[,-which(colnames(m_set) %in% c('male', 'female'))])
#write.table(merged, 'FullDataSet.csv', sep = ';', col.names = TRUE, na  = "NA" )


#Get Praat prosody dataset
praat <- read.csv('praat_feats.csv', header = FALSE, sep = ';')
praat_names <- read.csv('praat_header.csv', header = FALSE, sep = ';')
colnames(praat) = make.names(as.character(praat_names[, 1]))
praat = praat[, -c(28, 29)] #Get rid of null SD columns

lab <- read.table('labels.csv', sep = ',', header = TRUE, na.strings = ".")
praat_order <- rep(0, nrow(praat)) #To reorder for matching outputs
lex_order <- rep(0, nrow(praat))
for(i in 1:nrow(praat)){
  s = praat$Speaker[i]
  o = praat$Other[i]
  corres_row = which(lab$selfid == s & lab$otherid == o)
  c_lex_row = which(merged$selfid == s & merged$otherid == o)
  if(length(corres_row) != 0){
    praat_order[i] = corres_row
  } else {
    #If no corresponding row in label, mark for deletion
    praat_order[i] = NA
  }
  
  if(length(c_lex_row) != 0){
    lex_order[i] = c_lex_row
  } else {
    lex_order[i] = NA
  }
}

#Delete Rows from praat, praat_order, and lex_order that correspond to an NA
delete_rows = which(is.na(praat_order) | is.na(lex_order))
for(cur_row in delete_rows){
  praat = praat[-cur_row,]
  praat_order = praat_order[-cur_row]
  lex_order = lex_order[-cur_row]
}

#Merge Set reordered to align with praat set
merge_set = merged[lex_order,] 

#Total Data Set!
t_dat <- cbind(merge_set, praat[, -which(colnames(praat) %in% c('Speaker', 'Other'))])
write.table(t_dat, 'ForAnalysis.csv', col.names = TRUE, row.names = FALSE, sep = ';')

#Old code for analysis -------------------------------------------------------------------------------------------------------

#Analysis on Praat Prosody Shit
#Factor Analysis for Praat
#First PCA
predictors <- praat[, 3:ncol(praat)]
predictors <- scale(predictors, center = TRUE, scale = TRUE)
pca <- princomp(predictors)
plot(pca$sdev, xlab = 'Component Index', main = 'Std Dev. of Principal Component by Index', ylab = "Std Dev.")
j_columns = c("tndur.Mean", 'tndur.SD', 'pmin.Mean', 'pmin.SD', 'pmax.Mean', 'pmax.SD', 'pmean.Mean', 'pmean.SD', 'psd.Mean', 'psd.SD', 'imin.Mean', 'imin.SD', 'imax.Mean', 'imax.SD', 'imean.Mean', 'imean.SD')
j_data = predictors[, which(colnames(predictors) %in% j_columns)]
fit <- factanal(j_data, 6, rotation = 'varimax')

#Hierarchical clustering by prosodic features
d = dist(predictors)
q = hclust(d, method = 'complete')

sincere = praat_output$o_sincre
colfunc <- colorRampPalette(c("red", "blue"))
palette = colfunc(10)
since_cols = rep(0, length(sincere))
for(i in 1:length(sincere)){
  since_cols[i] = palette[sincere[i]]  
}
library(moduleColor)
w = as.dendrogram(q)
plotHclustColors(w, since_cols)

