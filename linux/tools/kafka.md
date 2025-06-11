# Apache Kafa

## Logging with Apache Kafka

### About Kafka
Put simply, Kafka is a logging tool that uses an event bus (or "message queue") to 
store and expose messages.  

It's a distributed event-streaming platform, and is specifically designed for
creating high throughput data pipelines.  

Kafka is known to be scalable. It acts as middleware between log producers and log
ingesters. Kafka can ingest logs from various sources (applications, servers,
databases, etc.) and process them, store them, and analyze them in real time.  

Kafka is typically run on a dedicated VM or hardware.  

---

Kafka is a message broker that works with a message queue (or event bus).  

The message broker is not limited to just logs -- it can queue any sort of information.  


### Setting up Kafka
You can set up a Kafka server and write to it using the `kafkacat` tool (invoked 
as `kcat`).  

You can set up Kafka logs to be picked up by Promtail and sent to Loki.  
It can also be integrated with other monitoring stacks.  

TODO: Finish this section on setting up kafka


## Setting up Kafka (K8s Deployment)

Here we're going to set up kafka in a Kubernetes cluster.  

---

Create a namespace for kafka.  
```bash
kubectl create ns kafka
# Verify
kubctl get all -n kafka
```

Create a zookeeper deployment (ZooKeeper is a distributed coordination service)

Have a `zookeeper.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: zookeeper-service
  name: zookeeper-service
  namespace: kafka
spec:
  type: NodePort
  ports:
    - name: zookeeper-port
      port: 2181
      nodePort: 30900
      targetPort: 2181
  selector:
    app: zookeeper
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: zookeeper
  name: zookeeper
  namespace: kafka
spec:
  replicas: 1
  selector:
    matchLabels:
      app: zookeeper
  template:
    metadata:
      labels:
        app: zookeeper
    spec:
      containers:
      - image: zookeeper
        imagePullPolicy: IfNotPresent
        name: zookeeper
        ports:
        - containerPort: 2181
```

- Zookeeper is a coordination service used by kafka to elect a controller broker
  among kafka nodes, store metadata, and manage distributed locks and heartbeats.  

- As of Kafka 2.8, you can run **KRaft** mode (Kafka without Zookeeper), using
  Kafka's builtin metadata quorum system.  

- But many deployments (esp. those using `wurstmeister/kafka` images) still require Zookeeper.

Then run:
```bash
kubectl create -f zookeeper.yaml
# Verify
kubectl get all -n kafka
kubectl describe -n kafka svc zookeeper-service
```

Have a deployment, `kafka.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: kafka-broker
  name: kafka-service
  namespace: kafka
spec:
  type: NodePort
  ports:
    - name: zookeeper-port
      port: 9092
      nodePort: 31000
      targetPort: 9092
  selector:
    app: kafka-broker
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: kafka-broker
  name: kafka-broker
  namespace: kafka
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kafka-broker
  template:
    metadata:
      labels:
        app: kafka-broker
    spec:
      hostname: kafka-broker
      containers:
      - env:
        - name: KAFKA_BROKER_ID
          value: "1"
        - name: KAFKA_ZOOKEEPER_CONNECT
          value: zookeeper-service:2181
        - name: KAFKA_LISTENERS
          value: PLAINTEXT://:9092
        - name: KAFKA_ADVERTISED_LISTENERS
          value: PLAINTEXT://kafka-broker:9092
        image: wurstmeister/kafka
        imagePullPolicy: IfNotPresent
        name: kafka-broker
        ports:
        - containerPort: 9092
```

- This specifies a `kafka-broker` deployment available externally from port `31000`.  

- This uses zookeeper as its distribution service, rather than KRaft mode (Kafka 2.8+).  

Create the deployment from the yaml.  
```bash
kubectl create -f kafka.yaml
```

Verify that the service is pointed to the pod IP address as an endpoint.
```bash
kubectl describe svc kafka-service -n kafka
kubectl get pods -o wide -n kafka
```

Modify `/etc/hosts` to make sure the port is forwarded from localhost to port `9092`.  
```bash
kubectl port-forward $(kubectl get pods -n kafka | grep kafka | awk '{print $1}') 9092 -n kafka &
echo "127.0.0.1 localhost kafka-broker" >> /etc/hosts
```

---

### Writing to kafka

You'll need `kafkacat` to write to kafka.  
```bash
sudo apt-get install -y kafkacat
```

