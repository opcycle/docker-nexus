FROM opcycle/openjdk:8

LABEL maintainer="OpCycle <oss@opcycle.net>"
LABEL repository="https://github.com/opcycle/docker-nexus"

ENV NEXUS_USER="nexus" \
    NEXUS_UID="8983" \
    NEXUS_GROUP="nexus" \
    NEXUS_GID="8983" \
    NEXUS_DIST_URL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"

RUN groupadd -r --gid "$NEXUS_GID" "$NEXUS_GROUP"
RUN useradd -r --uid "$NEXUS_UID" --gid "$NEXUS_GID" "$NEXUS_USER"
RUN curl -L $NEXUS_DIST_URL --output /tmp/nexus.tar.gz; \
    tar -C /tmp --extract --file /tmp/nexus.tar.gz; \
    rm /tmp/nexus.tar.gz; \
    mv /tmp/nexus-* /opt/nexus; \
    rm -rf /opt/nexus/bin /opt/nexus/*.txt /opt/nexus/.install4j /tmp/*; \
    mkdir -p /opt/nexus/data; \
    chown nexus:nexus -R /opt/nexus

COPY nexus /opt/nexus
RUN chmod +x /opt/nexus/nexus

VOLUME /opt/nexus/data
WORKDIR /opt/nexus
USER $NEXUS_USER

ENTRYPOINT ["/opt/nexus/nexus"]