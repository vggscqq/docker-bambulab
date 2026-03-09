# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="vgscq"

# title
ENV TITLE="Bambu Studio" \
    NO_GAMEPAD=true

RUN \
  echo "**** install dependencies ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libgtk-3-0 \
    libwebkit2gtk-4.1-0 \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libgstreamer-plugins-bad1.0-0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    libosmesa6 \
    libgl1 \
    libglu1-mesa \
    libsecret-1-0 \
    libwayland-client0 \
    libwayland-egl1 \
    fuse \
    file && \
  echo "**** download and install Bambu Studio ****" && \
  BAMBU_DL_URL=$(curl -sL https://api.github.com/repos/bambulab/BambuStudio/releases/latest \
    | grep -oP '"browser_download_url":\s*"\K[^"]*ubuntu-24\.04[^"]*\.AppImage' \
    | head -n 1) && \
  test -n "${BAMBU_DL_URL}" && \
  echo "Downloading Bambu Studio from: ${BAMBU_DL_URL}" && \
  curl -fSL -o /tmp/bambu-studio.AppImage "${BAMBU_DL_URL}" && \
  chmod +x /tmp/bambu-studio.AppImage && \
  cd /opt && \
  /tmp/bambu-studio.AppImage --appimage-extract && \
  mv squashfs-root bambu-studio && \
  ln -s /opt/bambu-studio/AppRun /usr/bin/bambu-studio && \
  echo "**** add icon ****" && \
  (cp /opt/bambu-studio/resources/images/BambuStudio.ico /usr/share/selkies/www/icon.png || true) && \
  printf "version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  rm -f /tmp/bambu-studio.AppImage && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001

VOLUME /config
