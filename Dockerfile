FROM quay.io/spivegin/golangnodesj AS dev-build
WORKDIR /opt/src/src/github.com/gogs/
ADD Makefile /opt/Makefile
RUN apt-get update && apt-get install -y zip libpam0g-dev
# git clone https://github.com/gogs/gogs.git &&\
RUN go get -u -tags "sqlite pam cert" github.com/gogs/gogs &&\
    cd gogs && cp /opt/Makefile . &&\
    npm install -g less &&\
    make release
    
FROM debian:stretch-slim
COPY --from=dev-build /opt/src/src/github.com/gogs/gogs/release /opt/