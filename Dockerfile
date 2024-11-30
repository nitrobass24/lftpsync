# Use a lightweight Linux base image
FROM ubuntu:oracular

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install lftp, unrar, and other utilities
RUN apt-get update && \
    apt-get install -y lftp unrar rsync cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add the cron job
RUN echo "*/5 * * * * bash /app/my-script.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/mycron && \
    chmod 0644 /etc/cron.d/mycron && \
    crontab /etc/cron.d/mycron

# Create the log file and directory
RUN touch /var/log/cron.log

# Set the working directory
WORKDIR /app

# Default command to run a script passed as an argument
CMD ["cron", "-f"]
