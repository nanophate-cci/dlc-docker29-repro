# DLC Docker 29 Reproduction — Docker 28 → 29 Direction

Tests what happens when DLC restores a Docker 28 (overlay2) cache onto Docker 29
(containerd snapshotter). **This direction works** because Docker 29 auto-detects
the overlay2 layout and falls back to overlay2 mode.

See [`dlc-docker29-corruption`](https://github.com/nanophate-cci/dlc-docker29-corruption)
for the failing reproduction (Docker 29 → Docker 29).

## Results

| Step | Pipeline | What happened | Result |
|------|----------|--------------|--------|
| 1 | [#2 / Job #2](https://app.circleci.com/pipelines/github/nanophate-cci/dlc-docker29-repro/2/workflows/cb4e8d2a-bc10-4650-8125-41b3579cdef0/jobs/2) | Docker 28 seeds DLC with overlay2 layout | **Success** |
| 2 | [#3 / Job #3](https://app.circleci.com/pipelines/github/nanophate-cci/dlc-docker29-repro/3/workflows/a1951caf-33f4-4ec8-8429-de073b5feb5b/jobs/3) | Docker 29 restores Docker 28 cache → auto-detects overlay2 → all layers CACHED | **Success** |

## Usage

Trigger with a specific machine image via pipeline parameters:

```bash
curl -X POST https://circleci.com/api/v2/project/gh/nanophate-cci/dlc-docker29-repro/pipeline \
  -H "Circle-Token: $CIRCLE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"parameters": {"machine-image": "ubuntu-2204:2026.05.1"}}'
```
