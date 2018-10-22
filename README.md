This a standard cassandra image with some additinal scripts to set up an encrypted cluster.

# Installation 

1. create certificate and config directories
```
    # set $CASSANDRA_SEED to name of first cassandra host 
    # set $CLUSTER_NAME to some string
    # set $PASSWORD to a string of at least 6 characters
    docker run --rm \
    -v /srv/CASSANDRA_CONFIG:/etc/cassandra \
    -v /srv/CERT:/cert \
    -e PASSWORD=$PASSWORD \
    -e CLUSTER_NAME=$CLUSTER_NAME \
    vogsphar/cassandra create.cluster.config.and.cert
```
2. copy the created directories to all nodes
```
    # i.e.
    scp -r /srv/CASSANDRA_CONFIG /srv/CERT NODE_1..n:/srv
```
3. start cassandra at each node
```
    # set $CASSANDRA_SEED to name of first cassandra node
    # set $CASSANDRA_NODE to IP address of this node

    docker run -d --restart=always \
        -e CASSANDRA_SEEDS=$CASSANDRA_SEED \
        -e CASSANDRA_BROADCAST_ADDRESS=$CASSANDRA_NODE \
        -p $CASSANDRA_NODE:7001:7001 \
        -p $CASSANDRA_NODE:9042:9042 \
        -v /srv/CASSANDRA_CONFIG:/etc/cassandra \
        -v /srv/CERT:/cert \
        -v /srv/CASSANDRA_DATA:/var/lib/cassandra \
        --name cassandra \
        vogsphar/cassandra
```


# Additional Information
## check status
1. log into any cassandra node
2. ```docker exec -i cassandra nodetool status```

## cqlsh setup
1. create file /srv/CERT/cqlshrc and replace CASSANDRA_SEED
```
[connection]
hostname = CASSANRA_SEED
port = 9042
factory = cqlshlib.ssl.ssl_transport_factory
ssl = true

[ssl]
certfile = /cert/CLIENT.cer.pem
userkey = /cert/CLIENT.key.pem
usercert = /cert/CLIENT.cer.pem
```
2. ```docker run --rm  -it -v /srv/CERT/:/cert cassandra cqlsh --cqlshrc=/cert/cqlshrc -e 'describe keyspaces' ```

## directories
```
/srv/CASSANDRA_CONFIG  # cassandra configuration, same on all nodes
/srv/CERT              # certificates           , same on all nodes

/srv/CASSANDRA_DATA    # node specific data storage, use local SSD
```