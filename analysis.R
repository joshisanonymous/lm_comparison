library(philentropy)

dataDir <- "./data/"
files <- list.files(dataDir)

for(file in files) {
  objectName <- substr(file, 1, nchar(file) - 4)
  assign(objectName, read.csv(paste(dataDir, file, sep = "")))
}

WordBi <- merge(euroEn1stWordBi, euroEn2ndWordBi, by.x = 1, by.y = 1, all = TRUE)
WordBi[is.na(WordBi)] <- 0

WordBi <- merge(euroEnWordBi, euroFrWordBi, by.x = 1, by.y = 1, all = TRUE)
WordBi[is.na(WordBi)] <- 0

test <- rbind(WordBi[,2], WordBi[,3])

KL(test, est.prob = "empirical")
cosine_dist(test[1,], test[2,], FALSE)
