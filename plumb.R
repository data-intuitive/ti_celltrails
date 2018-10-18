library(plumber)

r <- plumb("/code/runPlumber.R")

r$run(port=8080, host="0.0.0.0")

