#!/bin/zsh
echo "-----------Installing_dependencies---------------"
apt-get install --no-install-recommends -yq software-properties-common \
    curl \
    git \
    tar \
    make

echo "--------------install_golang---------------------------"
curl https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz --output go.tar.gz
tar -C $HOME -xzf go.tar.gz
PATH="$HOME/go/bin:$PATH"
GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

echo "--------------install_node and npm---------------------------"
curl -sL https://deb.nodesource.com/setup_16.x  | bash -
apt-get -y install nodejs

echo "--------------get clone_prometheus_alert_manager repo ---------------------------"
cd
git clone https://github.com/puneetsingh166/alertmanager.git
cd alertmanager
make build
./alertmanager --config.file="deploy/alertmanager.yml"
