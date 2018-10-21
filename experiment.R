devtools::install_github("richfitz/ids", upgrade = FALSE)
install.packages("hash")

library(hash)
library("future")
plan(multiprocess)

env <- hash()

# newId <- ids::random_id()
# env$put(newId, 'test1')
# env$exists(newId)
# env$get(newId)
# env

#* List of running jobs
#* @get /jobs
function(){
    ls(env)
}

#* Start a job
#* @get /job
function(){

  f <- future({
    cat("Future 'a' ...")
    Sys.sleep(30)
    cat("done\n")
    Sys.getpid()
  })

  newId <- ids::random_id()
  env[[newId]] <- f

  cat("Job started...\n")
  newId
}

#* Get status
#* @param job Job ID
#* @get /status
function(job = NULL){
  cat(paste0("Job ", job, "\n"))
  if (length(grep(job, keys(env))) == 1) {
    f <- env[[job]]
    if (resolved(f)) {
      "Done"
    } else {
      "Running"
      }
  }
  else "Job does not exist"
}

#* Get result from a job
#* @param job ID
#* @get /result
function(job = NULL){
  cat(paste0("Job ", job, "\n"))
  f <- env[[job]]
  result(f)$value
}
