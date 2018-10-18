# Introduction

This repo is a fork of [dynverse/ti_celltrails](https://github.com/dynverse/ti_celltrails) as a proof-of-concept of using a management service for an `R` process.

We only slightly modified the original Dockerfile and used [Plumber](https://www.rplumber.io/) to convert the existing code (available in `run.R` into the same functionality behind a REST management API.

# Use

We do not provide automated builds, but building the image yourself is easy:

	docker build -t <image_name> .

Create a directory locally, like `/tmp/ti`. Then, start the container like this:

	docker run -it -v /tmp/ti:/ti/output -p 8080:8080 <image_name>

In order to test the functionality, use a client of your choice (e.g. [`httpie`](https://httpie.org/))

```
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

A second endpoint is defined that runs the celltrails method on a synthetic
dataset. It can be run as such:

	http localhost:8080/start

The process takes more than 30s and results in a timeout on the http client.
Nevertheless, the celltrails method should continue running and store the
result under `/tmp/ti`.

# Remarks

A whole lot of remarks and comments are appropriate here:

1. The method takes too much time for a synchronous REST call. There should be
an asynchronous `start` endpoint and additionally a `status` and `result`
endpoint.

2. The current implementation is single-user and single process only. It would
be better to keep some _state_ the backend. A `start` request would then
return a job ID to use in subsequent `status` and `result` requests.

3. Some minimal scheduling should be done, even if it's only FIFO.

4. We currently start from a synthetic dataset, generated when the `start`
endpoint is called. This is good for testing, but worhtless when you want to
analyse specific data. By mapping volumes and adapting the `runPlumber.R` file
this is possible. This, together with the previous remarks, however, would
mean file names have to removed in order to avoid name clashes.

In a sense, we would be creating something similar to [Spark Jobserver](https://github.com/spark-jobserver/spark-jobserver).


