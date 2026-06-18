# DLC Docker 29 Reproduction

Demonstrates that Docker Layer Caching (DLC) on CircleCI is incompatible with
Docker 29's default `containerd snapshotter` storage driver.

## The Problem

CircleCI's DLC snapshots `/var/lib/docker` as a raw filesystem blob. Docker 28
stores layers under `/var/lib/docker/overlay2/`, but Docker 29 switched to the
containerd image store — a completely different on-disk layout. When DLC
restores a cache created by one engine version onto the other, Docker can't find
its layers and builds fail with:

```
parent snapshot ... does not exist
content digest ... not found
```

## How to Reproduce

1. **Pipeline 1** — trigger with `machine-image: ubuntu-2204:2025.09.1` (Docker 28).
   DLC seeds the cache using `/var/lib/docker/overlay2/`.

2. **Pipeline 2** — trigger with `machine-image: ubuntu-2204:2026.05.1` (Docker 29).
   DLC restores the Docker 28 cache. Docker 29 doesn't recognise the `overlay2/`
   layout → build errors.

Use the CircleCI API to trigger with parameters:

```bash
curl -X POST https://circleci.com/api/v2/project/gh/nanophate-cci/dlc-docker29-repro/pipeline \
  -H "Circle-Token: $CIRCLE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"parameters": {"machine-image": "ubuntu-2204:2026.05.1"}}'
```

## Related

- [moby/moby#49347](https://github.com/moby/moby/issues/49347) — Docker 29 containerd image store migration
- [docker/buildx#3046](https://github.com/docker/buildx/issues/3046) — `parent snapshot does not exist`
- GitHub Actions rolled back Docker 29 for the same class of issue
