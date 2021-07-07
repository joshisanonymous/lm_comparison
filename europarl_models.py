##################################################################
# This script takes the Europarl corpus in English and French as #
# input and generates csv files that are the raw frequencies for #
# different n-grams from that input. The function should be      #
# easily reused for other corpora.                               #
#                                                                #
# Joshua McNeill - joshua dot mcneill at uga dot edu             #
##################################################################

import nltk
import csv

## Input files, output files, and encoding
encoding = "utf-8"
# English
euroEnIn = "./data/corpora/europarl-v7.fr-en.en"
euroEnOutWordUni = "./data/LMs/euroEnWordUni.csv"
euroEnOutWordBi = "./data/LMs/euroEnWordBi.csv"
euroEnOutCharBi = "./data/LMs/euroEnCharBi.csv"
euroEnOutCharFour = "./data/LMs/euroEnCharFour.csv"
euroEnOutCharSix = "./data/LMs/euroEnCharSix.csv"
# French
euroFrIn = "./data/corpora/europarl-v7.fr-en.fr"
euroFrOutWordUni = "./data/LMs/euroFrWordUni.csv"
euroFrOutWordBi = "./data/LMs/euroFrWordBi.csv"
euroFrOutCharBi = "./data/LMs/euroFrCharBi.csv"
euroFrOutCharFour = "./data/LMs/euroFrCharFour.csv"
euroFrOutCharSix = "./data/LMs/euroFrCharSix.csv"
# English halves
euroEnOut1stWordUni = "./data/LMs/euroEn1stWordUni.csv"
euroEnOut1stWordBi = "./data/LMs/euroEn1stWordBi.csv"
euroEnOut1stCharBi = "./data/LMs/euroEn1stCharBi.csv"
euroEnOut1stCharFour = "./data/LMs/euroEn1stCharFour.csv"
euroEnOut1stCharSix = "./data/LMs/euroEn1stCharSix.csv"
euroEnOut2ndWordUni = "./data/LMs/euroEn2ndWordUni.csv"
euroEnOut2ndWordBi = "./data/LMs/euroEn2ndWordBi.csv"
euroEnOut2ndCharBi = "./data/LMs/euroEn2ndCharBi.csv"
euroEnOut2ndCharFour = "./data/LMs/euroEn2ndCharFour.csv"
euroEnOut2ndCharSix = "./data/LMs/euroEn2ndCharSix.csv"
# French halves
euroFrOut1stWordUni = "./data/LMs/euroFr1stWordUni.csv"
euroFrOut1stWordBi = "./data/LMs/euroFr1stWordBi.csv"
euroFrOut1stCharBi = "./data/LMs/euroFr1stCharBi.csv"
euroFrOut1stCharFour = "./data/LMs/euroFr1stCharFour.csv"
euroFrOut1stCharSix = "./data/LMs/euroFr1stCharSix.csv"
euroFrOut2ndWordUni = "./data/LMs/euroFr2ndWordUni.csv"
euroFrOut2ndWordBi = "./data/LMs/euroFr2ndWordBi.csv"
euroFrOut2ndCharBi = "./data/LMs/euroFr2ndCharBi.csv"
euroFrOut2ndCharFour = "./data/LMs/euroFr2ndCharFour.csv"
euroFrOut2ndCharSix = "./data/LMs/euroFr2ndCharSix.csv"


def getFreqDist(input, output, type, n, split=False, half=None):
    """Take a corpus and generate a basic n-gram frequency distribution"""
    with open(input, "r", encoding=encoding) as file:
        corpus = file.readlines()

    if split is True:
        if half == 1:
            corpus = corpus[:len(corpus)//2]
        elif half == 2:
            corpus = corpus[len(corpus)//2:]
        else:
            print("Half arg should be 1 or 2.")

    tokens = []

    for line in corpus:
        if type == "word":
            ngrams = nltk.ngrams(line.split(), n)
            for ngram in ngrams:
                if n == 1:
                    tokens.append(ngram[0])
                else:
                    tokens.append(" ".join(ngram))
        elif type == "character":
            ngrams = nltk.ngrams(line, n)
            for ngram in ngrams:
                tokens.append("".join(ngram))
        else:
            print("Type arg should be word or character.")

    types = nltk.FreqDist(tokens)

    with open(output, "w", encoding=encoding) as file:
        writer = csv.writer(file)
        writer.writerows(types.items())


## Build language models from the English and French documents
# English
getFreqDist(euroEnIn, euroEnOutWordUni, "word", 1)
getFreqDist(euroEnIn, euroEnOutWordBi, "word", 2)
getFreqDist(euroEnIn, euroEnOutCharBi, "character", 2)
getFreqDist(euroEnIn, euroEnOutCharFour, "character", 4)
getFreqDist(euroEnIn, euroEnOutCharSix, "character", 6)
# French
getFreqDist(euroFrIn, euroFrOutWordUni, "word", 1)
getFreqDist(euroFrIn, euroFrOutWordBi, "word", 2)
getFreqDist(euroFrIn, euroFrOutCharBi, "character", 2)
getFreqDist(euroFrIn, euroFrOutCharFour, "character", 4)
getFreqDist(euroFrIn, euroFrOutCharSix, "character", 6)

## Build language models from the two halves of the English documents
# First half
getFreqDist(euroEnIn, euroEnOut1stWordUni, "word", 1, True, 1)
getFreqDist(euroEnIn, euroEnOut1stWordBi, "word", 2, True, 1)
getFreqDist(euroEnIn, euroEnOut1stCharBi, "character", 2, True, 1)
getFreqDist(euroEnIn, euroEnOut1stCharFour, "character", 4, True, 1)
getFreqDist(euroEnIn, euroEnOut1stCharSix, "character", 6, True, 1)
# Second half
getFreqDist(euroEnIn, euroEnOut2ndWordUni, "word", 1, True, 2)
getFreqDist(euroEnIn, euroEnOut2ndWordBi, "word", 2, True, 2)
getFreqDist(euroEnIn, euroEnOut2ndCharBi, "character", 2, True, 2)
getFreqDist(euroEnIn, euroEnOut2ndCharFour, "character", 4, True, 2)
getFreqDist(euroEnIn, euroEnOut2ndCharSix, "character", 6, True, 2)

## Build language models from the two halves of the French documents
# First half
getFreqDist(euroFrIn, euroFrOut1stWordUni, "word", 1, True, 1)
getFreqDist(euroFrIn, euroFrOut1stWordBi, "word", 2, True, 1)
getFreqDist(euroFrIn, euroFrOut1stCharBi, "character", 2, True, 1)
getFreqDist(euroFrIn, euroFrOut1stCharFour, "character", 4, True, 1)
getFreqDist(euroFrIn, euroFrOut1stCharSix, "character", 6, True, 1)
# Second half
getFreqDist(euroFrIn, euroFrOut2ndWordUni, "word", 1, True, 2)
getFreqDist(euroFrIn, euroFrOut2ndWordBi, "word", 2, True, 2)
getFreqDist(euroFrIn, euroFrOut2ndCharBi, "character", 2, True, 2)
getFreqDist(euroFrIn, euroFrOut2ndCharFour, "character", 4, True, 2)
getFreqDist(euroFrIn, euroFrOut2ndCharSix, "character", 6, True, 2)
