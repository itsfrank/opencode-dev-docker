# docker-dev

Self-contained development image template for OpenCode Linux releases.

## Files

- `Dockerfile`: development image with Node, Bun, Rust, and common tooling
- `compose.yaml`: local dev setup that mounts this repository at `/workspace`

## Requirements

- Docker to build the image

## Quick start

Build the image with the latest OpenCode release:

```bash
docker build -f Dockerfile -t opencode-dev:latest .
```

Build the image with a specific tag:

```bash
docker build -f Dockerfile -t opencode-dev:v1.3.17 --build-arg OPENCODE_TAG=v1.3.17 .
```

Run with Compose (defaults to latest):

```bash
docker compose up --build
```

Run with a specific tag:

```bash
OPENCODE_TAG=v1.3.17 docker compose up --build
```

Run it directly:

```bash
docker run --rm -it \
  -p 4096:4096 \
  -v "$PWD:/workspace" \
  -w /workspace \
  opencode-dev:latest \
  serve --hostname 0.0.0.0 --port 4096 --print-logs
```

The compose file builds from this directory and mounts the current repository into `/workspace`.

## Different repo

Copy these files into the root of the repository you want to work in, or update the build context and volume paths in `compose.yaml`.

If another repo publishes the same release asset names, change `OPENCODE_REPO` in `Dockerfile`.

## Customizing tooling

Edit `Dockerfile` directly to add more packages, browsers, SDKs, or language toolchains.

## Notes

- Default target is Linux glibc x64 because native PTY support is more reliable there than on musl.
- If you move these files into another repo, keep them at the repo root or update `compose.yaml` paths.
