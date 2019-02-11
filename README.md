# ti_celltrails:portash

## Usage

### Batch Usage

```
docker build -t ti_celltrails .
echo '' | docker run --rm -i ti_celltrails porta.sh
```

This runs the default process with default configuration (`defaults.yaml`).

Try something like this for changing the command to be run:

```
echo '{"function" : { "command" : "uname -a"}}' | \
  docker run --rm -i ti_celltrails
```

### REST/OpenFaas Usage

This container includes the OpenFaas `fwatchdog` and starts it by default:

```
docker run -it -p 8080:8080 celltrails
```

In another shell, type something like this:

```
echo '{"function":{"command":"uname -a"}}' | \
  http localhost:8080 Content-Type:Application/text
```

This only overrides the default celltrails command.

