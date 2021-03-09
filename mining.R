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

# Mine tweets from now to progressively earlier
while (nrow(tweets) < targetCorpusSize) {
  if (!exists("currentMinId")) {
    currentMinId <- NULL
  }
  tweetsToAppend <- search_tweets(
    query,
    n = 18000,
    include_rts = retweets,
    geocode = geocode,
    parse = TRUE,
    token = token,
    max_id = currentMinId,
    retryonratelimit = TRUE
  )
  if (exists("tweets")) {
    tweets <- rbind(tweets, tweetsToAppend)
  } else {
    tweets <- tweetsToAppend
  }
  currentMinId <- min(tweets$status_id)
  save.image()
}

# Save to a csv and clean up
write_as_csv(tweets, "./data/tweets.csv")
rm(list = ls())
