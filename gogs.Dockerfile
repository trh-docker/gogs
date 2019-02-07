FROM quay.io/spivegin/golangnodesj AS dev-build
WORKDIR /opt/src/src/github.com/gogs/
ADD Makefile /opt/Makefile
RUN apt-get update && apt-get install -y zip
RUN git clone https://github.com/gogs/gogs.git &&\
    cd gogs && cp /opt/Makefile . &&\
    npm install -g less &&\
    make release


FROM quay.io/spivegin/tlmbasedebian
WORKDIR /opt/gogs
COPY --from=dev-build /opt/src/src/github.com/gogs/gogs/release /opt/gogs/
RUN rm *.zip &&\
    apt-get autoremove &&\
    apt-get autoclean &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

CMD [ "./opt/gogs web"]