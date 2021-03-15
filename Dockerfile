FROM alpine AS build

LABEL version="0.2"
LABEL maintainer="Tiago Machado <gar0t0@gmail.com>"

RUN apk update \
 && apk add bash \
        openssh-client \
        git \
        curl \
        nmap \
        gcompat

COPY utils/build.sh /tmp/
RUN chmod +x /tmp/build.sh && /tmp/build.sh
RUN rm -f /tmp/build.sh
