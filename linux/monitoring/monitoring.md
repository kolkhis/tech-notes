# Monitoring in Linux

There are a lot of ways to monitor Linux systems.  
Manual inspection of system resource usage and logs is valid for one or two systems, but tedious and not valid at scale.  
This is why monitoring tools exist.  

Most 3rd party tools will be installed in `/opt`.  
E.g., Install Loki in `/opt/loki` 


## Table of Contents
* [Monitoring Tools for Linux Systems](#monitoring-tools-for-linux-systems) 
    * [Aggregating data](#aggregating-data) 
    * [Storing data (Time Series Database)](#storing-data-time-series-database) 
    * [Data visualization](#data-visualization) 
    * [Real-time Monitoring and Alerts](#real-time-monitoring-and-alerts) 
    * [Cloud-Native Monitoring Tools](#cloud-native-monitoring-tools) 
    * [Tools Specialized for Logging](#tools-specialized-for-logging) 
* [Grafana + Loki + Promtail Monitoring Stack](#grafana--loki--promtail-monitoring-stack) 
    * [Installing and Configuring Grafana](#installing-and-configuring-grafana) 
    * [Installing and Configuring Loki](#installing-and-configuring-loki) 
    * [Promtail Setup](#promtail-setup) 
    * [Linking Loki to Grafana](#linking-loki-to-grafana) 
* [Grafana Dashboard Templates](#grafana-dashboard-templates) 
* [Installation of InfluxDB2](#installation-of-influxdb2) 
* [Telegraf Installation](#telegraf-installation) 


## Monitoring Tools for Linux Systems
Tons of monitoring tools exist out there.  

For both logs and system metrics

### Aggregating data
* `node_exporter`: Collects hardware and OS metrics (CPU, memory, disk usage, and network stats).  
* `loki`: Lightweight log aggregation tool, works well with Grafana to centralize and query logs.  
* `telegraf`: An agent for collecting, processing, and aggregating metrics and events.  
    * Supports many plugins for collecting metrics from services like MySQL, Docker, and Nginx. 
* `fluentd`: Log collector and processor.
    * Used to aggregate logs from different sources and send them to a central 
      location (like Loki or Elasticsearch).  
* `collectd`: Daemon for collecting system performance metrics.  
    * Can output to various destinations, incl RRD (Round Robin Database), InfluxDB,
      or Graphite.  


### Storing data (Time Series Database)
* `prometheus`: Popular TSDB focused on storing metrics scraped from exporters.  
    * Has a powerful query language (PromQL) for alerting and analysis.  
* `influxdb`: TSDB optimized for metrics and events.  
    * InfluxDB is often paired with `telegraf` for collecting and storing data.  
* `elasticsearch`: A search and analytics engine often used for storing and querying logs.  
    * Works well with tools like Kibana for log vizualization.  
* `opentsdb`: A scalable TSDB designed for high-throughput metrics storage.  


### Data visualization
* `grafana`: Highly customizable vizualization tool for displaying metrics and logs.  
    * Integrates with Prometheus, Loki, InfluxDB, Elasticserarch, and more tools.  
* `kibana`: Vizualization tool that works with Elasticsearch.  
    * Best for querying and analyzing log data.  
* `victoriametrics Dasboards`: Vizualization and analysis tool for time-series data stored in VictoriaMetrics.  
    * Similar functionality to Prometheus+Grafana.  

### Real-time Monitoring and Alerts
Real-time system and application monitoring:
* `nagios`: Classic tool for monitoring systems and infrastructure.
    * Provides real-time alerts based on thresholds. 
`zabbix`: Robust monitoring system for networks, servers, and applications.  
    * Inlucdes bultin alerting and vizualization tools.  
* `monit`: Lightweight monitoring and process management tool. 
    * Can automatically restart failing services.  
* `glances`: Terminal-based real-time system monitoring tools.  
    * Displays metrics like CPU, memory, and disk usage with a user-friendly interface.  
* `htop`: Interactive process viewer. Similar to `top` but more visual and user-friendly.  

### Cloud-Native Monitoring Tools
Specifically designed for containerized and distributed environments:  
* `promtail`: A log collection agent that works with Loki in cloud-native environments.  
* `cAdvisor`: Monitors container resource usage and performance. 
    * Often used with Docker and Kubernetes.  
* `kubectl top`: Part of the Kubernetes CLI.
    * Provides real-time resource usage metrics for pods and nodes.  
* `thanos`: Highly available, scalable, and long-term storage solution for Prometheus metrics.  

### Tools Specialized for Logging
Specifically for log aggregation, processing, and storage:
* `rsyslog`: A log collector and forwarder built into many Linux distros.  
    * Can send logs to remote servers or central aggregation systems.  
* `logstash`: Data processing pipeline for ingesting and enriching logs.  
    * Works with `Elasticsearch` and `Kibana` (ELK stack).  
* `journald`: System service for managing an querying logs on modern Linux systems. 
    * This is part of `systemd`, can be accessed with `journalctl`.  


## Grafana + Loki + Promtail Monitoring Stack
### Installing and Configuring Grafana
###### [Grafana docs for installation](https://grafana.com/docs/grafana/latest/setup-grafana/installation/)

* Install the required packages and the Grafana GPG key
  ```bash
  sudo apt-get install -y \
  apt-transport-https \
  software-properties-common \
  wget
  
  sudo wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
  ```

* Add the Grafana apt repository.
  ```bash
  echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com
  stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
  ```

* Now, install Grafana.
  ```bash
  sudo apt update && sudo apt install grafana-enterprise -y
  ```

---

* Make sure Grafana is started.
  ```bash
  sudo systemctl daemon-reload
  sudo systemctl start grafana-server
  sudo systemctl status grafana-server --no-pager
  ```

* Verify that the Grafana server is serving on port `3000` (which is the default).  
  ```bash
  systemctl status grafana-server --no-pager
  ss -ntulp 
  ss -ntulp | grep -i 'grafana'
  ss -ntulp | grep 3000
  ```

* Check that the external Web UI is available.
  Open a browser and go to the machine's IP on port `3000`.
  ```bash
  hostname -I | awk '{ print $1 }' # Get the IP if you don't know it
  ```
  Then go to `https://<your-ip>:3000`.  
  Once you're at the Web UI, login with the defaults (`admin` for both username and
  password), and change the password when prompted.  

---

### Installing and Configuring Loki

* Create a directory to install Loki
  ```bash
  mkdir /opt/loki && cd /opt/loki
  ```

* Download and unpackage a current version of loki (see the [Github releases](https://github.com/grafana/loki/releases)).  
  ```bash
  curl -L -O "https://github.com/grafana/loki/releases/download/v2.9.7/loki-linux-amd64.zip"
  unzip loki-linux-amd64.zip
  chmod a+x loki-linux-amd64
  ```

* Make a Loki config file in the directory `/opt/loki/loki-local-config.yaml`.  
    * See [local loki config file](./loki-promtail-grafana/loki-local-config-example.yaml).  
    * See the [loki.service file](./loki-promtail-grafana/example-loki.service) that should be at `/etc/systemd/system/loki.service`
    * Once the service file is there, do a `daemon-reload` and enable Loki.  
      ```bash
      sudo systemctl daemon-reload
      sudo systemctl enable loki --now
      # Verify
      sudo systemctl status loki 
      ps -ef | grep -i 'loki'
      ```
  
Loki's port is `3100`.  


### Promtail Setup
Configure Promtail to push logs from `/var/log/auth.log` and `/var/log/syslog` off the server to the Loki aggregator.

* Create the directory to install Promtail in.
  ```bash
  mkdir /opt/promatil && cd /opt/promtail
  ```

* Download and extract the Promtail executable (check the [releases](https://github.com/grafana/loki/releases))
  ```bash
  curl -L -O "https://github.com/grafana/loki/releases/download/v2.7.1/promtail-linux-amd64.zip"
  unzip promtail-linux-amd64.zip
  ```

* You'll also need a config file here `/opt/promtail/promtail-local-config.yaml`.  
    * See [example config](./loki-promtail-grafana/promtail-local-config-example.yaml).  
    * See the [promtail.service file](./loki-promtail-grafana/example-promtail.service) file that should be
      copied to `/etc/systemd/system/promtail.service`.  

* Once the service file is there, do a `daemon-reload` and start `promtail`.  
  ```bash
  sudo systemctl daemon-reload
  sudo systemctl enable promtail.service --now
  # Verify it's running
  systemctl status promtail.service --no-pager
  ps -ef | grep -i promtail
  ```

### Linking Loki to Grafana
Go to Grafana and create the data source for Loki in the the "Data source" page (Connections > Data sources).
Select Loki from the "sources", and enter the URL.  
The URL to put in to link Loki: `http://127.0.0.1:3100`
The actual numeric IP is usually preferred over `localhost`, just to be sure nothing happens if DNS doesn't resolve correctly.  


Create a dashboard (import -> enter ID 13639 for a Loki preset dashboard) that shows the log files for your server.


## Grafana Dashboard Templates
Grafana has dashboard templates that allow you to quickly set up a dashboard for a
service.  

Some template numbers:
* `159`: Prometheus template
* `13639`: Loki (log) template


## Installation of InfluxDB2

```bash
# Get the GPG key
wget -q https://repos.influxdata.com/influxdata-archive_compat.key

# Dearmor the key and save it to /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null

# Add the repo and use the key to sign for the repo
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list

# Install InfluxDB
sudo apt update && sudo apt-get install -y influxdb2

sudo systemctl start influxdb
sudo systemctl enable influxdb
```

InfluxDB listens on port `8086`
```bash
ss -ntulp | grep 8086
lsof -i :8086
```

Go to the web UI at `https://127.0.0.1:8086` and set up an account, organization, bucket, and copy the token that is given. It looks like a base64 encoded string.  

It'll look like:
```base64
bBInHhXJ8z6VOz4kbyr_mrvl25AWk__8HxzTkyGl33AMZlYXVp8kHui0SDhbLUC9w5aVJY_O3GY3pp6qaPSmXA==
```


## Telegraf Installation

```bash
# Get the key
wget -q https://repos.influxdata.com/influxdata-archive_compat.key

# Dearmor the key and save it in /etc/apt/trusted.gpg.d/influxdata-
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null

# Set up the repository
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list

# Install Telegraf
sudo apt update && sudo apt-get install -y telegraf
```

You need to set up the telegraf configuration file to write to the "output producer"
for `influxdb2`:
```bash
vi /etc/telegraf/telegraf.conf
```

Then add your token, bucket, and organization:
```conf
# # Configuration for sending metrics to InfluxDB 2.0
 [[outputs.influxdb_v2]]
#   ## The URLs of the InfluxDB cluster nodes.
#   ##
#   ## Multiple URLs can be specified for a single cluster, only ONE of the
#   ## urls will be written to each interval.
#   ##   ex: urls = ["https://us-west-2-1.aws.cloud2.influxdata.com"]
   urls = ["http://127.0.0.1:8086"]
#
#   ## Token for authentication.
   token = "bBInHhXJ8z6VOz4kbyr_mrvl25AWk__8HxzTkyGl33AMZlYXVp8kHui0SDhbLUC9w5aVJY_O3GY3pp6qaPSmXA=="
#
#   ## Organization is the name of the organization you wish to write to.
   organization = "killerkodalab"
#
#   ## Destination bucket to write into.
   bucket = "killerkodalab"
```

Make sure it's writing out to InfluxDB2:
```bash
systemctl restart telegraf
systemctl status telegraf --no-pager -l
```





