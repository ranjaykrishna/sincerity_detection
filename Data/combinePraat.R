header <- read.table('Data/praat_header.csv', header = FALSE)
feats <- read.table('Data/praat_feats.csv', header = FALSE, sep = ';')

colnames(feats) <- header[,1]
write.table(feats, 'praat_with_header.csv', sep = ';', col.names = TRUE, row.names = FALSE)