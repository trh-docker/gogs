FROM quay.io/spivegin/golangnodesj AS dev-build
WORKDIR /opt/src/src/github.com/gogs/
ADD Makefile /opt/Makefile
RUN apt-get update && apt-get install -y zip
RUN git clone https://github.com/gogs/gogs.git &&\
    cd gogs && cp /opt/Makefile . &&\
    npm install -g less &&\
    make release



FROM debian:stretch-slim
WORKDIR /opt/gogs
COPY --from=dev-build /opt/src/src/github.com/gogs/gogs/release /opt
RUN rm /opt/*.zip &&\
    useradd git && echo git:4rrYEGaasb0l9NNq2I1E | chpasswd &&\
    apt update && apt install -y git &&\
    PUID=${PUID:-1000} && PGID=${PGID:-1000} &&\
    groupmod -o -g "$PGID" git && usermod -o -u "$PUID" git &&\
    apt-get autoremove &&\
    apt-get autoclean &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

CMD [ "./gogs", "web"]