########################################################
# This script builds the network, identifies community #
# membership, and outputs a csv to replace the input   #
# csv with a version with the additional information.  #
#                                                      #
# Joshua McNeill - joshua dot mcneill at uga dot edu   #
########################################################

# Packages and data
library(igraph)

tweets <- read.csv("data/corpora/tweets.csv", encoding = "UTF-8")

# Build the network
edges <- tweets[,c("screen_name", "reply_to_screen_name")]
graph <- graph_from_data_frame(edges, directed = FALSE)

# Identify the communities
communities <- membership(cluster_louvain(graph))
communities <- data.frame(screen_name = names(communities),
                          community = as.numeric(communities))
tweets <- merge(tweets, communities, by = "screen_name")

# Remove names from corpus
tweetsAnon <- subset(tweets, select = c(-screen_name, -reply_to_screen_name, -mentions_screen_name))
tweetsAnon$text <- gsub("@[A-z0-9_]+[^A-z0-9_]", "", tweetsAnon$text)

# Subset training and test data for topic classification
picked <- sample(seq_len(nrow(tweetsAnon)), size = floor(0.01 * nrow(tweetsAnon)))
tweetsAnonTrain <- tweetsAnon[picked,]
tweetsAnonTest <- tweetsAnon[-picked,]

# Output text files
write.csv(tweetsAnon, file = "data/corpora/tweetsAnon.csv", fileEncoding = "UTF-8")
write.csv(tweetsAnonTrain, file = "data/corpora/tweetsAnonTrain.csv", fileEncoding = "UTF-8")
write.csv(tweetsAnonTest, file = "data/corpora/tweetsAnonTest.csv", fileEncoding = "UTF-8")

# Cleanup
rm(list = ls())
