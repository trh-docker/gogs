FROM quay.io/spivegin/golangnodesj AS dev-build
WORKDIR /opt/src/src/github.com/gogs/
ADD Makefile /opt/Makefile
RUN apt-get update && apt-get install -y zip
RUN git clone https://github.com/gogs/gogs.git &&\
    cd gogs && cp /opt/Makefile . &&\
    npm install -g less &&\
    make release

FROM debian:stretch-slim

RUN useradd tealzead && echo tealzead:kfuet013SqVpvuhIw98l | chpasswd
    # PUID=${PUID:-1000} && PGID=${PGID:-1000} &&\
    # groupmod -o -g "$PGID" git && usermod -o -u "$PUID" git
WORKDIR /opt/gogs
COPY --from=dev-build /opt/src/src/github.com/gogs/gogs/release /opt
RUN mkdir -p /opt/bin/
ADD entry.sh /opt/bin/
RUN rm /opt/*.zip &&\
    apt update && apt install -y git &&\
    chown -R tealzead:tealzead /opt/gogs &&\
    mkdir /home/tealzead && chown -R tealzead /home/tealzead &&\
    apt-get autoremove &&\
    apt-get autoclean &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
USER tealzead
CMD ["entry.sh"]