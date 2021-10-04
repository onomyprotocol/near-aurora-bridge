## Build locally

```
docker build -t onomy/near-aurora-local:local-bridge --progress=plain  -f Dockerfile .
```

## Run locally

```
docker run -p 3030:3030 --name onomy-near-local-bridge onomy/near-aurora-local:local-bridge
```
