FROM quay.io/spivegin/golangnodesj AS dev-build
WORKDIR /opt/src/src/github.com/gogs/
ADD Makefile /opt/Makefile
# https://github.com/gogs/gogs/releases/download/v0.11.86/linux_amd64.zip 
# git clone https://github.com/gogs/gogs.git &&\
RUN apt-get update && apt-get install -y zip libpam0g-dev 

RUN go get -u -tags "sqlite pam cert" github.com/gogs/gogs &&\
    cd gogs && cp /opt/Makefile . &&\
    npm install -g less &&\
    go build -tags "sqlite pam cert" &&\
    make release

FROM debian:stretch-slim

COPY --from=dev-build /opt/src/src/github.com/gogs/gogs/release /opt
WORKDIR /opt/gogs
RUN mkdir -p /opt/bin/ 
ADD entry.sh /opt/bin/
RUN chmod +x /opt/bin/entry.sh &&\
    rm /opt/*.zip &&\
    apt update && apt install -y git &&\
    apt-get autoremove &&\
    apt-get autoclean &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
ENV USER=root RUN_USER=root
CMD ["/opt/bin/entry.sh"]