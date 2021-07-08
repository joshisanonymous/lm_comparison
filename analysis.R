#######################################################################
# This script loads in various language models (LMs) and gets various #
# statistics for comparing how similar/different those LMs are.       #
#                                                                     #
# Joshua McNeill - joshua dot mcneill at uga dot edu                  #
#######################################################################

## ----load_packages_functions_data ----
# Packages
library(philentropy)
library(ggplot2)

# Variables
dataDir <- "./data/LMs/"
files <- list.files(dataDir)

# Load LMs
for(file in files) {
  objectName <- substr(file, 1, nchar(file) - 4)
  assign(objectName, read.csv(paste(dataDir, file, sep = "")))
}
# Clean up temp objects
rm(file, objectName)

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

## Merge LMs
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

# Combine LMs into large multidimensional LMs good for calculateCosSim
allSameEn <- do.call("rbind", sameEn)
allSameFr <- do.call("rbind", sameFr)
allDiff <- do.call("rbind", different)

## Calculate stats
# Get KL divergences
KLlinglevs <- data.frame(
  "sameEn" = sapply(sameEn, calculateKL),
  "sameFr" = sapply(sameFr, calculateKL),
  "different" = sapply(different, calculateKL)
)
KLall <- data.frame(
  "all" = c(
    calculateKL(allSameEn),
    calculateKL(allSameFr),
    calculateKL(allDiff)
  ),
  row.names = c("English", "French", "different")
)

# Get cosine similarities
CosSimlinglevs <- data.frame(
  "sameEn" = sapply(sameEn, calculateCosSim),
  "sameFr" = sapply(sameFr, calculateCosSim),
  "different" = sapply(different, calculateCosSim) 
)
CosSimall <- data.frame(
  "all" = c(
    calculateCosSim(allSameEn),
    calculateCosSim(allSameFr),
    calculateCosSim(allDiff)
  ),
  row.names = c("English", "French", "different")
)