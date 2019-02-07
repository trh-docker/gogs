FROM quay.io/spivegin/golangnodesj AS dev-build
WORKDIR /opt/src/src/github.com/gogs/
ADD Makefile /opt/Makefile
RUN apt update && apt install -y zip
RUN git clone https://github.com/gogs/gogs.git &&\
    cd gogs && cp /opt/Makefile . &&\
    npm install -g less &&\
    make release

FROM debian:slim
COPY --from=dev-build /opt/src/src/github.com/gogs/release /opt/release