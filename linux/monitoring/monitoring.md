# Monitoring in Linux

There are a lot of ways to monitor Linux systems.  
Manual inspection of system resource usage and logs is valid for one or two systems, but tedious and not valid at scale.  
This is why monitoring tools exist.  



## Table of Contents
* [Monitoring Tools for Linux Systems](#monitoring-tools-for-linux-systems) 
    * [Aggregating data](#aggregating-data) 
    * [Storing data (Time Series Database)](#storing-data-time-series-database) 
    * [Data visualization](#data-visualization) 
* [Grafana + Loki + Promtail Monitoring Stack](#grafana--loki--promtail-monitoring-stack) 
    * [Installing and Configuring Grafana](#installing-and-configuring-grafana) 
    * [Installing and Configuring Loki](#installing-and-configuring-loki) 
    * [Promtail Setup](#promtail-setup) 
    * [Linking Loki to Grafana](#linking-loki-to-grafana) 


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




