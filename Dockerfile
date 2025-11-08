# Using karsten13/magicmirror - actively maintained with latest MagicMirror version
# This image supports server-only mode needed for Balena browser block architecture
FROM karsten13/magicmirror:latest

# Switch to root user to install packages (image runs as non-root by default)
USER root

# Install nano text editor for easy config editing via Balena terminal
# Using --no-install-recommends to keep image size down
RUN apt-get update && \
    apt-get install -y --no-install-recommends nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch back to node user for security
USER node
