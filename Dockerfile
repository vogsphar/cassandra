FROM cassandra:3
RUN apt-get update && apt-get install -y wget
RUN wget -qO- https://github.com/vogsphar/logback-gelf/archive/v1.1.0-compiled.tar.gz | tar xvz --strip-components=2 -C /usr/share/cassandra/lib logback-gelf-1.1.0-compiled/rel/logback-gelf-1.1.0.jar
COPY cassandra.yaml /etc/cassandra/cassandra.yaml 
COPY create.cert /usr/bin
COPY create.cluster.config /usr/bin
COPY create.cluster.config.and.cert /usr/bin
COPY logback.xml /etc/cassandra/logback.xml
RUN tar czf /etc/cassandra.defaults.tgz -C /etc cassandra
