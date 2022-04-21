FROM ubuntu:20.04

LABEL maintainer="emil@jacero.se"

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
# Create build arguments with sane defaults
ARG PDNS_VERSION=16
# Adding POWERDNS_VERSION environment variable with the value from
# NOTE: DO NOT OVERWRITE THIS VARIABLE... EVER!
ENV POWERDNS_VERSION=$PDNS_VERSION
# Sane defaults
ENV LOG_LEVEL=INFO

RUN apt update && apt install -y ca-certificates curl wget gnupg2 jq dnsutils python3 python3-jinja2 && apt -y upgrade

RUN touch /etc/apt/sources.list.d/pdns.list && echo deb [arch=amd64] http://repo.powerdns.com/ubuntu focal-dnsdist-$PDNS_VERSION main >> /etc/apt/sources.list.d/pdns.list
RUN echo "Package: pdns-*" >> /etc/apt/preferences.d/pdns && \
    echo "Pin: origin repo.powerdns.com" >> /etc/apt/preferences.d/pdns && \
    echo "Pin-Priority: 600" >> /etc/apt/preferences.d/pdns
RUN wget -O- https://repo.powerdns.com/FD380FBB-pub.asc | apt-key add - && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install dnsdist

ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add src
ADD src /app
RUN chown -R 101:101 /app; chown -R 101:101 /etc/dnsdist

# USER 101:101
EXPOSE 53/tcp 53/udp 8000/tcp
WORKDIR /app
STOPSIGNAL SIGTERM
ENTRYPOINT /app/entrypoint.sh
