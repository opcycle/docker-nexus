FROM opcycle/openjdk:8

ENV NEXUS_USER="nexus" \
    NEXUS_UID="8983" \
    NEXUS_GROUP="nexus" \
    NEXUS_GID="8983" \
    NEXUS_DIST_URL="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"

RUN groupadd -r --gid "$NEXUS_GID" "$NEXUS_GROUP"
RUN useradd -r --uid "$NEXUS_UID" --gid "$NEXUS_GID" "$NEXUS_USER"
RUN curl -L $NEXUS_DIST_URL --output /tmp/nexus.tar.gz

RUN tar -C /tmp --extract --file /tmp/nexus.tar.gz
RUN rm /tmp/nexus.tar.gz
RUN mv /tmp/nexus-* /opt/nexus 
RUN rm -rf /opt/nexus/bin /opt/nexus/*.txt /opt/nexus/.install4j /tmp/*

COPY nexus /opt/nexus
RUN chmod +x /opt/nexus/nexus
RUN mkdir -p /opt/nexus/data
RUN chown nexus:nexus -R /opt/nexus

VOLUME /opt/nexus/data
WORKDIR /opt/nexus
USER $NEXUS_USER

ENTRYPOINT ["/opt/nexus/nexus"]