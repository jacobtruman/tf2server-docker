FROM ubuntu:16.04

ENV TF2_SERVER_USER=tf2server
ENV TF2_SERVER_INSTALL_DIR=/${TF2_SERVER_USER}/serverfiles

RUN mkdir -p /${TF2_SERVER_USER}

# add entrypoint.sh and fix permissions
COPY entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/entrypoint.sh && \
    mkdir -p ${TF2_SERVER_INSTALL_DIR}/tf2/tf/cfg && \
    mkdir ${TF2_SERVER_INSTALL_DIR}/tf2/tf/maps

# Install steamcmd + srcds_linux dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y mailutils \
    postfix \
    curl \
    wget \
    vim \
    file \
    bzip2 \
    gzip \
    unzip \
    bsdmainutils \
    python \
    util-linux \
    tmux \
    lib32gcc1 \
    libstdc++6 \
    libstdc++6:i386 \
    libcurl4-gnutls-dev:i386

# Install steamcmd to /steam/steamcmd/
ADD https://gameservermanagers.com/dl/tf2server /${TF2_SERVER_USER}/

ENV TF2_SERVER_SCRIPT=/${TF2_SERVER_USER}/tf2server

# Untar, create user steamcmd and chown + plus first SteamCMD run
RUN useradd -m ${TF2_SERVER_USER} && \
    chown -R ${TF2_SERVER_USER}:${TF2_SERVER_USER} /${TF2_SERVER_USER} && \
    chmod -R 744 /${TF2_SERVER_USER}

# Switch to steam user
USER ${TF2_SERVER_USER}

# TF2 Server Environment Variables
ENV TF2_SERVER_IP=0.0.0.0
ENV TF2_PORT=27015
ENV TF2_SOURCE_PORT=27020
ENV TF2_CLIENT_PORT=27005
ENV TF2_MAX_PLAYERS=24
ENV TF2_DEFAULT_MAP=plr_hightower
ENV TF2_UPDATE_ON_START=1

RUN sed -i '/ip=/s/"\([^"]*\)"/"$TF2_SERVER_IP"/' ${TF2_SERVER_SCRIPT} && \
    sed -i '/port=/s/"\([^"]*\)"/"$TF2_PORT"/' ${TF2_SERVER_SCRIPT} && \
    sed -i '/sourcetvport=/s/"\([^"]*\)"/"$TF2_SOURCE_PORT"/' ${TF2_SERVER_SCRIPT} && \
    sed -i '/clientport=/s/"\([^"]*\)"/"$TF2_CLIENT_PORT"/' ${TF2_SERVER_SCRIPT} && \
    sed -i '/maxplayers=/s/"\([^"]*\)"/"$TF2_MAX_PLAYERS"/' ${TF2_SERVER_SCRIPT} && \
    sed -i '/defaultmap=/s/"\([^"]*\)"/"$TF2_DEFAULT_MAP"/' ${TF2_SERVER_SCRIPT} && \
    sed -i '/updateonstart=/s/"\([^"]*\)"/"$TF2_UPDATE_ON_START"/' ${TF2_SERVER_SCRIPT}

RUN ${TF2_SERVER_SCRIPT} auto-install

EXPOSE ${TF2_SOURCE_PORT}/udp ${TF2_SOURCE_PORT}/tcp ${TF2_PORT}/udp ${TF2_PORT}/tcp ${TF2_CLIENT_PORT}/udp ${TF2_CLIENT_PORT}/tcp

# entrypoint
ENTRYPOINT ["entrypoint.sh"]

# health check
HEALTHCHECK --interval=5m \
  CMD ${TF2_SERVER_SCRIPT} monitor || exit 1
