#######################################################################
# This script loads in various language models (LMs) and gets various #
# statistics for comparing how similar/different those LMs are.       #
#                                                                     #
# Joshua McNeill - joshua dot mcneill at uga dot edu                  #
#######################################################################

## ---- load_packages_functions_data ----
# Packages
library(philentropy)
library(ggplot2)
library(tidyr)

# Variables
dataDir <- "./data/LMs/"
files <- list.files(dataDir)
colorBlindPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# Load LMs
for(file in files) {
  objectName <- substr(file, 1, nchar(file) - 4)
  assign(objectName, read.csv(paste(dataDir, file, sep = "")))
}
# Clean up temp objects
rm(file, objectName)

###############
#             #
#  Functions  #
#             #
###############
## Functions
# Merge two LMs into a data frame and remove the source objects
mergeLMs <- function(LM1, LM2) {
  merged <- merge(LM1, LM2, by.x = 1, by.y = 1, all = TRUE)
  merged[is.na(merged)] <- 0
  rm(list = c(as.character(substitute(LM1)), as.character(substitute(LM2))), envir = parent.frame())
  return(merged)
}

# Convert to the appropriate format and calculate KL divergence
calculateKL <- function(alignedLMsDf) {
  matrixed <- rbind(alignedLMsDf[, 2], alignedLMsDf[, 3])
  matrixed <- matrixed + 1 # Smoothing value
  KL(matrixed, est.prob = "empirical")
}

# Calculate cosine similarity from the correct vectors
calculateCosSim <- function(alignedLMsDf) {
  cosine_dist(alignedLMsDf[,2], alignedLMsDf[,3], testNA = FALSE)
}

###############
#             #
#    Merge    #
#     LMs     #
#             #
###############
# Those that should be the "same" English language variety
sameEn <- list(
  wordUni = mergeLMs(euroEn1stWordUni, euroEn2ndWordUni),
  wordBi = mergeLMs(euroEn1stWordBi, euroEn2ndWordBi),
  charBi = mergeLMs(euroEn1stCharBi, euroEn2ndCharBi),
  charFour = mergeLMs(euroEn1stCharFour, euroEn2ndCharFour),
  charSix = mergeLMs(euroEn1stCharSix, euroEn2ndCharSix)
)
# Make colnames the same
sameEn <- lapply(sameEn, setNames, (c("ngram", "x", "y")))

# Those that should be the "same" French language variety
sameFr <- list(
  wordUni = mergeLMs(euroFr1stWordUni, euroFr2ndWordUni),
  wordBi = mergeLMs(euroFr1stWordBi, euroFr2ndWordBi),
  charBi = mergeLMs(euroFr1stCharBi, euroFr2ndCharBi),
  charFour = mergeLMs(euroFr1stCharFour, euroFr2ndCharFour),
  charSix = mergeLMs(euroFr1stCharSix, euroFr2ndCharSix)
)
# Make colnames the same
sameFr <- lapply(sameFr, setNames, (c("ngram", "x", "y")))

# Those that should be different language varieties
different <- list(
  wordUni = mergeLMs(euroEnWordUni, euroFrWordUni),
  wordBi = mergeLMs(euroEnWordBi, euroFrWordBi),
  charBi = mergeLMs(euroEnCharBi, euroFrCharBi),
  charFour = mergeLMs(euroEnCharFour, euroFrCharFour),
  charSix = mergeLMs(euroEnCharSix, euroFrCharSix)
)
different <- lapply(different, setNames, (c("ngram", "x", "y")))
# Get most frequent character bigrams for each different variety
diffMostCharBi <- cbind(head(different$charBi[order(-different$charBi$x), 1:2], 10),
                        head(different$charBi[order(-different$charBi$y), c(1,3)], 10)
)
# Get most frequent word unigrams for each different variety
diffMostWordUni <- cbind(head(different$wordUni[order(-different$wordUni$x), 1:2], 10),
                         head(different$wordUni[order(-different$wordUni$y), c(1, 3)], 10)
)

# Get most frequent word unigrams for each English LM
sameEnMostWordUni <- cbind(head(sameEn$wordUni[order(-sameEn$wordUni$x), 1:2], 10),
                           head(sameEn$wordUni[order(-sameEn$wordUni$y), c(1, 3)], 10)
)

# Get most frequent word bigrams for each different variety
diffMostWordBi <- cbind(head(different$wordBi[order(-different$wordBi$x), 1:2], 10),
                        head(different$wordBi[order(-different$wordBi$y), c(1, 3)], 10)
)

# Get most frequent word bigrams for each English LM
sameEnMostWordBi <- cbind(head(sameEn$wordBi[order(-sameEn$wordBi$x), 1:2], 10),
                          head(sameEn$wordBi[order(-sameEn$wordBi$y), c(1, 3)], 10)
)

# Get most frequent character 4-grams for each different variety
diffMostCharFour <- cbind(head(different$charFour[order(-different$charFour$x), 1:2], 10),
                          head(different$charFour[order(-different$charFour$y), c(1, 3)], 10)
)

# Get most frequent character 4-grams for each English LM
sameEnMostCharFour <- cbind(head(sameEn$charFour[order(-sameEn$charFour$x), 1:2], 10),
                            head(sameEn$charFour[order(-sameEn$charFour$y), c(1, 3)], 10)
)

