# EndeavourOS base image for Hyperion CE testing
# Based on https://github.com/ALEX5402/endeavouros-docker

FROM archlinux:latest

# Refresh keys and do initial upgrade
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Syu --noconfirm

# Add EndeavourOS repo
RUN curl -sL https://raw.githubusercontent.com/endeavouros-team/Weekly-ISO-Rebuilds/main/add-EndeavourOS | bash

# Sync with EOS repos
RUN pacman -Sy --noconfirm

# Install EOS keyring first
RUN pacman -S --noconfirm endeavouros-keyring && \
    pacman-key --populate endeavouros

# Full upgrade now that keys are in place
RUN pacman -Syu --noconfirm

# Install EOS base packages
RUN pacman -S --noconfirm \
    endeavouros-mirrorlist \
    eos-hooks \
    base \
    base-devel \
    git \
    curl \
    sudo \
    which \
    shadow

# Set /etc/os-release to reflect EndeavourOS
RUN echo 'NAME="EndeavourOS"' > /etc/os-release && \
    echo 'PRETTY_NAME="EndeavourOS"' >> /etc/os-release && \
    echo 'ID="endeavouros"' >> /etc/os-release && \
    echo 'ID_LIKE="arch"' >> /etc/os-release && \
    echo 'BUILD_ID=rolling' >> /etc/os-release && \
    echo 'ANSI_COLOR="38;2;23;147;209"' >> /etc/os-release && \
    echo 'HOME_URL="https://endeavouros.com"' >> /etc/os-release && \
    echo 'DOCUMENTATION_URL="https://discovery.endeavouros.com"' >> /etc/os-release && \
    echo 'SUPPORT_URL="https://forum.endeavouros.com"' >> /etc/os-release && \
    echo 'BUG_REPORT_URL="https://forum.endeavouros.com/c/general-system/endeavouros-installation"' >> /etc/os-release && \
    echo 'PRIVACY_POLICY_URL="https://endeavouros.com/privacy-policy-2"' >> /etc/os-release && \
    echo 'LOGO="endeavouros"' >> /etc/os-release

# Stub out /etc/lsb-release
RUN touch /etc/lsb-release

# Create a non-root test user (mimics a real install target)
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Pre-install nushell so the script can run (mirrors what setup_hyperion_isomode.bash does)
RUN pacman -S --noconfirm nushell

# Stub systemctl so it doesn't fail in a container (no init system)
RUN printf '#!/bin/sh\necho "[stub] systemctl $@"\nexit 0\n' > /usr/local/bin/systemctl && \
    chmod +x /usr/local/bin/systemctl

# Stub chsh so it doesn't fail (no PAM session in container)
RUN printf '#!/bin/sh\necho "[stub] chsh $@"\nexit 0\n' > /usr/local/bin/chsh && \
    chmod +x /usr/local/bin/chsh

# Copy the dotfiles repo into the image
COPY .. /dotfiles

WORKDIR /dotfiles

CMD ["bash"]
