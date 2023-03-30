FROM golang:1.20.2-bullseye@sha256:cb95e56313475447c4f1ba5262ddd7c6ba2c66cdb62c0c699001e8fa1755480f as builder

# renovate: datasource=github-releases depName=ProtonMail/proton-bridge
ARG PROTONBRIDGE_VERSION=3.0.21

RUN apt-get update && \
    apt-get install -y git gcc make libsecret-1-dev libprotobuf-dev && \
    git clone https://github.com/ProtonMail/proton-bridge.git && \
    # git clone https://github.com/ProtonMail/proton-bridge.git --branch=${PROTONBRIDGE_VERSION} && \
    cd proton-bridge || exit && \
    make build-nogui && \
    pwd

FROM ubuntu:jammy@sha256:67211c14fa74f070d27cc59d69a7fa9aeff8e28ea118ef3babc295a0428a6d21 as remaker

WORKDIR /remaker

# renovate: datasource=github-releases depName=ProtonMail/proton-bridge
ARG PROTONBRIDGE_VERSION=3.0.21

COPY deb_remaker.sh /remaker/
COPY --from=builder /go/proton-bridge/bridge /remaker/

RUN apt-get update && \
    bash deb_remaker.sh ${PROTONBRIDGE_VERSION} && \
    pwd

FROM ubuntu:jammy@sha256:67211c14fa74f070d27cc59d69a7fa9aeff8e28ea118ef3babc295a0428a6d21
LABEL maintainer="Xiaonan Shen <s@sxn.dev>"

# renovate: datasource=github-releases depName=ProtonMail/proton-bridge
ARG PROTONBRIDGE_VERSION=3.0.21

EXPOSE 25/tcp
EXPOSE 143/tcp

WORKDIR /protonmail

# Copy bash scripts
COPY --from=remaker remaker/deb/protonmail-bridge_${PROTONBRIDGE_VERSION}.deb /protonmail/
COPY gpgparams install.sh entrypoint.sh /protonmail/

# Install dependencies and protonmail bridge
RUN bash install.sh ${PROTONBRIDGE_VERSION}

ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
