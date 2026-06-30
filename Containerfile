ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/base:${FREEBSD_RELEASE}

ARG NIGHTLY

LABEL org.opencontainers.image.title="Rust" \
    org.opencontainers.image.description="Language with a focus on memory safety and concurrency" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/rust" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/rust" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN pkg update && \
    if [ -z "${NIGHTLY}" ]; then pkg install rust; else pkg install rust-nightly; fi && \
    pkg clean -a && \
    rm -rf /var/cache/pkg/* /var/db/pkg/repos/*
