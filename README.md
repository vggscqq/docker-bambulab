# docker-bambulab

Containerized Bambu Studio desktop environment built on `ghcr.io/linuxserver/baseimage-selkies:ubuntunoble`.

## Credit

This repository is adapted from LinuxServer.io's Firefox container work:

- Source project: https://github.com/linuxserver/docker-firefox
- Base image stack and desktop delivery are derived from LinuxServer.io

The application payload has been changed from Firefox to Bambu Studio.

## What It Does

The image starts a Selkies-hosted desktop session and launches Bambu Studio automatically.

After startup, open:

- `https://localhost:3001/`

## Build

Build the image from the repository root:

```bash
docker build --no-cache -t bambu-studio .
```

## Start

Run the container with a persistent config volume and shared memory enabled:

```bash
docker run -d \
  --name bambu-studio \
  --shm-size=1gb \
  -p 3001:3001 \
  -v ./config:/config \
  bambu-studio
```

Then connect to `https://localhost:3001/`.

## Notes

- `--shm-size=1gb` is recommended for desktop app stability.
- `./config` stores Bambu Studio state and user data.
- The Dockerfile currently downloads the latest Bambu Studio Ubuntu 24.04 AppImage from GitHub releases.