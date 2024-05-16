FROM debian:buster as BUILDER

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        unzip \
        wget \
        ca-certificates

RUN mkdir -p /var/www
RUN cd /var/www && \
    wget -O EasyEDA-Router-latest.zip 'https://image.easyeda.com/files/EasyEDA-Router-latest.zip'
RUN cd /var/www && \
    unzip EasyEDA-Router-latest.zip

RUN sed -i s^127.0.0.1^0.0.0.0^g /var/www/config/local/main.json

RUN chmod +x /var/www/lin64.sh

RUN rm -f /var/www/EasyEDA-Router-latest.zip

####
FROM debian:buster
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        default-jre \
        && rm -rf /var/lib/apt/lists/*

COPY --from=BUILDER /var/www/ /var/www/

WORKDIR /var/www
CMD ["/var/www/lin64.sh"]
