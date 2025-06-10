# Use hotio's Alpine-based VPN-ready base image
FROM hotio/base:alpinevpn

# Install required tools
RUN apk add --no-cache \
    bash \
    lftp \
    rsync \
    wget \
    build-base \
    cron

# Build and install unrar manually (not available in Alpine's official repos)
RUN wget https://www.rarlab.com/rar/unrarsrc-6.2.10.tar.gz && \
    tar -xzf unrarsrc-6.2.10.tar.gz && \
    cd unrar && \
    make -f makefile && \
    install -m 755 unrar /usr/local/bin/unrar && \
    cd .. && \
    rm -rf unrar unrarsrc-6.2.10.tar.gz

# Set up cron job to run the script every 5 minutes with verbose logging to both screen and file
RUN echo '*/5 * * * * bash -x /app/my-script.sh 2>&1 | tee -a /var/log/cron.log' > /etc/crontabs/root

# Prepare working directory and log file
RUN mkdir -p /app && touch /var/log/cron.log

# Set working directory
WORKDIR /app

# Run cron in the foreground
CMD ["crond", "-f"]
