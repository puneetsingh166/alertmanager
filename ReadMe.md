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

For more elaborate overviews of Prometheus, see the resources linked from the media section.

<a name="desc"></a>
## Architecture.
This diagram illustrates the architecture of Prometheus and some of its ecosystem components:


![Screenshot from 2021-12-07 19-09-50](https://user-images.githubusercontent.com/90913214/145039662-16cb32ea-1ce5-4a74-8b18-585775d89290.png)


Prometheus scrapes metrics from instrumented jobs, either directly or via an intermediary push gateway for short-lived jobs. It stores all scraped samples locally and runs rules over this data to either aggregate and record new time series from existing data or generate alerts. Grafana or other API consumers can be used to visualize the collected data.
<a name="desc1"></a>
## Prometheus server.
This is the main core.
Before do the setup we need to write our own config.yml file first.
To learn about how to write your own config.yml file 
[Here](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
[Example file](https://github.com/sunnyk56/prometheus/blob/main/deploy/config/config.yml)
And define set of rules in config.yml file .

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
### [Here](https://github.com/sunnyk56/prometheus/blob/main/deploy/ubuntu/init.sh) is automate installation of prometheus using shell script.

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
ALert manager to send alert abou
Before install and run alert manager we need to write config file for alert manager.
[Here](https://prometheus.io/docs/alerting/latest/configuration/) is the link How to write config file for alert manager 
[Example](https://github.com/puneetsingh166/alertmanager/blob/main/deploy/init.sh)
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
### [Here](https://github.com/sunnyk56/prometheus/blob/main/deploy/ubuntu/init.sh) is automate installation of alertmanager using shell script.

