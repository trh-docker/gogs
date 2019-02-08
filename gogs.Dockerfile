FROM quay.io/spivegin/golangnodesj AS dev-build
WORKDIR /opt/src/src/github.com/gogs/
ADD Makefile /opt/Makefile
# ADD https://github.com/gogs/gogs/releases/download/v0.11.86/linux_amd64.zip /opt/
RUN apt-get update && apt-get install -y zip libpam0g-dev 
# git clone https://github.com/gogs/gogs.git &&\

RUN go get -u -tags "sqlite pam cert" github.com/gogs/gogs &&\
    cd gogs && cp /opt/Makefile . &&\
    npm install -g less &&\
    make release
RUN cd /opt/ && unzip linux_amd64.zip

FROM debian:stretch-slim
# adduser --disabled-login --gecos 'Gogs' git
# RUN useradd tealzead && echo tealzead:kfuet013SqVpvuhIw98l | chpasswd
RUN adduser --disabled-login --gecos 'Gogs' tealzead
    # PUID=${PUID:-1000} && PGID=${PGID:-1000} &&\
    # groupmod -o -g "$PGID" git && usermod -o -u "$PUID" git
COPY --from=dev-build /opt/src/src/github.com/gogs/gogs/release /opt
# COPY --from=dev-build /opt/gogs /opt/
WORKDIR /opt/gogs
RUN mkdir -p /opt/bin/ 
ADD entry.sh /opt/bin/
RUN chmod +x /opt/bin/entry.sh && chown tealzead:tealzead /opt/bin/entry.sh &&\
    rm /opt/*.zip &&\
    apt update && apt install -y git &&\
    chown -R tealzead:tealzead /opt/gogs &&\
    apt-get autoremove &&\
    apt-get autoclean &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
USER tealzead
CMD ["/opt/bin/entry.sh"]