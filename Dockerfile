FROM frolvlad/alpine-glibc AS build

LABEL version="0.1"
LABEL maintainer="Tiago Machado <gar0t0@gmail.com>"

RUN apk update \
 && apk add bash \
        openssh-client \
        git \
        curl \
        nmap

COPY utils/build.sh /tmp/
RUN chmod +x /tmp/build.sh && /tmp/build.sh
RUN rm -f /tmp/build.sh