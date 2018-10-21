# Introduction

This repo is a fork of [dynverse/ti_celltrails](https://github.com/dynverse/ti_celltrails) as a proof-of-concept of using a management service for an `R` process.

We only slightly modified the original Dockerfile and used [Plumber](https://www.rplumber.io/) to convert the existing code (available in `run.R` into the same functionality behind a REST management API.

# Use

We do not provide automated builds, but building the image yourself is easy:

	docker build -t <image_name> .

Create a directory locally, like `/tmp/ti`. Then, start the container like this:

	docker run -it -p 8080:8080 <image_name>

## `/jobs`

In order to test the functionality, use a client of your choice (e.g. [`httpie`](https://httpie.org/)) and use something like this:

```sh
> http 'localhost:8080/jobs'
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: close
Content-Length: 31
Content-Type: application/json
Date: Thu, 18 Oct 2018 12:02:23 PM GMT

[]
```

This endpoint returns a list of job IDs.

## `/job`

Start a new celltrails process. Synthetic data is generated for each call

	http localhost:8080/job

The output of this (async) call is the job ID for this job. The process takes some time and therefore it is wrapped in a _promise_.

Multiple jobs can be started and the `future` package will _try_ to run them in parallel.

## `/status`

A status can be requested for a job, resulting in either of 3 possibilities: Running, Done and a job ID that is not correct.

    http localhost:8080/status\?job\=<jobID>

## `/result`

When the process has finished, this endpoint returns the result as a `JSON` serialized object:

    http localhost:8080/result\?job\=<jobID>

Please note:

1. the output is not (yet) persisted on disk in the current implementation.
2. you have to check manually if the process has finished


# Remarks

A whole lot of remarks and comments are appropriate here:

1. The method takes too much time for a synchronous REST call. We therefore implemented a very basic asynchronous version.

2. We allow for simple job scheduling, but your mileage may vary.

3. We currently start from a synthetic dataset, generated when the API is started. This is good for testing, but worhtless when you want to
analyse real data. By mapping volumes and adapting the `runPlumber.R` file
this is possible. This, together with the previous remark, however, would
mean file names have to removed in order to avoid name clashes.

In a sense, we would be creating something similar to [Spark Jobserver](https://github.com/spark-jobserver/spark-jobserver).
