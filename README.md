# docker-dev

Self-contained development image template and generator for OpenCode Linux releases.

The folder is portable: copy it into another repo and run it independently.

## Files

- `Dockerfile`: maintainable base dev image with Node, Bun, Rust, and common tooling
- `generate.ts`: resolves a GitHub release asset for a tag and writes a pinned Dockerfile
- `compose.yaml`: local dev setup that mounts the parent repo at `/workspace`

## Requirements

- Bun on the host to run `generate.ts`
- Docker to build the generated image

## Quick start

Generate a pinned Dockerfile for the latest x64 glibc release:

```bash
cd docker-dev
bun ./generate.ts
```

Generate for a specific tag:

```bash
cd docker-dev
bun ./generate.ts --tag v1.3.17 --arch x64
```

Generate for arm64:

```bash
cd docker-dev
bun ./generate.ts --tag v1.3.17 --arch arm64
```

Generate for musl:

```bash
cd docker-dev
bun ./generate.ts --tag v1.3.17 --arch x64 --libc musl
```

Build the generated image:

```bash
docker build -f docker-dev/Dockerfile.generated -t opencode-dev:v1.3.17 .
```

Run it directly:

```bash
docker run --rm -it \
  -p 4096:4096 \
  -v "$PWD:/workspace" \
  -w /workspace \
  opencode-dev:v1.3.17 \
  serve --hostname 0.0.0.0 --port 4096 --print-logs
```

Run it with Compose from the `docker-dev/` directory:

```bash
docker compose up --build
```

The compose file assumes `docker-dev/` lives inside the repo you want to mount, and mounts the parent directory into `/workspace`.

## Typical flow

```bash
cd docker-dev
bun ./generate.ts --tag v1.3.17 --arch x64
docker compose up --build
```

Then connect to the server on port `4096`.

## Different repo

If another repo publishes the same Linux asset names, pass `--repo owner/name`:

```bash
bun ./generate.ts --repo owner/name --tag v1.2.3
```

## Customizing tooling

Edit `Dockerfile` directly to add more packages, browsers, SDKs, or language toolchains.

Then regenerate `Dockerfile.generated` to pin a specific OpenCode binary URL and sha256.

## Notes

- Default target is Linux glibc because native PTY support is more reliable there than on musl.
- `compose.yaml` builds from `Dockerfile.generated`, so run `generate.ts` first.
- If you move this folder to another repo, keep it at the repo root or update `compose.yaml` paths.
