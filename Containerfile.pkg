ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/base:${FREEBSD_RELEASE}

LABEL org.opencontainers.image.title="Rust" \
    org.opencontainers.image.description="Language with a focus on memory safety and concurrency" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/rust" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/rust" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN pkg update && \
    pkg install rust && \
    pkg clean -a && \
    rm -rf /var/cache/pkg/* /var/db/pkg/repos/*
