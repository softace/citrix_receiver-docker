FROM ubuntu:18.04
MAINTAINER Jarl Friis <jarl@softace.dk>

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y firefox

ENV ICA_CLIENT_VERSION "13.10.0.20_amd64"
COPY "icaclient_${ICA_CLIENT_VERSION}.deb" /tmp
RUN apt-get install -y xdg-utils libwebkitgtk-1.0-0 libxmu6 libxpm4 && \
    dpkg -i /tmp/icaclient_${ICA_CLIENT_VERSION}.deb && \
    rm /tmp/icaclient_${ICA_CLIENT_VERSION}.deb && \
    cd /opt/Citrix/ICAClient/keystore/cacerts/ && \
    ln -s /usr/share/ca-certificates/mozilla/* . && \
    c_rehash /opt/Citrix/ICAClient/keystore/cacerts/ && \
    xdg-mime default wfica.desktop application/x-ica

ARG UID
ARG GID
RUN export uid=${UID} gid=${GID} && \
    mkdir -p /home/ff_user && \
    echo "ff_user:x:${uid}:${gid}:Firefox user,,,:/home/ff_user:/bin/bash" >> /etc/passwd && \
    echo "ff_user:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/ff_user

USER ff_user
ENV HOME /home/ff_user
CMD /usr/bin/firefox -no-remote
