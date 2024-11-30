# Use a lightweight Linux base image
FROM ubuntu:oracular

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install lftp, unrar, and other utilities
RUN apt-get update && \
    apt-get install -y lftp unrar rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Default command to run a script passed as an argument
CMD ["bash"]
