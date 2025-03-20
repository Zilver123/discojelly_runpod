# Create the build image
FROM ubuntu:latest as build

# Update package lists and install necessary packages
RUN apt-get update && apt-get upgrade -y  && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    curl \
    wget \
    tar \
    vim \
    python3 \
    python3-venv \
    python3-pip \
    nodejs \
    npm \
    htop \
    nano \
    git && \
    rm -rf /var/lib/apt/list/*

# Install pm2 locally for the user
RUN npm install pm2 -g

# Set the home directory
ENV HOME=/home/appuser

# Create a non-root user 'appuser'
RUN useradd -m -d $HOME -s /bin/bash appuser

# Set the working directory
WORKDIR /home/appuser

# Switch to non-root user
USER appuser

# Copy scripts into the container
COPY --chown=appuser:appuser scripts $HOME/scripts

# Make scripts executable
RUN chmod +x $HOME/scripts/*.sh

# Expose necessary ports (adjust as needed for your application)
EXPOSE 40000-41000

# Start the application using the start script
CMD ["sh", "-c", "$HOME/scripts/start.sh"]