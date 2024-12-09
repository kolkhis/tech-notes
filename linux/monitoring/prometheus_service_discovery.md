# Prometheus Service Discovery

Prometheus can be configured to use external sources (files/dns) to identify scrape
targets, rather than hard-coding targets in to `/etc/prometheus/prometheus.yml`.  


## File-Based Service Discovery
File-based service discovery can be done by defining it in the config:
```yaml
# /etc/prometheus/prometheus.yml
scrape_configs:
  - job_name: 'node'
    file_sd_configs:
      - files:
        - '/var/lib/prometheus/targets.json'
```
This `target.json` file can hold a list of targets formatted like this:

### Example `targets.json`
```json
[
    {
        "targets": ["localhost:9100", "192.168.1.100:9100", "192.168.1.101:9100"],
        "labels": {
            "job": "node"
        }
    }
]
```

You can either expand the list or add more objects in the root list.  
You can also use a `targets.yaml` file if you want.  

Adding another target with another entry in the root list:
```json
[
    {
        "targets": ["localhost:9100", "192.168.1.100:9100", "192.168.1.101:9100"],
        "labels": {
            "job": "node"
        }
    },
    {
        "targets": ["localhost:9200"],
        "labels": {
            "job": "node"
        }
    }
]
```

Adding another target by expanding the existing list:
```json
[
    {
        "targets": ["localhost:9100", "192.168.1.100:9100", "192.168.1.101:9100", "localhost:9200"],
        "labels": {
            "job": "node"
        }
    }
]
```


## Resources
* [Prometheus docs on file sd](https://prometheus.io/docs/guides/file-sd/)

