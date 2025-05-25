# fail2ban


## Install
Install with your package manager.  

```bash
apt install -y fail2ban
```

Verify
```bash
fail2ban-client --version
```

## Configuration

Configure fail2ban to ban after several unsuccessful SSH connections attemps.  

```bash
vi /etc/fail2ban/jail.conf
```

Uncomment/add the following entry for `sshd`:
```bash
[sshd]
enabled = true
maxretry =  5
findtime = 10
bantime = 4h
```

Restart the fail2ban daemon.
```bash
sudo systemctl restart fail2ban
```

---

Test that the configuration worked.
Use a throwaway machine to try connecting to the host unsuccessfully 6 times.  
```bash
for i in {1..6}; do ssh user@fail2ban-host; done  # Spam enter
```

If successful, you will need to `^C` the process.  
Then go back to the host with `fail2ban` on it and check the logs.  
```bash
tail -n 20 /var/log/fail2ban.log
```
You should see the unsuccessful attempts and the ban.  

Check the banned IP:
```bash
fail2ban-client get sshd banned
```
This will show a list of IPs that are banned (from SSH).  


## Unbanning an IP

```bash
fail2ban-client set sshd unbanip <banned_IP>
```
Replace the `<banned_IP>` with the IP you want to unban.  

It should output `1` if successful.  

Test:
```bash
fail2ban-client get sshd banned
```

---

## Integraging with Loki/Promtail

The `fail2ban` tool can be integrated with logging tools.  

For example, using Grafana (visualizations) with Loki and Telegraf.  

---

Install the tools (Grafana, Loki, Promtail) -- see [installing monitoring tools](../monitoring/monitoring_tools.md)

---

In your Promtail config, add a rule for scraping and pushing fail2ban logs.  
```yaml
- job_name: fail2ban
  static_configs:
  - targets:
      - localhost
    labels:
      job: fail2ban
      __path__: /var/log/fail2ban.log
```

## Setting up Alerts with Telegraf, InfluxDB, and Grafana

```bash
# Install InfluxDB
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list

apt-get update && apt-get -y install influxdb2
systemctl enable --now influxdb
```
Connect to the influxdb endpoint (`http://localhost:8086`) and set up a bucket.

Add:

- Username
- password
- Organization name
- Bucket name

The bucket name is what you'll use in your queries.  



a238XZQivdW16OBDdrk3YS7zeoTCUQvThq0YuHry4VW8JKcLoxKW-c9VqwOcU1nQ_7b1320wY51o1R8QJSEGLg==



