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
euroEnIn = "./data/europarl-v7.fr-en.en"
euroEnOutWordUni = "./data/euroEnWordUni.csv"
euroEnOutWordBi = "./data/euroEnWordBi.csv"
euroEnOutCharBi = "./data/euroEnCharBi.csv"
euroEnOutCharFour = "./data/euroEnCharFour.csv"
euroEnOutCharSix = "./data/euroEnCharSix.csv"
# French
euroFrIn = "./data/europarl-v7.fr-en.fr"
euroFrOutWordUni = "./data/euroFrWordUni.csv"
euroFrOutWordBi = "./data/euroFrWordBi.csv"
euroFrOutCharBi = "./data/euroFrCharBi.csv"
euroFrOutCharFour = "./data/euroFrCharFour.csv"
euroFrOutCharSix = "./data/euroFrCharSix.csv"
# English halves
euroEnOut1stWordUni = "./data/euroEn1stWordUni.csv"
euroEnOut1stWordBi = "./data/euroEn1stWordBi.csv"
euroEnOut1stCharBi = "./data/euroEn1stCharBi.csv"
euroEnOut1stCharFour = "./data/euroEn1stCharFour.csv"
euroEnOut1stCharSix = "./data/euroEn1stCharSix.csv"
euroEnOut2ndWordUni = "./data/euroEn2ndWordUni.csv"
euroEnOut2ndWordBi = "./data/euroEn2ndWordBi.csv"
euroEnOut2ndCharBi = "./data/euroEn2ndCharBi.csv"
euroEnOut2ndCharFour = "./data/euroEn2ndCharFour.csv"
euroEnOut2ndCharSix = "./data/euroEn2ndCharSix.csv"


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
