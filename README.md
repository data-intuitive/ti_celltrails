# Introduction

This repo is a fork of [dynverse/ti_celltrails](https://github.com/dynverse/ti_celltrails) as a proof-of-concept of using a management service for an `R` process.

We only slightly modified the original Dockerfile and used [Plumber](https://www.rplumber.io/) to convert the existing code (available in `run.R` into the same functionality behind a REST management API.

# Use

We do not provide automated builds, but building the image yourself is easy:

	docker build -t <image_name> .

Create a directory locally, like `/tmp/ti`. Then, start the container like this:

	docker run -it -p 8080:8080 <image_name>

## `/test`

In order to test the functionality, use a client of your choice (e.g. [`httpie`](https://httpie.org/)) and use something like this:


```sh
> http 'localhost:8080/test?msg=This works'
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: close
Content-Length: 31
Content-Type: application/json
Date: Thu, 18 Oct 2018 12:02:23 PM GMT

{
    "msg": [
        "Message: This works"
    ]
}
```

## `/start`

A second endpoint is defined that runs the _celltrails_ method on a synthetic
dataset. It can be run as such:

	http localhost:8080/start

The process takes some time and therefore it is wrapped in a _promise_.

## `/status`

This endpoint provides feedback on the progress of the process:

    http localhost:8080/status

It simply returns `true` when the process has finished and `false` otherwise.

## `/result`

When the process has finished, this endpoint returns the result as a `JSON` serialized object:

    http localhost:8080/result

Please note:

1. the output is not (yet) persisted on disk in the current implementation.
2. you have to check manually if the process has finished


# Remarks

A whole lot of remarks and comments are appropriate here:

1. The method takes too much time for a synchronous REST call. We therefore implemented a very basic asynchronous version.

2. The current implementation is single-user and single process only. It would
be better to keep some _state_ the backend. A `start` request would then
return a job ID to use in subsequent `status` and `result` requests.

3. Some minimal scheduling should be done, even if it's only FIFO.

4. We currently start from a synthetic dataset, generated when the API is started. This is good for testing, but worhtless when you want to
analyse real data. By mapping volumes and adapting the `runPlumber.R` file
this is possible. This, together with the previous remark, however, would
mean file names have to removed in order to avoid name clashes.

In a sense, we would be creating something similar to [Spark Jobserver](https://github.com/spark-jobserver/spark-jobserver).
