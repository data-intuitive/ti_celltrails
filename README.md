# ti_celltrails:portash

## Usage

Simple usage:

```
docker build -t ti_celltrails:portash .
echo '' | docker run --rm -i ti_celltrails:portash
```

This runs the default process with default configuration (`defaults.yaml`).

Try something like this for changing the command to be run:

```
echo '{"function" : { "command" : "uname -a"}}' | \
  docker run --rm -i ti_celltrails:portash
```

## Note

This container is FAAS-ready.
