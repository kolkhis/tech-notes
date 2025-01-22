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
    * [Resetting the admin Password for Grafana](#resetting-the-admin-password-for-grafana) 
* [Installing and Configuring Loki](#installing-and-configuring-loki) 
    * [Linking Loki to Grafana](#linking-loki-to-grafana) 
* [Setting up Promtail](#setting-up-promtail) 
* [Grafana Dashboard Templates](#grafana-dashboard-templates) 
* [Setting up InfluxDB2](#setting-up-influxdb2) 
* [Setting up Telegraf](#setting-up-telegraf) 
* [Setting up node_exporter](#setting-up-nodeexporter) 
    * [node_exporter `sysconfig` file](#nodeexporter-sysconfig-file) 
    * [node_exporter textfile_collector](#nodeexporter-textfilecollector) 
* [Setting up Prometheus](#setting-up-prometheus) 
* [Grafana Provisioning: Automatic Data Source and Dashboard Provisioning](#grafana-provisioning-automatic-data-source-and-dashboard-provisioning) 
    * [Grafana Data Source Provisioning](#grafana-data-source-provisioning) 
    * [Dashboard Provisioning](#dashboard-provisioning) 
        * [Changing Provisioned Dashboards](#changing-provisioned-dashboards) 
* [Resources](#resources) 


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

## Installing and Configuring Grafana  
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

Default port for Grafana is `3000`.

* Check that the external Web UI is available.  
  Open a browser and go to the machine's IP on port `3000`.  
  ```bash  
  hostname -I | awk '{ print $1 }' # Get the IP if you don't know it  
  ```
  Then go to `https://<your-ip>:3000`.  
  Once you're at the Web UI, login with the defaults (`admin` for both username and  
  password), and change the password when prompted.  

---  

### Resetting the admin Password for Grafana  
In case you screw up and lock yourself out of the Grafana server:  
```bash  
sudo grafana-cli admin reset-admin-password admin  
```
This resets the `admin` user account's password to `admin` (the default).  


## Installing and Configuring Loki  

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
    * See [local loki config file](./configuration_and_service_files/loki-local-config-example.yaml).  
    * See the [loki.service file](./configuration_and_service_files/example-loki.service) that should be at `/etc/systemd/system/loki.service`
    * Once the service file is there, do a `daemon-reload` and enable Loki.  
      ```bash  
      sudo systemctl daemon-reload  
      sudo systemctl enable loki --now  
      # Verify  
      sudo systemctl status loki 
      ps -ef | grep -i 'loki'  
      ```

Default port for Loki is `3100`.  

### Linking Loki to Grafana  
Go to Grafana and create the data source for Loki in the the "Data source" page (Connections > Data sources).  
Select Loki from the "sources", and enter the URL.  
The URL to put in to link Loki: `http://127.0.0.1:3100`
The actual numeric IP is usually preferred over `localhost`, just to be sure nothing happens if DNS doesn't resolve correctly.  


Create a dashboard (import -> enter ID 13639 for a Loki preset dashboard) that shows the log files for your server.  


## Setting up Promtail 
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
    * See [example config](./configuration_and_service_files/promtail-local-config-example.yaml).  
    * See the [promtail.service file](./configuration_and_service_files/example-promtail.service) file that should be  
      copied to `/etc/systemd/system/promtail.service`.  

* Once the service file is there, do a `daemon-reload` and start `promtail`.  
  ```bash  
  sudo systemctl daemon-reload  
  sudo systemctl enable promtail.service --now  
  # Verify it's running  
  systemctl status promtail.service --no-pager  
  ps -ef | grep -i promtail  
  ```




## Grafana Dashboard Templates  
Grafana has dashboard templates that allow you to quickly set up a dashboard for a  
service.  

Some template numbers:  
* `159`: Prometheus template  
* `13639`: Loki (log) template  


## Setting up InfluxDB2

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

Default port for `InfluxDB2` is `8086`.  

## Setting up Telegraf 
Telegraf is a very versatile tool that allows you to both collect data and send it places.  
Often paired with InfluxDB.  
It has four main functions:  
* Input
* Output
* Process
* Aggregation

Telegraf can send its output to many different platforms: InfluxDB / Azure Monitor / Google Cloud PubSub / Cloudwatch / elasticsearch / graphite,  etc etc

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


## Setting up node_exporter  
To install `node_exporter`, download the tarball from the Github releases and  
extract it.  

* Make a directory for the installation, `/opt/node_exporter`
  ```bash  
  mkdir /opt/node_exporter  
  
  # Download into /opt/node_exporter  
  curl -sSL -o /opt/node_exporter/node_exporter-1.8.2.linux-amd64.tar.gz  \
  https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz  
  
  # Extract into /opt/node_exporter  
  tar -xvfz /opt/node_exporter/node_exporter-*.*-amd64.tar.gz -C /opt/node_exporter  
  ```
  


* Get the default configuration files using `git`:  
  ```bash  
  git clone https://github.com/prometheus/node_exporter.git /opt/node_exporter/node_exporter-1.8.2/config_files  
  # NOTE: You can't use wildcards in git clone. Use the exact version directory.  
  ```
* Copy some of the example files from this repo.  
    * Copy the unit files `node_exporter.service` and `node_exporter.socket` to the `systemd` directory.  
      ```bash  
      cp /opt/node_exporter/node_exporter-*.*-amd64/config_files/examples/systemd/node_exporter.service /etc/systemd/system/  
      cp /opt/node_exporter/node_exporter-*.*-amd64/config_files/examples/systemd/node_exporter.socket /etc/systemd/system/node_exporter.socket  
      ```
    * The files in `/etc/systemd/system` named `*.socket/*.service` are called `unit files`.  

* Copy the `node_exporter` binary to `/usr/sbin/`.  
  ```bash  
  cp node_exporter /usr/sbin/  
  ```

* OPTIONAL: Copy the `sysconfig.node_exporter` file into `/etc/sysconfig/` as `node_exporter`.  
  ```bash  
  cp /opt/node_exporter/node_exporter-*.*-amd64/config_files/examples/systemd/sysconfig.node_exporter /etc/sysconfig/node_exporter  
  ```
    * See [more about the sysconfig file](#node_exporter-sysconfig-file)  

* OPTIONAL: Create a directory named `/var/lib/node_exporter/textfile_collector`:  
  ```bash  
  mkdir -p /var/lib/node_exporter/textfile_collector  
  ```
    * See [more about the textfile_collector]  

* Create a user account for `node_exporter` and give it ownership of the `sysconfig` and the `textfile_collector`.  
  ```bash  
  useradd -s /sbin/nologin node_exporter  
  chown -R node_exporter:node_exporter /var/lib/node_exporter/textfile_collector /etc/sysconfig/node_exporter  
  ```

* Do a `daemon-reload` and enable `node_exporter`:  
  ```bash  
  systemctl daemon-reload  
  systemctl enable node_exporter.service --now  
  ```

* See if `node_exporter` is running and exposing the right port (`9100`):  
  ```bash  
  systemctl status node_exporter --no-pager  
  sleep 2
  curl http://localhost:9100/metrics  
  ```

Default port for `node_exporter` is `9100`.  

---  

### node_exporter `sysconfig` file  
If you don't need customized monitoring and the default is fine, you don't need  
this file.  
---  
This is a completely optional file.  
The `sysconfig` file is used to configure `node_exporter`.  
It allows you to enable/disable certain collectors, so you can control what metrics  
are collected.  

Instead of passing flags directly when starting `node_exporter`, you can store  
them in the `sysconfig` file, which the service manager (`systemd`) reads.  

For example, disable all collectors except CPU, Memory, and Filesystem collectors:  
```bash  
OPTIONS="--collector.cpu --collector.meminfo --collector.filesystem"  
```

---  
This file would be 
* `/etc/sysconfig/node_exporter` on RedHat family systems (RHEL/CentOS/Fedora)  
* `/etc/default/node_exporter` on Debian family systems (Debian/Ubuntu/Mint).  

This path can be changed in the `service` file if you want.  
In `/etc/systemd/system/node_exporter.service`:  
```ini  
EnvironmentFile=/etc/sysconfig/node_exporter  # RHEL  
EnvironmentFile=/etc/default/node_exporter    # Debian  
```

### node_exporter textfile_collector  
If you don't need customized monitoring and the default is fine, you don't need  
this file.  
---  
The `textfile_collector` is used to gather metrics that aren't natively supported  
by `node_exporter`.  

Like, if you generate metrics with cron jobs, scripts, or other programs, you can  
expose them using the `textfile_collector`.  

You'd place metric files in `/var/lib/node_exporter/textfile_collector`.  
A metric file should look like this:  
```plaintext  
# HELP my_custom_metric A custom metric for testing  
# TYPE my_custom_metric counter  
my_custom_metric 123
```
Then `node_exporter` will expose these metrics along with its standard metrics.  

## Setting up Prometheus  
Just like `node_exporter`, you also need to download and extract the tarball for Prometheus. 

* Create a directory for prometheus  
  ```bash  
  mkdir /var/lib/prometheus  
  ```

* Download and extract Prometheus.  
  ```bash  
  curl -o /tmp/prometheus-2.42.0-rc.0.linux-amd64.tar.gz \
      https://github.com/prometheus/prometheus/releases/download/v2.42.0-rc.0/prometheus-2.42.0-rc.0.linux-amd64.tar.gz  
  tar -xvfz /tmp/prometheus-2.42.0-rc.0.linux-amd64.tar.gz -C /var/lib/prometheus/ --strip-components=1  
  ```

* Copy the binary into `/usr/bin`
  ```bash  
  cp /var/lib/prometheus/prometheus /usr/bin/prometheus  
  ```

* Add a user account for Prometheus and give it the `/var/lib/prometheus` directory.  
  ```bash  
  useradd prometheus  
  chown -R prometheus:prometheus /var/lib/prometheus  
  ```

* Create a directory in `/etc` for prometheus configuration.  
  ```bash  
  mkdir /etc/prometheus  
  cp prometheus.yml /etc/prometheus/prometheus.yml  
  ```
    * See [example prometheus.yml file](./configuration_and_service_files/prometheus-config-example.yml)  

* Move the `prometheus.service` file into `/etc/systemd/system/`
  ```bash  
  cp prometheus.service /etc/systemd/system/prometheus.service  
  ```
    * see [example prometheus service file](./configuration_and_service_files/example-prometheus.service)  

* Do a `daemon-reload` and start the Prometheus service. 
  ```bash  
  systemctl daemon-reload  
  systemctl start prometheus  
  ```

* Make sure prometheus is running.  
  ```bash  
  systemctl status prometheus  
  ss -ntulp | grep 9090  
  ```

Default port for Prometheus is `9090`.  



## Grafana Provisioning: Automatic Data Source and Dashboard Provisioning  
Grafana supports provisioning data sources *and* dashboards through config files.  

These are `yaml` files that can be included in an Ansible playbook or placed manually  
in the Grafana server's configuration directory.  

These would go in `/etc/grafana/provisioning/datasources` (assuming your grafana  
config location is `/etc/grafana`).  

You can also provision plugins. 
And, if you want to, run multiple Grafana instances.  
[See the docs](https://grafana.com/docs/grafana/latest/administration/provisioning)  

### Grafana Data Source Provisioning  
Grafana provisioning directory: `/etc/grafana/provisioning/datasources/`
To provision `prometheus`, I could create a `prometheus.yaml` in this directory:  
```yaml  
# /etc/grafana/provisioning/datasources/prometheus.yaml  
apiVersion: 1  
datasources:  
  - name: Prometheus  
    type: prometheus  
    access: proxy  
    url: http://localhost:9090  
    isDefault: true  
    editable: false  
```

Below is a more robust example from the [Grafana docs](https://grafana.com/docs/grafana/latest/administration/provisioning/#example-data-source-configuration-file):  
```yaml  
# Configuration file version  
apiVersion: 1  

# List of data sources to delete from the database.  
deleteDatasources:  
  - name: Graphite  
    orgId: 1  

# Mark provisioned data sources for deletion if they are no longer in a provisioning file.  
# It takes no effect if data sources are already listed in the deleteDatasources section.  
prune: true  

# List of data sources to insert/update depending on what's  
# available in the database.  
datasources:  
  # <string, required> Sets the name you use to refer to  
  # the data source in panels and queries.  
  - name: Graphite  
    # <string, required> Sets the data source type.  
    type: graphite  
    # <string, required> Sets the access mode, either  
    # proxy or direct (Server or Browser in the UI).  
    # Some data sources are incompatible with any setting  
    # but proxy (Server).  
    access: proxy  
    # <int> Sets the organization id. Defaults to orgId 1.  
    orgId: 1  
    # <string> Sets a custom UID to reference this  
    # data source in other parts of the configuration.  
    # If not specified, Grafana generates one.  
    uid: my_unique_uid  
    # <string> Sets the data source's URL, including the port.  
    url: http://localhost:8080  
    # <string> Sets the database user, if necessary.  
    user:  
    # <string> Sets the database name, if necessary.  
    database:  
    # <bool> Enables basic authorization.  
    basicAuth:  
    # <string> Sets the basic authorization username.  
    basicAuthUser:  
    # <bool> Enables credential headers.  
    withCredentials:  
    # <bool> Toggles whether the data source is pre-selected for new panels. 
    # You can set only one default data source per organization.  
    isDefault:  
    # <map> Fields to convert to JSON and store in jsonData.  
    jsonData:  
      # <string> Defines the Graphite service's version.  
      graphiteVersion: '1.1'  
      # <bool> Enables TLS authentication using a client  
      # certificate configured in secureJsonData.  
      tlsAuth: true  
      # <bool> Enables TLS authentication using a CA  
      # certificate.  
      tlsAuthWithCACert: true  
    # <map> Fields to encrypt before storing in jsonData.  
    secureJsonData:  
      # <string> Defines the CA cert, client cert, and  
      # client key for encrypted authentication.  
      tlsCACert: '...'  
      tlsClientCert: '...'  
      tlsClientKey: '...'  
      # <string> Sets the database password, if necessary.  
      password:  
      # <string> Sets the basic authorization password.  
      basicAuthPassword:  
    # <int> Sets the version. Used to compare versions when  
    # updating. Ignored when creating a new data source.  
    version: 1  
    # <bool> Allows users to edit data sources from the  
    # Grafana UI.  
    editable: false  
```

### Dashboard Provisioning  
Create a provisioning file for dashboards, like:  
```bash
/etc/grafana/provisioning/dashboards/default.yaml  
```
This yaml file will have a `path` key that points to where the actual `json` files 
for the dashboards are stored.  
```yaml  
# /etc/grafana/provisioning/dashboards/default.yaml  
apiVersion: 1  
providers:  
  - name: 'default'  
    orgId: 1  
    folder: ''  
    type: file  
    options:  
      path: /var/lib/grafana/dashboards  
```

The dashboards themselves go in `/var/lib/grafana/dashboards/`, 
in `json` format (or wherever you specify the `path:`).  

More robust example from the [Grafana docs](https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards):  
```yaml  
apiVersion: 1  

providers:  
  # <string> an unique provider name. Required  
  - name: 'a unique provider name'  
    # <int> Org id. Default to 1  
    orgId: 1  
    # <string> name of the dashboard folder.  
    folder: ''  
    # <string> folder UID. will be automatically generated if not specified  
    folderUid: ''  
    # <string> provider type. Default to 'file'  
    type: file  
    # <bool> disable dashboard deletion  
    disableDeletion: false  
    # <int> how often Grafana will scan for changed dashboards  
    updateIntervalSeconds: 10  
    # <bool> allow updating provisioned dashboards from the UI  
    allowUiUpdates: false  
    options:  
      # <string, required> path to dashboard files on disk. Required when using the 'file' type  
      path: /var/lib/grafana/dashboards  
      # <bool> use folder names from filesystem to create folders in Grafana  
      foldersFromFilesStructure: true  
```

#### Changing Provisioned Dashboards  
NOTE: Any changes made to provisioned dashboards through the UI can't be saved back  
to the provisioning source (the `json` file that it is read from).  

If `allowUiUpdates` is set to `true` and you make a change to a provisioned  
dashboard, you can `Save` the dashboard and changes will persist to the Grafana  
database.  
This will not save changes to the original `json` file.  
But, if the dashboard is reloaded from the source then any changes will be overwritten.  


## Resources  

* [Github Promtail Release and Loki Release](https://github.com/grafana/loki/releases))  
* [Grafana Installation](https://grafana.com/docs/grafana/latest/setup-grafana/installation/)  
* [Grafana Dashboard Provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/#dashboards):  
* [Grafana Data Source Provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/#example-data-source-configuration-file):  
* [Grafana Alert Discord](https://grafana.com/docs/grafana/ltest/administration/provisioning/#alert-notification-discord)  
* [TLS Encryption with Prometheus](https://prometheus.io/docs/guides/tls-encryption/)
* [Prometheus Configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
* [Prometheus Basic Auth](https://prometheus.io/docs/guides/basic-auth/)
* [Prometheus File-based service discovery](https://prometheus.io/docs/guides/file-sd/)
    * [Configuring File-based Service Discovery](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#file_sd_config)
* [Prometheus Labels and relabel_configs](https://grafana.com/blog/2022/03/21/how-relabeling-in-prometheus-works/)
