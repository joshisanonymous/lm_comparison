import nltk
import csv

encoding = "utf-8"
euroEnIn = "./data/europarl-v7.fr-en.en"
euroEnOutWordUni = "./data/euroEnWordUni.csv"
euroEnOutWordBi = "./data/euroEnWordBi.csv"
euroEnOutCharBi = "./data/euroEnCharBi.csv"
euroEnOutCharFour = "./data/euroEnCharFour.csv"
euroEnOutCharSix = "./data/euroEnCharSix.csv"

def getFreqDist(corpus, output, type, n):
    with open(corpus, "r", encoding=encoding) as file:
        corpus = file.readlines()
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

    types = nltk.FreqDist(tokens)

    with open(output, "w", encoding=encoding) as file:
        writer = csv.writer(file)
        writer.writerows(types.items())

getFreqDist(euroEnIn, euroEnOutWordUni, "word", 1)
getFreqDist(euroEnIn, euroEnOutWordBi, "word", 2)
getFreqDist(euroEnIn, euroEnOutCharBi, "character", 2)
getFreqDist(euroEnIn, euroEnOutCharFour, "character", 4)
getFreqDist(euroEnIn, euroEnOutCharSix, "character", 6)
