########################################################################
# This script collects tweets as they are posted using the researcher  #
# Twitter API access level. Tweets come from a particular region up to #
#a particular total number of tweets.                                  #
#                                                                      #
# Joshua McNeill - joshua dot mcneill at uga dot edu                   #
########################################################################


# Packages
library(rtweet)

# Variables
geocode <- "29.794355176160515,-91.5010814153191,140mi" # South Louisiana
query <- "filter:replies -filter:links"
retweets <- FALSE
targetCorpusSize <- 5000000
tweets <- data.frame() # Generate data frame

# Generate access token for Twitter API
source("token.R") # Variables with keys
token <- create_token(
  app = appName,
  consumer_key = consumerKey,
  consumer_secret = consumerSecret,
  access_token = accessToken,
  access_secret = accessSecret
)

# Mine tweets from now to later
while (nrow(tweets) < targetCorpusSize) {
  if (!exists("currentMaxId")) {
    currentMaxId <- NULL
  }
  tweetsToAppend <- search_tweets(
    query,
    n = 18000,
    include_rts = retweets,
    geocode = geocode,
    parse = TRUE,
    token = token,
    since_id = currentMaxId,
    retryonratelimit = TRUE
  )
  if (exists("tweets")) {
    tweets <- rbind(tweets, tweetsToAppend)
  } else {
    tweets <- tweetsToAppend
  }
  currentMaxId <- max(tweets$status_id)
  save.image()
}

# Remove irrelevant columns
tweets <- tweets[, c(3:7, 10, 13:18, 31, 32, 64:71, 73:75, 77:84)]

# Save to a csv and clean up
write_as_csv(tweets, "./data/corpora/tweets.csv")
rm(list = ls())
