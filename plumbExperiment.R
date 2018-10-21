library(plumber)

r <- plumb("/code/experiment.R")

r$run(port=8080, host="0.0.0.0", swagger=interactive())
