# Systems monitoring tool


## Table Of Contents
1. [What is Prometheus](#desc11)
2. [Architecture](#desc)
3. [Prometheus server.](#desc1)
4. [Prometheus targets](#desc2)
5. [Alertmanager](#desc3)

<a name="desc11"></a>
## What is Prometheus
Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud. Since its inception in 2012, many companies and organizations have adopted Prometheus, and the project has a very active developer and user community. It is now a standalone open source project and maintained independently of any company. To emphasize this, and to clarify the project's governance structure, Prometheus joined the Cloud Native Computing Foundation in 2016 as the second hosted project, after Kubernetes.

Prometheus collects and stores its metrics as time series data, i.e. metrics information is stored with the timestamp at which it was recorded, alongside optional key-value pairs called labels.


<a name="desc"></a>
## Architecture.
This diagram illustrates the architecture of Prometheus and some of its ecosystem components:


![Screenshot from 2021-12-07 19-09-50](https://user-images.githubusercontent.com/90913214/145039662-16cb32ea-1ce5-4a74-8b18-585775d89290.png)


Prometheus scrapes metrics from instrumented jobs, either directly or via an intermediary push gateway for short-lived jobs. It stores all scraped samples locally and runs rules over this data to either aggregate and record new time series from existing data or generate alerts. Grafana or other API consumers can be used to visualize the collected data.
<a name="desc1"></a>
## Prometheus server.

* This is the main core.

* You will download and run Prometheus locally, configure it to scrape itself and an example application, then work with queries, rules, and graphs to use collected time series data.
* Before starting Prometheus, let's configure it.
* Prometheus collects metrics from targets by scraping metrics HTTP endpoints. Since Prometheus exposes data in the same manner about itself, it can also scrape and monitor its own health.
* While a Prometheus server that collects only data about itself is not very useful, it is a good starting example. Save the following basic Prometheus configuration as a file named <NAME>.yml:
```
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'codelab-monitor'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:9090']
  ```
 * For a complete specification of configuration options, see the [configuration documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/).
* Before do the setup we need to write our own config.yml file first.
[Example config file](https://github.com/sunnyk56/prometheus/blob/main/deploy/config/config.yml)
And also define set of rules in config.yml file .

How to install and run Prometheus server in locally in ubuntu.
1. First of all install all dependencies    
    * make
    * git
    * curl
    * tar
``` 
apt-get install --no-install-recommends -yq software-properties-common \
    curl \
    git \
    tar \
    make
```
2. Install and set golang in env variable.
```
curl https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz --output go.tar.gz
tar -C $HOME -xzf go.tar.gz
PATH="$HOME/go/bin:$PATH"
GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```
3. Install node & npm 
```
curl -sL https://deb.nodesource.com/setup_16.x  | bash -
apt-get -y install nodejs
```
4. Clone prometheus repo

```
git clone https://github.com/prometheus/prometheus.git 
```
5. make build
```
cd prometheus
make build
```
6. Run config file 
```
./prometheus --config.file="your file path"
```
### NOTE - [Here](https://github.com/sunnyk56/prometheus/blob/main/deploy/ubuntu/init.sh) is automate installation script file of prometheus.
 
 * Prometheus should start up. You should also be able to browse to a status page about itself at http://localhost:9090 . Give it a couple of seconds to collect data about itself from its own HTTP metrics endpoint.
 * You can also verify that Prometheus is serving metrics about itself by navigating to its metrics endpoint: http://localhost:9090/metrics

* Let us explore data that Prometheus has collected about itself. To use Prometheus's built-in expression browser, navigate to http://localhost:9090/graph and choose the "Console" view within the "Graph" tab.
* As you can gather from http://localhost:9090/metrics, one metric that Prometheus exports about itself is named prometheus_target_interval_length_seconds (the actual amount of time between target scrapes). Enter the below into the expression console and then click "Execute":
 
### Configure Prometheus to monitor the sample targets
Now we will configure Prometheus to scrape these new targets. Let's group all three endpoints into one job called node. We will imagine that the first two endpoints are production targets, while the third one represents a canary instance. To model this in Prometheus, we can add several groups of endpoints to a single job, adding extra labels to each group of targets. In this example, we will add the group="production" label to the first group of targets, while adding group="canary" to the second.

To achieve this, add the following job definition to the scrape_configs section in your prometheus.yml and restart your Prometheus instance:
```
  scrape_configs:
  - job_name:       'node'

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s

    static_configs:
      - targets: ['localhost:8080', 'localhost:8081']
        labels:
          group: 'production'

      - targets: ['localhost:8082']
        labels:
          group: 'canary'
```
Go to the expression browser and verify that Prometheus now has information about time series that these example endpoints expose, such as node_cpu_seconds_total.



<a name="desc2"></a>
## Prometheus targets
Jobs/exporters - 
exporters required validator's Name and address for configuration.
How to install and run Prometheus server for onomyd artifact in locally where you node is running and how to config exporters with validator .
1. Basic config
```
# onomy artifacts
ONOMY=onomyd
# onomy artifacts
CHAIN_PROTOCOL=onomy
# onomy home directory
ONOMY_HOME=$HOME/.onomy
# Keyring flag
ONOMY_KEYRING_FLAG="--keyring-backend test"
```
2. clone exporter repo


<a name="desc3"></a>
## Alertmanager
 
Alerting with Prometheus is separated into two parts. Alerting rules in Prometheus servers send alerts to an Alertmanager. The Alertmanager then manages those alerts, including silencing, inhibition, aggregation and sending out notifications via methods such as email, on-call notification systems, and chat platforms.
 


The main steps to setting up alerting and notifications are:

* Setup and configure the Alertmanager
* Configure Prometheus to talk to the Alertmanager
* Create alerting rules in Prometheus


The Alertmanager handles alerts sent by client applications such as the Prometheus server. It takes care of deduplicating, grouping, and routing them to the correct receiver integration such as email, PagerDuty, or OpsGenie. It also takes care of silencing and inhibition of alerts.

 Before install and run alert manager we need to write config file for alert manager.
[Here](https://prometheus.io/docs/alerting/latest/configuration/) is the link How to write config file for alert manager 
[Example File](https://github.com/puneetsingh166/alertmanager/blob/main/deploy/init.sh)
How to install and run alert manager - .

1. First of all install all dependencies    
    * make
    * git
    * curl
    * tar
``` 
apt-get install --no-install-recommends -yq software-properties-common \
    curl \
    git \
    tar \
    make
```
2. Install and set golang in env variable.
```
curl https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz --output go.tar.gz
tar -C $HOME -xzf go.tar.gz
PATH="$HOME/go/bin:$PATH"
GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```
3. Install node & npm 
```
curl -sL https://deb.nodesource.com/setup_16.x  | bash -
apt-get -y install nodejs
```
4. Clone prometheus repo
```
git clone https://github.com/prometheus/alertmanager 
```
5. make build
```
cd alertmanager
```
make build
```
6. Run config file 
```./alertmanager --config.file=your yml file.
```
### [Here](https://github.com/sunnyk56/prometheus/blob/main/deploy/ubuntu/init.sh) is automate installation's script of alertmanager.
* Alert manager should start up. You should also be able to browse to a status page about itself at http://localhost:9093 

