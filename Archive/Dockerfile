FROM golang:1.20.4-bullseye@sha256:918857f4064db0fff49799ce5e7c4d43e394f452111cd89cca9af539c18a76a8 as builder

# renovate: datasource=github-releases depName=ProtonMail/proton-bridge
ARG PROTONBRIDGE_VERSION=3.0.21

RUN apt-get update && \
    apt-get install -y git gcc make libsecret-1-dev libprotobuf-dev && \
    git clone https://github.com/ProtonMail/proton-bridge.git && \
    # git clone https://github.com/ProtonMail/proton-bridge.git --branch=${PROTONBRIDGE_VERSION} && \
    cd proton-bridge || exit && \
    make build-nogui && \
    pwd

FROM ubuntu:jammy@sha256:dfd64a3b4296d8c9b62aa3309984f8620b98d87e47492599ee20739e8eb54fbf as remaker

WORKDIR /remaker

# renovate: datasource=github-releases depName=ProtonMail/proton-bridge
ARG PROTONBRIDGE_VERSION=3.0.21

COPY deb_remaker.sh /remaker/
COPY --from=builder /go/proton-bridge/bridge /remaker/

RUN apt-get update && \
    bash deb_remaker.sh ${PROTONBRIDGE_VERSION} && \
    pwd

FROM ubuntu:jammy@sha256:dfd64a3b4296d8c9b62aa3309984f8620b98d87e47492599ee20739e8eb54fbf
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
