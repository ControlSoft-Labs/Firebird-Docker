FROM debian:buster-slim

LABEL maintainer="patrick@controlsoft.com.br"
LABEL version="3.0.4.33054"
LABEL vendor="ControlSoft Sistemas"
LABEL release-date="2020-09-25"

ENV FBURL=https://github.com/FirebirdSQL/firebird/releases/download/R3_0_4/Firebird-3.0.4.33054-0.amd64.tar.gz
ENV DEBIAN_FRONTEND noninteractive
ENV FBPATH=/opt/firebird
ENV FBBIN=/opt/firebird/bin
ENV PATH="$FBBIN:$PATH"

COPY build.sh ./build.sh

RUN apt-get update && apt-get install -qy --no-install-recommends \
    libtommath1 \
    libicu63 \
    procps \
    wget \
    ca-certificates \
    libicu-dev \
    libncurses-dev \
    libncurses5 \
    libtommath-dev \
    netbase \
    netcat && \
    ln -sf /usr/lib/x86_64-linux-gnu/libtommath.so.1 /usr/lib/x86_64-linux-gnu/libtommath.so.0 && \
    chmod +x ./build.sh && \
    sync && \
    ./build.sh && \
    rm -f ./build.sh && \
    apt-get remove --purge -y \
    wget \
    ca-certificates \
    libicu-dev \
    libncurses-dev \
    libtommath-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/databases"]

EXPOSE 3050/tcp
EXPOSE 3051/tcp

COPY docker-entrypoint.sh ${FBPATH}/docker-entrypoint.sh
COPY docker-healthcheck.sh ${FBPATH}/docker-healthcheck.sh

RUN chmod +x ${FBPATH}/docker-entrypoint.sh
RUN chmod +x ${FBPATH}/docker-healthcheck.sh

HEALTHCHECK CMD ${FBPATH}/docker-healthcheck.sh || exit 1

ENTRYPOINT ["/opt/firebird/docker-entrypoint.sh"]

CMD ["fbguard"]
