FROM python:3.12.2-slim

# Install required packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        build-essential \
        ffmpeg \
        curl \
        wget \
        nano \
        sudo \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create a non-root user
RUN useradd --create-home appuser \
    && echo "appuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/appuser \
    && chmod 0440 /etc/sudoers.d/appuser \
    && mkdir /home/appuser/app/ \
    && chmod -R 755 /home/appuser/app/

# Switch to the non-root user
USER appuser

# Set up work directory
WORKDIR /home/appuser/app/

# Install pipx
RUN python -m pip install --upgrade pip \
    && python -m pip install --user pipx \
    && python -m pipx ensurepath

# Clone the repository and install its dependencies
COPY . /home/appuser/app/fabric/
RUN python -m pipx install ./fabric

# Set the entrypoint
ENTRYPOINT ["/usr/bin/bash"]
