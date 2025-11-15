# Using karsten13/magicmirror - actively maintained with latest MagicMirror version
# This image supports server-only mode needed for Balena browser block architecture
FROM karsten13/magicmirror:latest

# Install nano text editor for easy config editing via Balena terminal
# Using --no-install-recommends to keep image size down
RUN apt-get update && \
    apt-get install -y --no-install-recommends nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fix permissions for config, modules, and css directories
# These directories are mounted as volumes and need to be writable by the container user
RUN mkdir -p /opt/magic_mirror/config /opt/magic_mirror/modules /opt/magic_mirror/css && \
    chmod -R 777 /opt/magic_mirror/config /opt/magic_mirror/modules /opt/magic_mirror/css
