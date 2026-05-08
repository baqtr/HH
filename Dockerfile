# Heroku container image for an authorized XMR worker dyno.
# Uses linux/amd64 static XMRig build suitable for Heroku's container runtime.
FROM debian:bookworm-slim

ARG XMRIG_VERSION=6.26.0
ENV DEBIAN_FRONTEND=noninteractive
ENV XMR_POOL=pool.supportxmr.com:3333
ENV WORKER_NAME=heroku-afdaa-1
ENV XMR_THREADS=2

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl tar tini procps \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    curl -L --retry 5 --retry-delay 3 -o /tmp/xmrig.tgz \
      "https://github.com/xmrig/xmrig/releases/download/v${XMRIG_VERSION}/xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz"; \
    mkdir -p /opt/xmrig; \
    tar -xzf /tmp/xmrig.tgz -C /opt/xmrig --strip-components=1; \
    chmod +x /opt/xmrig/xmrig; \
    rm -f /tmp/xmrig.tgz

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/app/start.sh"]
