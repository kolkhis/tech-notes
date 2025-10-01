# Exporter Service Ports

This is a list of exporters and the ports that they use.  

> Source: [Prometheus Wiki (full list with links)](https://github-wiki-see.page/m/prometheus/prometheus/wiki/Default-port-allocations).  

|  Port  | Protocol | Component
|--------|----------|----------
| `9090` | HTTP 	| Prometheus server
| `9091` | HTTP 	| Pushgateway
| `9092` | n/a 	    | UNALLOCATED (to avoid collision with Kafka)
| `9093` | HTTP 	| Alertmanager
| `9094` | ? 	    | Alertmanager clustering

Exporters starting at 9100:

|  Port  | Exporter
|--------|---------
| `9100` | Node exporter
| `9101` | HAProxy exporter (v2 has native support)
| `9102` | StatsD exporter: Metrics
| `9103` | Collectd exporter
| `9104` | MySQLd exporter
| `9105` | Mesos exporter
| `9106` | CloudWatch exporter
| `9107` | Consul exporter
| `9108` | Graphite exporter: Metrics
| `9109` | Graphite exporter: Ingestion
| `9110` | Blackbox exporter
| `9111` | Expvar exporter
| `9112` | promacct: pcap-based network traffic accounting
| `9113` | Nginx exporter [alternative]
| `9114` | Elasticsearch exporter
| `9115` | Blackbox exporter
| `9116` | SNMP exporter
| `9117` | Apache exporter
| `9118` | Jenkins exporter
| `9119` | BIND exporter
| `9120` | PowerDNS exporter
| `9121` | Redis exporter
| `9122` | InfluxDB exporter
| `9123` | RethinkDB exporter
| `9124` | FreeBSD sysctl exporter (documentation)
| `9125` | StatsD exporter: Ingestion
| `9126` | New Relic exporter
| `9126` | Dynatrace Exporter
| `9127` | PgBouncer exporter
| `9128` | Ceph exporter
| `9129` | HAProxy Log exporter
| `9130` | UniFi Poller and UniFi exporter (archived, use UniFi Poller or SNMP instead)
| `9131` | Varnish exporter
| `9132` | Airflow exporter
| `9133` | Fritz!Box exporter
| `9134` | ZFS exporter / ZFS exporter (pdf)
| `9135` | rTorrent exporter
| `9136` | Collins exporter
| `9137` | SiliconDust HDHomeRun exporter
| `9138` | Heka exporter
| `9139` | Azure SQL exporter
| `9140` | Mirth exporter
| `9141` | Zookeeper exporter
| `9141` | Ping Exporter
| `9142` | BIG-IP exporter
| `9143` | Cloudmonitor exporter
| `9144` | grok_exporter
| `9145` | Aerospike exporter
| `9146` | Icecast exporter
| `9147` | Nginx Request exporter
| `9148` | NATS exporter
| `9149` | Passenger exporter
| `9150` | Memcached exporter
| `9151` | Varnish Request exporter
| `9152` | Command runner exporter
| `9153` | CoreDNS
| `9154` | Postfix Exporter
| `9155` | vSphere Graphite
| `9156` | WebDriver Exporter
| `9157` | IBM MQ exporter
| `9158` | Pingdom Exporter
| `9159` | Syslogstash metrics
| `9160` | Apache Flink Exporter
| `9161` | Oracle DB Exporter
| `9162` | apcupsd exporter
| `9163` | zgres exporter
| `9164` | s6_exporter
| `9165` | AWS instance health exporter
| `9165` | Keepalived Exporter
| `9166` | Dovecot exporter
| `9167` | Unbound exporter
| `9168` | gitlab-monitor
| `9169` | Lustre exporter
| `9170` | Docker Hub Exporter
| `9171` | GitHub Exporter [alternative]
| `9172` | Script Exporter
| `9173` | Rancher Exporter
| `9174` | Docker-Cloud Exporter
| `9175` | Saltstack exporter
| `9176` | OpenVPN exporter
| `9177` | libvirt exporter
| `9178` | Stream exporter
| `9179` | Shield exporter
| `9180` | ScyllaDB exporter
| `9181` | Openstack Ceilometer exporter
| `9182` | Windows exporter (Formerly wmi_exporter)
| `9183` | Openstack exporter
| `9184` | Twitch exporter
| `9185` | Kafka topic exporter
| `9186` | Cloud Foundry Firehose exporter
| `9187` | PostgreSQL exporter
| `9188` | Crypto exporter
| `9189` | Hetzner Cloud CSI Driver (Nodes)
| `9190` | BOSH exporter
| `9191` | netflow exporter
| `9192` | ceph_exporter
| `9193` | Cloud Foundry exporter
| `9194` | BOSH TSDB exporter
| `9195` | MaxScale exporter
| `9196` | UPnP Internet Gateway Device exporter
| `9197` | Google's mtail log data extractor
| `9198` | Logstash exporter
| `9199` | Cloudflare exporter
| `9200` | UNALLOCATED (to avoid collision with Elasticsearch)
| `9201` | Remote storage bridge example code
| `9202` | Pacemaker exporter
| `9203` | Domain Exporter
| `9204` | PCSensor TEMPer exporter
| `9205` | Nextcloud exporter
| `9206` | Elasticsearch exporter (queries and cluster metrics)
| `9207` | MySQL exporter (queries)
| `9208` | Kafka Consumer Group exporter
| `9209` | FastNetMon Advanced exporter
| `9210` | Netatmo exporter
| `9211` | dnsbl-exporter
| `9212` | DigitalOcean Exporter
| `9213` | Custom Exporter
| `9214` | MQTT Blackbox Exporter
| `9215` | Prometheus Graphite Bridge
| `9216` | MongoDB Exporter
| `9217` | Consul agent exporter
| `9218` | promql-guard
| `9219` | SSL Certificate exporter
| `9220` | NetApp Trident exporter
| `9221` | Proxmox VE Exporter
| `9222` | AWS ECS exporter
| `9223` | BladePSGI exporter
| `9224` | fluentd exporter
| `9225` | mailexporter
| `9226` | allas
| `9227` | proc_exporter
| `9228` | Flussonic exporter
| `9229` | gitlab-workhorse
| `9230` | Network UPS Tools exporter
| `9231` | Solr exporter
| `9232` | Osquery exporter
| `9233` | mgmt exporter
| `9234` | mosquitto exporter
| `9235` | gitlab-pages exporter
| `9236` | gitlab gitaly exporter
| `9237` | SQL Exporter
| `9238` | uWSGI Exporter [alternative]
| `9239` | Surfboard Exporter
| `9240` | Tinyproxy exporter
| `9241` | ArangoDB Exporter
| `9242` | Ceph RADOSGW Usage Exporter
| `9243` | Chef Compliance exporter
| `9244` | Moby Container Exporter
| `9245` | Naemon / Nagios Exporter
| `9246` | SmartPi
| `9247` | Sphinx Exporter
| `9248` | FreeBSD gstat Exporter
| `9249` | Apache Flink Metrics Reporter
| `9250` | OpenTSDB Exporter
| `9251` | Sensu Exporter
| `9252` | GitLab Runner Exporter
| `9253` | PHP-FPM exporter 
| `9254` | Kafka Burrow exporter
| `9255` | Google Stackdriver exporter
| `9256` | Process exporter / td-agent exporter
| `9257` | S.M.A.R.T. exporter
| `9258` | Hello Sense Exporter
| `9259` | Azure Resources Exporter
| `9260` | Buildkite Exporter
| `9261` | Grafana exporter
| `9262` | Bloomsky exporter
| `9263` | VMWare Guest exporter
| `9264` | Nest exporter
| `9265` | Weather exporter
| `9266` | OpenHAB exporter
| `9267` | Nagios Livestatus Exporter
| `9268` | CrateDB remote remote read/write adapter
| `9269` | fluent-agent-lite exporter
| `9270` | Jmeter exporter
| `9271` | Pagespeed exporter
| `9272` | VMWare exporter
| `9273` | Telegraf prometheus_client
| `9274` | Kubernetes PersistentVolume Disk Usage Exporter
| `9275` | NRPE exporter
| `9276` | GitHubQL Exporter
| `9276` | Azure Monitor exporter
| `9277` | Mongo collection exporter
| `9278` | Crypto Miner exporter
| `9279` | InstaClustr Exporter
| `9280` | Citrix NetScaler Exporter
| `9281` | Fastd Exporter
| `9282` | FreeSWITCH Exporter (Rust)
| `9283` | Ceph ceph-mgr "prometheus" plugin
| `9284` | Gobetween
| `9285` | Database exporter (oracle/postgres/mssql/mysql sql queries)
| `9286` | VDO Compression and deduplication exporter
| `9287` | Ceph iSCSI Gateway Statistics
| `9288` | Elgato Key Light exporter
| `9288` | consrv
| `9289` | Lovoo's IPMI Exporter (to be run on the IPMI host itself)
| `9290` | SoundCloud's IPMI Exporter (querying IPMI externally, blackbox-exporter style)
| `9291` | IBM Z HMC Exporter
| `9292` | Netapp ONTAP API Exporter
| `9293` | Connection Status Exporter
| `9294` | MiFlora / Flower Care Exporter
| `9295` | Freifunk Exporter
| `9296` | ODBC Exporter
| `9297` | Machbase Exporter
| `9298` | Generic Exporter
| `9299` | Exporter Aggregator
| `9300` | UNALLOCATED (to avoid collision with Elasticsearch)
| `9301` | Squid Exporter
| `9302` | Faucet SDN Faucet Exporter
| `9303` | Faucet SDN Gauge Exporter
| `9304` | Logstash Exporter
| `9305` | go-ethereum Exporter
| `9306` | Kyototycoon Exporter
| `9307` | Audisto exporter
| `9308` | Kafka Exporter
| `9309` | Fluentd Exporter
| `9310` | Open vSwitch Exporter
| `9311` | IOTA Exporter
| `9312` | UNALLOCATED (to avoid collision with Sphinx search API)
| `9313` | Cloudprober Exporter
| `9314` | eris Exporter
| `9315` | Centrifugo Exporter
| `9316` | Tado Exporter
| `9317` | Tellstick Local Exporter
| `9318` | conntrack Exporter
| `9319` | FLEXlm Exporter
| `9320` | Consul Telemetry Exporter
| `9321` | Spring Boot Actuator Exporter
| `9322` | haproxy_abuser_exporter
| `9323` | Docker Prometheus Metrics under /metrics endpoint
| `9324` | Bird Routing Daemon Exporter
| `9325` | oVirt Exporter
| `9326` | JunOS Exporter
| `9327` | S3 Exporter
| `9328` | OpenLDAP syncrepl Exporter
| `9329` | CUPS Exporter
| `9330` | OpenLDAP Metrics Exporter
| `9331` | influx-spout Prometheus Metrics
| `9332` | Network Exporter
| `9333` | Vault PKI Exporter
| `9334` | Ejabberd exporter
| `9335` | nexsan exporter
| `9336` | Mediacom Internet Usage Exporter
| `9337` | mqttgateway
| `9338` | cAdvisor (Container Advisor) alternate port
| `9339` | AWS S3 Exporter
| `9340` | (Financial) Quotes Exporter
| `9341` | slurm exporter
| `9342` | FRR Exporter
| `9343` | GridServer Exporter
| `9344` | MQTT Exporter
| `9345` | Ruckus SmartZone Exporter
| `9346` | Ping Exporter
| `9347` | Junos Exporter
| `9348` | BigQuery Exporter
| `9349` | Configurable Elasticsearch query exporter
| `9350` | ThousandEyes Exporter
| `9351` | Wal-e/wal-g exporter
| `9352` | Nature Remo Exporter
| `9353` | Ceph Exporter
| `9354` | Deluge Exporter
| `9355` | Nightwatch.js Exporter / Redis Sentinel Exporter
| `9356` | Pacemaker Exporter
| `9357` | P1 Exporter
| `9358` | Performance Counters Exporter
| `9359` | Sidekiq Prometheus
| `9360` | PowerShell Exporter
| `9361` | Scaleway SD Exporter
| `9362` | Cisco Exporter
| `9363` | ClickHouse
| `9364` | Continent8 Exporter
| `9365` | Cumulus Linux Exporter
| `9366` | HAProxy Stick Table Exporter
| `9367` | teamspeak3_exporter
| `9368` | Ethereum Client Exporter
| `9369` | Prometheus PushProx
| `9370` | u-bmc
| `9371` | conntrack-stats-exporter
| `9372` | AppMetrics/Prometheus
| `9373` | GCP Service Discovery
| `9374` | "Smokeping" prober"
| `9375` | Particle Exporter
| `9376` | Falco
| `9377` | Cisco ACI Exporter
| `9378` | etcd gRPC Proxy Exporter
| `9379` | etcd Exporter
| `9380` | MythTV Exporter
| `9381` | Kafka ZooKeeper Exporter
| `9382` | FRRouting Exporter
| `9383` | AWS Health Exporter
| `9384` | AWS SQS Exporter
| `9385` | apcupsdexporter
| `9386` | httpd-exporter
| `9386` | Tankerkönig API Exporter
| `9387` | SABnzbd Exporter
| `9388` | Linode Exporter
| `9389` | Scylla-Cluster-Tests Exporter
| `9390` | Kannel Exporter
| `9391` | Concourse Prometheus Metrics
| `9392` | Generic Command Line Output Exporter
| `9393` | Patroni Exporter
| `9393` | Alertmanager Github Webhook Receiver
| `9394` | Ruby Prometheus Exporter
| `9395` | LDAP Exporter
| `9396` | Monerod Exporter
| `9397` | COMAP
| `9398` | Open Hardware Monitor Exporter
| `9399` | Prometheus SQL Exporter
| `9400` | RIPE Atlas Exporter
| `9401` | 1-Wire Exporter
| `9402` | Google Cloud Platform Exporter
| `9403` | Zerto Exporter
| `9404` | JMX Exporter
| `9405` | Discourse Exporter
| `9406` | HHVM Exporter
| `9407` | OBS Studio Exporter
| `9408` | RDS Enhanced Monitoring Exporter
| `9409` | ovn-kubernetes Master Exporter
| `9410` | ovn-kubernetes Node Exporter
| `9411` | SoftEther Exporter
| `9412` | Sentry Exporter
| `9413` | MogileFS Exporter
| `9414` | Homey Exporter
| `9415` | cloudwatch_read_adapter
| `9416` | HP iLO Metrics Exporter
| `9417` | Ethtool Exporter
| `9418` | Gearman Exporter
| `9419` | RabbitMQ Exporter
| `9420` | Couchbase Exporter
| `9421` | APIcast
| `9422` | jolokia_exporter
| `9423` | HP RAID Exporter, prometheus-smartraid-exporter
| `9424` | InfluxDB Stats Exporter
| `9425` | Pachyderm Exporter
| `9426` | Vespa engine exporter
| `9427` | Ping Exporter
| `9428` | SSH Exporter
| `9429` | Uptimerobot Exporter
| `9430` | CoreRAD
| `9431` | Hpfeeds broker Exporter
| `9432` | Windows perflib exporter
| `9433` | Knot exporter
| `9434` | OpenSIPS exporter
| `9435` | eBPF exporter
| `9436` | nshttpd/mikrotik-exporter, swoga/mikrotik-exporter
| `9437` | Dell EMC Isilon Exporter
| `9438` | Dell EMC ECS Exporter
| `9439` | Bitcoind exporter
| `9440` | RavenDB Exporter
| `9441` | Nomad Exporter
| `9442` | Mcrouter Exporter
| `9443` | Napalm Logs Exporter
| `9444` | FoundationDB Exporter
| `9445` | NVIDIA GPU Exporter
| `9446` | Orange Livebox DSL modem Exporter
| `9447` | Resque Exporter
| `9448` | EventStore Exporter
| `9449` | OMERO.server Exporter
| `9450` | Habitat Exporter
| `9451` | Reindexer Exporter
| `9452` | FreeBSD Jail Exporter
| `9453` | midonet-kubernetes
| `9454` | NVIDIA SMI Exporter
| `9455` | iptables Exporter
| `9456` | AWS Lambda Exporter
| `9457` | Files Content Exporter
| `9458` | Rocket.Chat Exporter
| `9459` | Yarn Exporter
| `9460` | HANA Exporter
| `9461` | AWS Lambda read adapter
| `9462` | PHP OPcache Exporter
| `9463` | Virgin Media/Liberty Global Hub3 Exporter
| `9464` | OpenTelemetry Node.js Prometheus Metric Exporter
| `9465` | Hetzner Cloud k8s Cloud Controller Manager
| `9466` | MQTT push gateway
| `9467` | nginx-prometheus-shiny-exporter
| `9468` | nasa-swpc-exporter
| `9469` | script_exporter
| `9470` | cachet_exporter
| `9471` | lxc-exporter
| `9472` | Hetzner Cloud CSI Driver (Controller)
| `9473` | stellar-core-exporter
| `9474` | libvirtd_exporter
| `9475` | wgipamd
| `9476` | immugw exporter
| `9476` | OVN Metrics Exporter
| `9477` | immuclient exporter
| `9477` | CSP Violation Report exporter
| `9478` | Sentinel exporter
| `9479` | Elasticbeat exporter (filebeat, metricbeat, packetbeat, etc...)
| `9480` | Brigade exporter
| `9481` | DRBD9 exporter
| `9482` | Vector Packet Process (VPP) exporter
| `9483` | IBM App Connect Enterprise exporter
| `9484` | kubedex-exporter
| `9485` | Emarsys exporter
| `9486` | Domoticz exporter
| `9487` | Docker Stats exporter
| `9488` | BMW Connected Drive exporter
| `9489` | Tezos node metrics exporter
| `9490` | Exporter for Docker Libnetwork Plugin for OVN
| `9491` | Docker Container Stats exporter (docker ps)
| `9492` | Azure Exporter (Monitor and Usage)
| `9493` | ProSAFE Exporter
| `9494` | Kamailio Exporter
| `9495` | Ingestor Exporter
| `9496` | 389ds/IPA Exporter
| `9497` | ImmuDB exporter
| `9498` | tp-link HS110 exporter
| `9499` | Smartthings exporter
| `9500` | Cassandra exporter
| `9501` | HetznerCloud exporter
| `9502` | Hetzner exporter
| `9503` | Scaleway exporter
| `9504` | GitHub exporter
| `9505` | DockerHub exporter
| `9506` | Jenkins exporter
| `9507` | ownCloud exporter
| `9508` | ccache exporter
| `9509` | Hetzner Storagebox exporter
| `9510` | Dummy Exporter
| `9511` | IIS Log Exporter
| `9512` | Cloudera exporter
| `9513` | OpenConfig Streaming Telemetry Exporter
| `9514` | App Stores exporter (Google Play & Itunes)
| `9515` | swarm-exporter
| `9516` | Prometheus Speedtest Exporter
| `9517` | Matroschka Prober
| `9518` | Crypto Stock Exchange's Funds Exporter
| `9519` | Acurite Exporter
| `9520` | Swift Health Exporter
| `9521` | Ruuvi exporter
| `9522` | TFTP Exporter
| `9523` | 3CX Exporter
| `9524` | loki_exporter
| `9525` | Alibaba Cloud Exporter
| `9526` | kafka_lag_exporter
| `9527` | Netgear Cable Modem Exporter
| `9528` | Total Connect Comfort Exporter
| `9528` | Prusalink Exporter
| `9529` | Octoprint exporter
| `9530` | Custom Prometheus Exporter
| `9531` | JFrog Artifactory Exporter
| `9532` | Snyk exporter
| `9533` | Network Exporter for Cisco API
| `9534` | Humio exporter
| `9535` | Cron Exporter
| `9536` | IPsec exporter
| `9537` | CRI-O
| `9538` | Bull Queue
| `9539` | Dedibox Exporter
| `9539` | ModemManager exporter
| `9540` | EMQ exporter
| `9541` | smartmon_exporter
| `9542` | SakuraCloud exporter
| `9543` | Kube2IAM exporter
| `9544` | pgio exporter
| `9545` | HP iLo4 Exporter
| `9546` | pwrstat-exporter
| `9547` | Patroni exporter / Kea Exporter
| `9548` | trafficserver exporter
| `9549` | raspberry exporter
| `9550` | rtl_433 exporter
| `9551` | hostapd exporter
| `9552` | Alpine apk exporter
| `9552` | AWS Elastic Beanstalk Exporter
| `9553` | Apt exporter
| `9554` | ACC Server Manager Exporter
| `9555` | SONA exporter
| `9556` | routinator exporter
| `9557` | mysql count exporter
| `9558` | systemd exporter
| `9559` | ntp exporter
| `9560` | SQL queries exporter
| `9561` | qBittorrent exporter
| `9562` | PTV xServer exporter
| `9563` | Kibana exporter
| `9564` | PurpleAir exporter
| `9565` | Bminer exporter
| `9566` | RabbitMQ CLI Consumer
| `9567` | Alertsnitch
| `9568` | Dell PowerEdge IPMI exporter
| `9569` | HVPA Controller
| `9570` | VPA Exporter
| `9571` | Helm Exporter
| `9572` | ctld exporter
| `9573` | JKStatus Exporter
| `9574` | opentracker Exporter
| `9575` | PowerAdmin Server Monitor Exporter
| `9576` | ExaBGP Exporter
| `9577` | Syslog-NG Exporter
| `9578` | aria2 Exporter
| `9579` | iPerf3 Exporter
| `9580` | Azure Service Bus Exporter
| `9581` | CodeNotary vcn Exporter
| `9582` | Logentries/Rapid7 Exporter
| `9583` | Signatory a remote operation signer for Tezos
| `9584` | BunnyCDN exporter
| `9585` | Opvizor Performance Analyzer process exporter
| `9586` | WireGuard exporter: Rust (wg(8)), Go (native)
| `9587` | nfs-ganesha exporter
| `9588` | ltsv-tailer exporter
| `9589` | goflow exporter
| `9590` | Flow Exporter
| `9591` | SRCDS Exporter
| `9592` | GCP Quota Exporter
| `9593` | Lighthouse Exporter
| `9594` | Plex Exporter
| `9595` | Netio Exporter
| `9596` | Azure Elastic SQL Exporter
| `9597` | GitHub Vulnerability Alerts Exporter
| `9598` | Vector Logs & Metrics Router Exporter
| `9599` | Pirograph Exporter, Liquidsoap
| `9600` | CircleCI Exporter
| `9601` | MessageBird Exporter
| `9602` | Modbus Exporter
| `9603` | Xen Exporter (using xenlight)
| `9604` | XMPP Blackbox Exporter
| `9605` | fping-exporter
| `9606` | ecr-exporter
| `9607` | Raspberry Pi Sense HAT Exporter
| `9608` | Ironic Prometheus Exporter
| `9609` | netapp exporter
| `9610` | kubernetes_exporter
| `9611` | speedport_exporter
| `9612` | GitHub Exporter
| `9613` | Azure Health Exporter
| `9614` | NUT upsc Exporter
| `9615` | Mellanox mlx5 Exporter
| `9616` | Mailgun Exporter
| `9617` | PI-Hole Exporter
| `9618` | stellar-account-exporter
| `9619` | stellar-horizon-exporter
| `9620` | rundeck_exporter
| `9621` | OpenNebula exporter
| `9622` | BMC exporter
| `9623` | TC4400 exporter
| `9624` | Pact Broker Exporter
| `9625` | Bareos Exporter
| `9626` | hockeypuck
| `9627` | Artifactory Exporter
| `9628` | Solace PubSub+ Exporter
| `9629` | Prometheus GitLab notifier
| `9630` | nftables exporter or FreeBSD pfctl Exporter
| `9631` | A OP5 Monitor exporter
| `9632` | Belkin Wemo Insight exporter (WIP) or certmonger exporter
| `9633` | smartctl exporter
| `9634` | Aerospike ttl exporter
| `9635` | Fail2Ban Exporter
| `9635` | PuppetDB Exporter
| `9636` | Exim4 Exporter
| `9637` | KubeVersion Exporter
| `9638` | A Icinga2 exporter
| `9639` | Tinkerforge Brickd Exporter
| `9639` | Scriptable JMX Exporter
| `9640` | Logstash Output Exporter
| `9641` | MQTT2Prometheus
| `9641` | CoTURN exporter
| `9642` | Bugsnag Exporter
| `9643` | Cisco ACI exporter
| `9644` | Exporter for grouped process
| `9645` | Burp exporter
| `9646` | Locust Exporter
| `9647` | Docker Exporter
| `9648` | NTPmon exporter
| `9649` | Logstash Exporter Logstash Pipeline Exporter
| `9650` | Keepalived Exporter
| `9651` | Storj Exporter
| `9652` | Praefect Exporter
| `9653` | Jira Issues Exporter
| `9654` | Kuryr-Kubernetes Controller
| `9654` | Ansible Galaxy Exporter
| `9655` | Kuryr-Kubernetes CNI
| `9655` | kube-netc Exporter
| `9656` | Matrix
| `9657` | Krill exporter
| `9658` | SAP Hana SQL Exporter
| `9659` | ECS task metadata exporter
| `9659` | Absent Metrics Operator
| `9660` | Kaiterra Laser Egg Exporter
| `9661` | Hashpipe Exporter
| `9662` | PMS5003 Particulate Matter Sensor Exporter
| `9663` | SAP NWRFC Exporter
| `9664` | Linux HA ClusterLabs exporter
| `9665` | Senderscore Exporter / Juniper Junos Exporter
| `9666` | Alertmanager Silences Exporter
| `9667` | SMTPD Exporter
| `9668` | SUSE's SAP HANA Exporter
| `9669` | panopticon native metrics
| `9670` | flare native metrics
| `9671` | AWS EC2 Spot Exporter
| `9672` | AirControl CO2 Exporter
| `9673` | CO2 Monitor Exporter
| `9674` | Google Analytics Exporter
| `9675` | Docker Swarm Exporter
| `9676` | Hetzner Traffic Exporter
| `9677` | AWS ECS Exporter
| `9678` | IRCd user exporter
| `9679` | AWS Health Exporter
| `9680` | SUSE's SAP Host Exporter
| `9681` | MyFitnessPal Exporter
| `9682` | Powder Monkey
| `9683` | Infiniband Exporter
| `9684` | Kibana Standalone Exporter
| `9685` | Eideticom NoLoad Metric Exporter
| `9686` | AWS EC2 Exporter
| `9687` | Gitaly Blackbox Exporter
| `9688` | BigBlueButton Exporter: Go, Python
| `9689` | LAN Server Modbus Exporter
| `9690` | TCP Longterm Connection Exporter
| `9691` | Celery/Redis Exporter
| `9692` | GCP GCE Exporter
| `9693` | Sigma Air Manager Exporter
| `9694` | Per-User usage Exporter for Cisco XE LNSs
| `9695` | CIFS Exporter
| `9696` | PagerDuty Exporter
| `9697` | Tendermint Blockchain Exporter
| `9698` | Integrated Dell Remote Access Controller (iDRAC) Exporter
| `9699` | Pyncette Exporter
| `9700` | Jitsi Meet Exporter
| `9701` | Workbook exporter
| `9702` | HomePlug PLC exporter
| `9703` | Vircadia
| `9704` | Linux TC exporter
| `9705` | UPC Connect Box Exporter
| `9706` | Postfix exporter
| `9706` | AWS EFA exporter
| `9707` | Radarr exporter
| `9708` | Sonarr exporter
| `9709` | float_exporter
| `9709` | Hadoop HDFS FSImage Exporter
| `9710` | fortigate_exporter as well as nut-exporter
| `9711` | Cloudflare Flan Scan report exporter
| `9712` | Siemens S7 PLC exporter
| `9713` | GlusterFS Exporter
| `9714` | Fritzbox exporter
| `9715` | TwinCAT ADS Web Service exporter
| `9716` | Signald webhook receiver
| `9717` | TPLink EasySmart Switch Exporter
| `9718` | Warp10 Exporter
| `9719` | Pgpool-II Exporter
| `9720` | Moodle DB Exporter
| `9721` | GTP Exporter
| `9722` | TfL Cycles Exporter
| `9723` | OpenVPN AAD Authenticator
| `9724` | FreeSWITCH Exporter
| `9725` | sunnyboy_exporter
| `9726` | Python RQ Exporter
| `9727` | CTDB Exporter
| `9728` | NGINX-RTMP Exporter
| `9729` | libvirtd_exporter
| `9730` | lynis_exporter
| `9731` | Nebula Exporter (unified exporter for broadcasters)
| `9732` | nftables_exporter
| `9733` | honeypot_exporter
| `9734` | A10-Networks Prometheus Exporter
| `9735` | WebWeaver
| `9736` | MongoDB Query Exporter
| `9737` | Folding@home Exporter
| `9738` | Processor Counter Monitor Exporter
| `9739` | Kafka Consumer Lag Monitoring
| `9740` | flightdeck
| `9741` | IBM Spectrum Exporter
| `9742` | Nature Remo E series Exporter
| `9742` | transmission-exporter
| `9743` | sma-exporter
| `9744` | NSX-T Exporter
| `9744` | Waveplus Radon Sensor Exporter
| `9745` | Cryptowat Exporter
| `9746` | LDAP_exporter.py
| `9746` | supercronic
| `9747` | TED5000 Energy monitor exporter
| `9747` | spectrum_virtualize_exporter
| `9747` | StatusPage Exporter
| `9748` | cloudstats_exporter
| `9749` | Maddy Mail Server metrics endpoint
| `9750` | c-lightning prometheus exporter
| `9751` | OpenRCT2 Prometheus Exporter
| `9752` | VMWare VC Exporter
| `9753` | Alertmanager Exporter
| `9754` | Libreswan IPsec Traffic Exporter
| `9755` | OpenWeatherMap Exporter 
| `9756` | GitHub API rate limit Exporter
| `9756` | sma-inverter-exporter
| `9757` | Intel® Optane™ PMCE Exporter (aka. IPMCTL Exporter)
| `9758` | SUSE Saptune exporter
| `9759` | AWS Subnet Exporter
| `9760` | VEEAM AHVProxy Exporter
| `9761` | SML Exporter
| `9762` | Neon Service Standard Exporter
| `9763` | Synology ActiveBackup Exporter
| `9764` | Mercure
| `9765` | SGX exporter
| `9766` | DockerHub Rate-Limit Exporter
| `9767` | FreeBSD RCTL Exporter
| `9768` | DockerHub Ratelimit Exporter
| `9769` | Altaro Backup Exporter
| `9770` | Hilink exporter, rsync.net exporter
| `9771` | Synology Backup Exporter
| `9772` | NJmon Exporter
| `9773` | Philips Hue Exporter
| `9773` | SHA Exporter
| `9774` | MP707 exporter
| `9775` | GitLab CI Server Exporter
| `9776` | alertmanager-filter
| `9777` | ufiber-exporter
| `9778` | Octopus Energy Exporter
| `9779` | Kubernetes Summary Exporter
| `9780` | Hitron CODA Cable Modem Exporter (or Sagemcom F@st Exporter)
| `9781` | TCP traceroute exporter
| `9782` | RabbitMQ cluster operator
| `9783` | ServerTech Exporter
| `9784` | Shelly Exporter
| `9785` | Pathvector
| `9786` | ArvanCloud exporter
| `9787` | fritzbox_exporter
| `9788` | T-Rex NVIDIA GPU Miner Exporter
| `9789` | Lagerist Disk latency exporter
| `9790` | Sentry Exporter to collect issues & events metrics from your projects
| `9791` | openhab_exporter
| `9792` | smartrg808ac_exporter
| `9793` | X.509 Certificate Exporter
| `9794` | Lenovo XClarity Exporter or OpenOTP Exporter
| `9795` | Prometheus Eaton UPS Exporter
| `9796` | alertdog webhook
| `9797` | dmarc-metrics-exporter
| `9798` | slurm-job-exporter
| `9799` | prommsd - Prometheus Monitoring Safety Device; alert roundtrip tester
| `9800` | Akamai Global Traffic Management Metrics Exporter
| `9801` | Akamai Edge DNS Traffic Exporter
| `9802` | blackbox websocket exporter
| `9803` | site24x7 Exporter
| `9804` | gnmic gNMI CLI Client and Collector
| `9805` | traceroute exporter
| `9806` | mpd exporter
| `9807` | Sunspec Solar Energy Exporter
| `9808` | Celery Exporter
| `9809` | ct-exporter
| `9810` | rtrtr exporter
| `9811` | zrepl internal exporter
| `9812` | FreeRADIUS exporter
| `9813` | IBM MQ Appliance exporter
| `9814` | strongSwan/IPSec/vici Exporter
| `9815` | Asterisk Exporter
| `9816` | openrc-exporter
| `9817` | Starlink Exporter (SpaceX)
| `9818` | Time Exporter
| `9819` | puppet-agent-exporter
| `9820` | Christ Elektronik CLM5IP Exporter
| `9821` | cgroups_exporter
| `9822` | Meraki dashboard data exporter using API
| `9823` | Grafana Alerts Exporter
| `9824` | Chia Node Exporter
| `9825` | Helium miner (validator) exporter
| `9826` | CraftBeerPi exporter
| `9827` | Jenkins node status exporter
| `9828` | 4D Server exporter
| `9829` | Helium hotspot exporter
| `9830` | IPTables/NFTables exporter
| `9831` | RctMon - RCT Inverter metrics extractor
| `9832` | P1Exporter - Dutch Electricity Smart Meter Exporter
| `9833` | Graylog Server Exporter
| `9834` | Jarvis Standing Desk Exporter
| `9835` | Nvidia GPU Exporter (utkuozdemir)
| `9836` | JetBrains Floating License Server Exporter
| `9837` | Steam Exporter (A2S_INFO)
| `9838` | Halon exporter
| `9839` | What Active Users Exporter
| `9840` | Kafka Connect exporter
| `9841` | A2S Exporter
| `9842` | Butler SOS (Qlik Sense monitoring tool) Exporter
| `9843` | Butler (Qlik Sense DevOps toolbox) Exporter. WIP
| `9843` | Butler CW (Qlik Sense cache warming tool) Exporter. WIP
| `9844` | 8430FT Exporter
| `9845` | LVM exporter
| `9846` | Cluster Exporter
| `9847` | StayRTR Exporter
| `9848` | Pimoroni Enviro and Enviro+ environmental monitoring sensor exporter
| `9849` | modbusrtu_exporter
| `9850` | Monnit Sensors MQTT Exporter WIP
| `9851` | SCTP Exporter
| `9852` | Starwind vSAN Exporter
| `9853` | JDBC Exporter
| `9854` | pgBackRest Exporter
| `9855` | Prow Exporter
| `9856` | iRODS Exporter
| `9857` | Bobcat Exporter
| `9858` | Sysload Exporter
| `9859` | Tesla Wall Connector Exporter
| `9860` | Noether Exporter
| `9861` | IQair Exporter
| `9862` | sensatronics_exporter
| `9863` | Zulip Exporter
| `9864` | Radio Thermostat Exporter
| `9865` | Alamos FE2 Exporter
| `9866` | rtrmon (separate deamon in stayrtr repo)
| `9867` | nfs-subdir-external-provisioner-exporter
| `9868` | CVMFS exporter
| `9869` | Clash Prometheus Exporter
| `9870` | Siebel Exporter
| `9871` | Tesla Powerwall Exporter
| `9872` | File Exporter
| `9873` | MQ Exporter
| `9874` | Personal Weather Station Exporter
| `9875` | OTRS Exporter
| `9876` | energomera-exporter Energomera's electricity meter exporter
| `9877` | Clash exporter
| `9878` | Prometheus Relay Exporter
| `9879` | Prometheus VMware ESXi exporter yet to be updated PR
| `9880` | lanstats_exporter
| `9881` | RADIUS exporter
| `9882` | PODMAN exporter
| `9883` | Prometheus HTML exporter (under development)
| `9884` | Borg backup exporter
| `9885` | Tesla exporter
| `9886` | RouterOS exporter
| `9887` | Salicru EQX inverter
| `9888` | Volume Exporter
| `9889` | CloudVector MicroSensor Exporter
| `9890` | Weaponry pgSCV for PostgreSQL environments
| `9891` | Dell/EMC XtremIO Exporter
| `9892` | Pimoroni Enviro+ Exporter
| `9893` | SONiC Exporter
| `9894` | Opflex-agent Exporter
| `9895` | Opflex-server Exporter
| `9896` | py-air-control Air Quality Exporter
| `9897` | Kubernetes Cloud Cost Exporter
| `9898` | FreeBSD NFS Exporter
| `9899` | Kafka Configs Metrics Exporter
| `9900` | NVMe Exporter
| `9901` | Envoy proxy, since v1.7.0 (doc)
| `9902` | Andrews & Arnold line status exporter
| `9903` | strongswan/libreswan IPsec stats exporter
| `9904` | haraka exporter
| `9905` | MongoDB Atlas exporter
| `9906` | ClamAV daemon stats exporter
| `9907` | Postfix stats exporter
| `9908` | BorgBase exporter
| `9909` | Aruba Exporter
| `9909` | NetMeter Exporter
| `9910` | anynode Exporter
| `9911` | Zeek
| `9912` | Azure App Secrets monitor
| `9913` | Nginx VTS Exporter
| `9914` | Chia Exporter
| `9915` | Powerpal Exporter
| `9916` | Dependency-Track Exporter
| `9917` | Suricata Exporter
| `9918` | Shelly Plug Exporter
| `9919` | zedhook
| `9920` | ddwrt-collector
| `9921` | Hasura Exporter
| `9922` | samba_exporter
| `9923` | YOURLS exporter
| `9924` | Systemd Resolved Exporter
| `9925` | Statuspage exporter
| `9926` | Ceph exporter
| `9927` | Nagios exporter
| `9928` | bpftrace exporter
| `9929` | ThirdAI exporter
| `9930` | OpenROADM NETCONF Exporter WIP
| `9931` | VSCode Exporter
| `9932` | Tezos Node Exporter
| `9933` | Patroni Exporter
| `9934` | Zyxel GS1200 Exporter
| `9935` | Onionprobe
| `9936` | LiteSpeed Ingress Controller
| `9937` | Vault Assessment Prometheus Exporter
| `9938` | Hitron CGNV4 exporter
| `9939` | IBM Z CEX Device Plugin Prometheus Exporter
| `9940` | minecraft-prometheus-exporter
| `9941` | huawei-lte-exporter
| `9942` | DRBD exporter via drbd-reactor
| `9943` | FileStat Exporter
| `9944` | NFSv4 server exporter
| `9945` | jbod - Generic storage enclosure tool
| `9946` | Shelly 3EM Exporter
| `9947` | Emporia Smart Devices Exporter
| `9948` | nextdns-exporter
| `9949` | TACACS Exporter
| `9950` | Raritan PDU Exporter
| `9951` | PVE Node Discovery
| `9952` | Chia Price Exporter
| `9953` | Spacelift Exporter
| `9954` | CMON Exporter
| `9955` | Cloudkeeper metrics exporter
| `9956` | Cloudkeeper worker exporter
| `9957` | Solar logging stick exporter
| `9958` | HDSentinel Exporter
| `9959` | Authelia
| `9960` | Solanteq SOLAR
| `9961` | Speedify Exporter
| `9962` | Cilium Agent
| `9963` | Cilium Operator
| `9964` | Cilium Proxy
| `9965` | Hubble
| `9966` | OpenVAS exporter
| `9967` | clamscan-exporter
| `9968` | vertica-prometheus-exporter
| `9969` | poudriere exporter
| `9970` | UnifiedMetrics (0.4.x+)
| `9971` | AMD SMI Exporter
| `9972` | SRS (v5.0.67+)
| `9973` | Excel Exporter
| `9974` | Meilisearch Exporter
| `9975` | ntpd-rs and iowatcher-ng Exporter
| `9976` | Apple Time Machine Exporter
| `9977` | VMware vROps exporter
| `9978` | gpsd exporter
| `9979` | sfptpd exporter
| `9979` | ElastAlert 2
| `9980` | Login Exporter
| `9981` | TP-Link P110 Exporter
| `9982` | Traefik
| `9983` | Sia Exporter
| `9984` | CouchDB exporter
| `9985` | BungeeCord Prometheus Exporter
| `9986` | EOS exporter
| `9987` | NetApp Solidfire Exporter
| `9988` | Ping Identity Exporter
| `9989` | Google Cloud Status Dashboard exporter
| `9990` | Wildfly Exporter
| `9991` | AuthLog Exporter
| `9992` | Lutron QS/Homeworks Exporter
| `9993` | Sense Energy exporter
| `9994` | Checkpoint exporter
| `9995` | Disk usage exporter and NUT exporter
| `9996` | NVML exporter
| `9997` | sockstat exporter
| `9998` | ARM HWCPipe Exporter
| `9999` | Exporter exporter

List of other exporter services that operate outside of the standard port range:

|  Port  | Service
|--------|---------
| `8000` | CXP (Resource-friendly Docker Container Exporter for Prometheus) +45 Stars
| `2112` | Tetragon
| `2223` | Inspektor Gadget
| `3105` | Solis Exporter
| `3903` | mtail
| `4040` | prometheus-nginxlog-exporter
| `5006` | Neptune Fusion Apex Exporter
| `5555` | prometheus-jdbc-exporter, any Java DB driver
| `6060` | Crowdsec Exporter
| `7300` | MidoNet agent
| `7355` | CS:GO Exporter
| `8080` | cAdvisor (Container Advisor) / Traefik
| `8082` | trickster
| `8088` | Fawkes
| `8089` | prom2teams
| `8292` | Phabricator webhook for Alertmanager
| `8404` | HA Proxy (v2+)
| `9001` | freeRouter exporter
| `9042` | rds_exporter
| `9043` | prometheus-rds-exporter
| `9045` | Prometheus Alertecho
| `9087` | Telegram bot for Alertmanager
| `9097` | JIRAlert
| `9099` | SNMP Trapper
| `9100` | - 9999 	see standard port range above!
| `10001` | justmysocks_exporter
| `10002` | Lemmy
| `10003` | ecowater_prometheus_exporter
| `10004` | openziti_exporter
| `10005` | Digicert Exporter
| `10006` | Qsys Exporter
| `10007` | Time of Use Exporter
| `10008` | Ceph NVMe-oF Exporter
| `10009` | Shelly Plus Plug Exporter
| `10010` | Herpstat SpyderWeb Exporter
| `10011` | Shelly Pro 3 EM Exporter
| `10012` | dmarc_srg_exporter
| `10013` | tilekiln
| `10014` | Radiator
| `10015` | Kiwi Warmer Exporter
| `10016` | Twelve Data Exporter
| `10017` | IBM Security Verify Access / Security Access Manager
| `10018` | Repquota disk quota information
| `10019` | Proxmox Backup Server Exporter
| `10020` | Youtube Exporter
| `10021` | pmacct-exporter
| `10022` | Shelly Plus 1 PM Exporter
| `10023` | fishymetrics
| `10024` | Shelly Plus PM Mini Exporter
| `10026` | mcexport (Minecraft Probing Exporter)
| `10080` | UNALLOCATED (To avoid collision with Amanda and blocked by web browsers
| `10100` | aws_quota_exporter
| `10101` | Prometheus Android Exporter
| `10200` | Hardware Observer Operator
| `10201` | Hangfire exporter
| `10998` | E3DC Power Management System Exporter
| `11111` | Foreman Exporter
| `11112` | Threshold Exporter
| `12345` | journald-exporter
| `15692` | rabbitmq_prometheus
| `15693` | silverpeak-prometheus
| `16995` | Storidge exporter
| `17871` | qBittorrent Exporter
| `18899` | Solana Wallet Exporter
| `19091` | Transmission Exporter
| `19854` | gpbackup Exporter
| `19999` | Netdata
| `24231` | Fluent Plugin for Prometheus
| `28272` | Nagios Check Exporter
| `29091` | Simple Transmission Exporter
| `30042` | Prefect2 Prometheus Exporter
| `36123` | Homebridge Prometheus Exporter
| `36333` | Prometheus Weathermen
| `39100` | Open Telekom Cloud Prometheus Exporter
| `42004` | ProxySQL exporter
| `44322` | Performance Co-Pilot exporter
| `44323` | PCP exporter
| `61091` | DCOS exporter

