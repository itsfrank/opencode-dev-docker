# docker-dev

Self-contained Arch Linux development image template for OpenCode Linux releases.

## Files

- `Dockerfile`: Arch Linux development image with Node, Bun, Rust, and common tooling
- `compose.yaml`: local dev setup that mounts `WORKSPACE_DIR` at `/workspace`

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
WORKSPACE_DIR=$HOME/workspace UID=$(id -u) GID=$(id -g) docker compose up --build
```

Run with a specific tag:

```bash
WORKSPACE_DIR=$HOME/workspace UID=$(id -u) GID=$(id -g) OPENCODE_TAG=v1.3.17 docker compose up --build
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

The compose file builds from this directory, mounts `WORKSPACE_DIR` into `/workspace/repos`, and runs the container as `root` so OpenCode can access the mounted workspace consistently.

If `WORKSPACE_DIR` is not set, it falls back to the compose file directory.

The container home directory is `/home/opencode`, separate from `/workspace/repos`.

OpenCode config and data are mounted from your host user's normal XDG locations into that runtime home so they persist across container restarts.

Git is configured inside the container with `safe.directory='*'` so bind-mounted repositories are accepted when running as `root`.

- Host config directory: `${HOME}/.config/opencode`
- Host config file: `${HOME}/.config/opencode/opencode.json`
- Host data directory: `${HOME}/.local/share/opencode`

Persisting `${HOME}/.local/share/opencode` keeps OpenAI authentication between sessions.

## Different repo

Copy these files into any directory and set `WORKSPACE_DIR` to the parent folder containing the repositories you want available inside the container.

If another repo publishes the same release asset names, change `OPENCODE_REPO` in `Dockerfile`.

## Customizing tooling

Edit `Dockerfile` directly to add more `pacman` packages, browsers, SDKs, or language toolchains.

## Notes

- Default target is Linux glibc x64 because native PTY support is more reliable there than on musl.
- If you move these files into another repo, keep them at the repo root or update `compose.yaml` paths.
