FROM ubuntu:22.04

LABEL org.opencontainers.image.description="KiCad 10 runtime for KiRI"
LABEL org.opencontainers.image.source="https://github.com/wang-edward/kiri-github-action"

ARG DEBIAN_FRONTEND=noninteractive
ARG KIRI_REF=main
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV KIRI_HOME=/opt/kiri
ENV PATH="/opt/kiri/bin:/opt/kiri/submodules/KiCad-Diff/bin:${PATH}"

# Only kicad-cli-based projects (KiCad 9/10) are supported. The legacy OCaml
# plotting path (plotgitsch) for pre-kicad-cli formats is intentionally
# excluded to keep the image maintainable.
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        ca-certificates \
        git \
        gpg-agent \
        imagemagick \
        librsvg2-bin \
        python-is-python3 \
        python3-pip \
        rename \
        software-properties-common \
        tzdata \
    && add-apt-repository -y ppa:kicad/kicad-10.0-releases \
    && apt-get update \
    && apt-get install --no-install-recommends -y kicad \
    && apt-get purge -y software-properties-common \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "$KIRI_REF" --recurse-submodules \
        https://github.com/leoheck/kiri.git "$KIRI_HOME" \
    && pip3 install --no-cache-dir \
        'pillow>8.2.0' \
        'six>=1.15.0' \
        'python_dateutil>=2.8.1' \
        'pytz>=2021.1'

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
