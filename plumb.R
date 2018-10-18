library(plumber)

r <- plumb("runPlumber.R")

r$run(port=8080, host="0.0.0.0")