Send a message 
```bash
printf "Test message at: %s\n" "$(date)" | kcat -P -b node01:31000 -t System_Logs
```

- `node01:31000` is wherever your Kafka/Zookeeper node is. 
    - From our deployment, it's mapped to port `31000` on the `node01` node.  

Now **consume** that message from kafka.  
```bash
timeout 3 kcat -C -b node01:31000 -t System_Logs
```

So, `kcat` can be used to both produce *and* consume the logs.  

| Command                         | What it does              |
| ------------------------------- | ------------------------- |
| `kcat -P -b host:port -t topic` | Producer (send a message) |
| `kcat -C -b host:port -t topic` | Consumer (read a message) |
| `-b`                            | Specify broker `host:port`|
| `-t`                            | Specify topic name (tag)  |


### Scrape Kafka with Promtail

You can scrape Kafka logs just like any other logs using Promtail (or alloy, or any
other log collector).  
A promtail config for scraping kafka:  
```yaml
- job_name: kafka
  kafka:
    brokers:
      - node01:31000
    topics:
      - System_Logs
    labels:
      job: kafka
```

Then restart promtail to load the new config.  
```bash
sudo systemctl restart promtail
```


## KRaft Mode

KRaft (Kafka Raft Metadata) mode is a Kafka mode available in Kafka 2.8+ (stable in
Kafka 3.4+) that eliminates the need for Zookeeper.  

It uses Kafka's own Raft quorum for controller election, metadata replication, and
cluster management.  


### Using Kafka in KRaft Mode

Here we'll use a regular VM, with:

- one Kafka broker running in KRaft mode 
- a local data dir for logs and metadata
- a config file customized for KRaft
- a way to test producing and consuming messages (e.g., shell scripts)

1. Download Kafka, 3.4+ for stable KRaft mode
   ```bash
   mkdir ~/kafka && cd ~/kafka
   curl -LO https://dlcdn.apache.org/kafka/3.9.1/kafka-3.9.1-src.tgz
   tar -xzvf ./kafka_2.13-3.6.0.tgz
   cd ./kafka_2.13-3.6.0
   ```

2. Create the data directory
   ```bash
   mkdir -p /tmp/kraft-combined-logs
   ```

3. Create the cluster UUID
   ```bash
   ./bin/kafka-storage.sh random-uuid
   ```
    * Save this output
      ```bash
      CLUSTER_ID="the-cluster-id"
      ```

4. Format the storage directory.  
   ```bash
   ./bin/kafka-storage.sh format -t "$CLUSTER_ID" -c config/kraft/server.properties
   ```

5. Configure Kafka for KRaft mode.  
    - Edit `config/kraft/server.properties` with a custom configuration. The minimal
      config for KRaft:
     ```ini
     # KRaft mode
     process.roles=broker,controller
     node.id=1
     controller.quorum.voters=1@localhost:9093

     # Listeners
     listeners=PLAINTEXT://:9092,CONTROLLER://:9093
     adverised.listeners=PLAINTEXT://localhost:9092
     listener.security.protocol.map-CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT

     # Log dirs (combined metadata and topic logs)
     log.digs=/tmp/kraft-combined-logs

     # Required for KRaft
     inter.broker.listener.name=PLAINTEXT
     ```

6. Start the Kafka broker with the `kafka-server-start.sh` script, passing it the
   config file as an argument.  
   ```bash
   ./bin/kafka-server-start.sh config/kraft/server.properties
   ```

7. Test
   ```bash
   # Create a topic
   ./bin/kafka-topics.sh --create \
        --topic test-topic \
        --bootstrap-server localhost:9092 \
        --partitions 1 \
        --replication-factor 1

   # List topics
   ./bin/kafka-topics.sh --list --bootstrap-server localhost:9092

   # Produce messages
   ./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test-topic

   # Consume messages
   ./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test-topic --from-beginning
   ```

### Kafka Resources
- <https://www.redpanda.com/guides/kafka-use-cases-log-aggregation>
- <https://www.crowdstrike.com/en-us/guides/kafka-logging/>
- <https://killercoda.com/het-tanis/course/Linux-Labs/108-kafka-to-loki-logging>
* <https://killercoda.com/het-tanis/course/Kubernetes-Labs/Kafka-deployment-in-kubernetes>

## Misc/Others

* Securonix
* BMC
* MQSeries