# Get most frequent character 6-grams for each different variety
diffMostCharSix <- cbind(head(different$charSix[order(-different$charSix$x), 1:2], 10),
                         head(different$charSix[order(-different$charSix$y), c(1, 3)], 10)
)

# Get most frequent character 6-grams for each English LM
sameEnMostCharSix <- cbind(head(sameEn$charSix[order(-sameEn$charSix$x), 1:2], 10),
                           head(sameEn$charSix[order(-sameEn$charSix$y), c(1, 3)], 10)
)

# Combine LMs into large multidimensional LMs good for calculateCosSim
allSameEn <- do.call("rbind", sameEn)
allSameFr <- do.call("rbind", sameFr)
allDiff <- do.call("rbind", different)

# Grab small range of models to demonstrate classification
wordBiDiffeG <- allDiff[10354200:10354210,]

###############
#             #
#  Calculate  #
#    Stats    #
#             #
###############
# Get the proportion of duplicate n-grams in the combined models LM that are
# duplicates out of all unique n-grams in the combined models LM
allDuplicateNgrams <- allDiff$ngram[duplicated(allDiff$ngram)]

# Get KL divergences
KLlinglevs <- data.frame(
  "LM.Type" = c("Word Unigram", "Word Bigram",
                "Character Bigram", "Character 4-gram", "Character 6-gram"),
  "Both.English" = sapply(sameEn, calculateKL),
  "Both.French" = sapply(sameFr, calculateKL),
  "English.vs.French" = sapply(different, calculateKL)
)
KLlinglevsGraphSafe <- gather(KLlinglevs, key = "Varieties.Compared", value = "KL.Divergence",
                              Both.English, Both.French, English.vs.French)
KLlinglevsGraphSafe$LM.Type <- factor(KLlinglevsGraphSafe$LM.Type,
                                      levels = c("Word Unigram", "Word Bigram",
                                                 "Character Bigram", "Character 4-gram", "Character 6-gram"))

KLall <- data.frame(
  "Varieties.Compared" = c("Both English", "Both French", "English vs French"),
  "KL.Divergence" = c(
    calculateKL(allSameEn),
    calculateKL(allSameFr),
    calculateKL(allDiff)
  ),
  row.names = NULL
)

# Get cosine similarities
CosSimlinglevs <- data.frame(
  "LM.Type" = c("Word Unigram", "Word Bigram",
                "Character Bigram", "Character 4-gram", "Character 6-gram"),
  "Both.English" = sapply(sameEn, calculateCosSim),
  "Both.French" = sapply(sameFr, calculateCosSim),
  "English.vs.French" = sapply(different, calculateCosSim)
)
CosSimlinglevsGraphSafe <- gather(CosSimlinglevs, key = "Varieties.Compared", value = "Cosine.Similarity",
                                  Both.English, Both.French, English.vs.French)
CosSimlinglevsGraphSafe$LM.Type <- factor(CosSimlinglevsGraphSafe$LM.Type,
                                          levels = c("Word Unigram", "Word Bigram",
                                                     "Character Bigram", "Character 4-gram", "Character 6-gram"))

CosSimall <- data.frame(
  "Varieties.Compared" = c("Both English", "Both French", "English vs French"),
  "Cosine.Similarity" = c(
    calculateCosSim(allSameEn),
    calculateCosSim(allSameFr),
    calculateCosSim(allDiff)
  ),
  row.names = NULL
)

################
#              #
#    Graphs    #
#              #
################
# Barplot for comparing KL divergence between LMs that combine all linguistic levels
graphKLall <- ggplot(
  KLall, aes(x = Varieties.Compared, y = KL.Divergence)) +
  geom_bar(stat = "identity") +
  ylim(0, max(KLall$KL.Divergence) + 0.5) +
  theme_bw() +
  labs(x = "Varieties Compared",
       y = "KL Divergence") +
  geom_text(aes(label = round(KL.Divergence, 3)), vjust = -0.5)

# Barplot for comparing cosine similarity between LMs that combine all linguistic levels
graphCosSimall <- ggplot(
  CosSimall, aes(x = Varieties.Compared, y = Cosine.Similarity)) +
  geom_bar(stat = "identity") +
  ylim(0, max(CosSimall$Cosine.Similarity) + 0.1) +
  theme_bw() +
  labs(x = "Varieties Compared",
       y = "Cosine Similarity") +
  geom_text(aes(label = round(Cosine.Similarity, 3)), vjust = -0.5)

# Barplot for comparing KL divergence between LMs by linguistic level
graphKLlinglevs <- ggplot(
  KLlinglevsGraphSafe, aes(x = LM.Type, y = KL.Divergence, fill = Varieties.Compared)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1)) +
  labs(x = "LM Type", y = "KL Divergence", fill = "Varieties Compared") +
  scale_fill_manual(values = colorBlindPalette,
                    labels = c("Both English", "Both French", "English vs French"))

# Barplot for comparing cosine similarity between LMs by linguistic level
graphCosSimlinglevs <- ggplot(
  CosSimlinglevsGraphSafe, aes(x = LM.Type, y = Cosine.Similarity, fill = Varieties.Compared)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1)) +
  labs(x = "LM Type", y = "Cosine Similarity", fill = "Varieties Compared") +
  scale_fill_manual(values = colorBlindPalette,
                    labels = c("Both English", "Both French", "English vs French"))
