FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG NODE_VERSION=24.4.0
ARG BUN_VERSION=1.3.11
ARG RUST_TOOLCHAIN=stable
ARG OPENCODE_TAG=latest
ARG OPENCODE_REPO=https://github.com/anomalyco/opencode/releases

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    jq \
    openssh-client \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    ripgrep \
    unzip \
    xz-utils \
    zip \
  && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-lc"]

ENV BUN_INSTALL=/opt/bun
ENV CARGO_HOME=/opt/cargo
ENV RUSTUP_HOME=/opt/rustup
ENV PATH=/opt/bun/bin:/opt/cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN arch=$(uname -m); \
  node_arch=x64; \
  if [ "$arch" = "aarch64" ]; then node_arch=arm64; fi; \
  curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${node_arch}.tar.xz" \
  | tar -xJf - -C /usr/local --strip-components=1; \
  corepack enable

RUN curl -fsSL https://bun.sh/install | bash -s -- "bun-v${BUN_VERSION}"

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y --profile minimal --default-toolchain ${RUST_TOOLCHAIN}

RUN if [ "$OPENCODE_TAG" = "latest" ]; then \
    opencode_url="${OPENCODE_REPO}/latest/download/opencode-linux-x64.tar.gz"; \
  else \
    opencode_url="${OPENCODE_REPO}/download/${OPENCODE_TAG}/opencode-linux-x64.tar.gz"; \
  fi \
  && curl -fsSL "$opencode_url" -o /tmp/opencode.tgz \
  && tar -xzf /tmp/opencode.tgz -C /tmp \
  && install -m 0755 /tmp/opencode /usr/local/bin/opencode \
  && rm -f /tmp/opencode /tmp/opencode.tgz \
  && opencode --version

WORKDIR /workspace

ENTRYPOINT ["opencode"]
