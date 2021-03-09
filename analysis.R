library(philentropy)
library(lsa)

P <- c(2, 8, 3, 7, 6, 4, 1, 3, 8, 0, 0, 0, 0, 0, 0, 0, 0)
Q <- c(0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 2, 8, 9, 1, 5, 2, 3)
test <- rbind(P, Q)
  
KL(test, est.prob = "empirical")
cosine_dist(P, Q, FALSE)
