FROM cassandra
COPY create.cert /usr/bin
COPY create.cluster.config /usr/bin
COPY create.cluster.config.and.cert /usr/bin
COPY logback.xml /etc/cassandra/logback.xml
RUN tar czf /etc/cassandra.defaults.tgz -C /etc cassandra
ENTRYPOINT ["docker-entrypoint.sh"]
VOLUME /var/lib/cassandra
EXPOSE 7000 7001 7199 9042 9160
CMD ["cassandra", "-f"]
