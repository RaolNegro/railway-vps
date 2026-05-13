FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    sudo \
    vim \
    nano \
    htop \
    openssh-server \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    net-tools \
    dnsutils \
    unzip \
    zip \
    tar \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    socat \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest yarn pm2 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://tailscale.com/install.sh | sh

RUN echo "root:2010" | chpasswd

RUN sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*KbdInteractiveAuthentication.*/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*ChallengeResponseAuthentication.*/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/99-root.conf \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config.d/99-root.conf \
    && echo "KbdInteractiveAuthentication yes" >> /etc/ssh/sshd_config.d/99-root.conf \
    && rm -f /etc/ssh/sshd_config.d/60-cloudimg-settings.conf 2>/dev/null || true

RUN mkdir -p /var/run/sshd /workspace

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /workspace

EXPOSE 22 3000 8080

CMD ["/start.sh"]
