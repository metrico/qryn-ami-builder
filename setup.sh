#!/bin/bash

rm -rf /var/lib/apt/lists/* && apt-get update

#### INSTALL OF VECTOR
DEBIAN_FRONTEND=noninteractive apt-get install -qq --assume-yes gpg
wget -O-  https://repositories.timber.io/public/vector/gpg.3543DB2D0A2BC4B8.key |gpg --dearmor > /usr/share/keyrings/timber-vector-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/timber-vector-archive-keyring.gpg] https://repositories.timber.io/public/vector/deb/debian bookworm main" > /etc/apt/sources.list.d/timber-vector.list
echo "deb-src [signed-by=/usr/share/keyrings/timber-vector-archive-keyring.gpg] https://repositories.timber.io/public/vector/deb/debian bookworm main" >> /etc/apt/sources.list.d/timber-vector.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -qq --assume-yes vector
mv /tmp/vector/vector.yaml /etc/vector/

#### INSTALL OF HOMER SERVER
DEBIAN_FRONTEND=noninteractive apt-get install -qq --assume-yes libluajit-5.1-common libluajit-5.1-dev lsb-release wget curl git wget

cd /tmp/
wget https://packagecloud.io/install/repositories/qxip/sipcapture/script.deb.sh?any=true
mv "script.deb.sh?any=true" script.deb.sh
chmod +x script.deb.sh
./script.deb.sh
apt-get update
DEBIAN_FRONTEND=noninteractive apt install -qq --assume-yes heplify-server
sed -i -e "s/AlegIDs\s*=\s*\[\]/AlegIDs        = \[\"P-Charging-Vector,icid-value=\\\\\"?(.*?)(?:\\\\\"|;|$)\"]/g" /etc/heplify-server.toml
sed -i -e "s/DBShema\s*=\s*\"[^\"]*\"/DBShema        = \"mock\"/g" /etc/heplify-server.toml
sed -i -e "s/DBDriver\s*=\s*\"[^\"]*\"/DBDriver        = \"mock\"/g" /etc/heplify-server.toml
sed -i -e "s/HEPWSAddr\s*=\s*\"[^\"]*\"/HEPWSAddr      = \"\"/g" /etc/heplify-server.toml
sed -i -e "s/DBAddr\s*=\s*\"[^\"]*\"/DBAddr        = \"\"/g" /etc/heplify-server.toml
sed -i -e "s/PromAddr\s*=\s*\"[^\"]*\"/PromAddr = \"127.0.0.1:9096\"/g" /etc/heplify-server.toml
sed -i -E "s/LokiTimer\s*=\s*[0-9]+/LokiTimer        = 1\nLokiIPPortLabels        = true/g" /etc/heplify-server.toml



#### INSTALL OF GRAFANA SERVER
apt-get install -y apt-transport-https software-properties-common wget unzip
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
# Updates the list of available packages
apt-get update
# Installs the latest OSS release:
DEBIAN_FRONTEND=noninteractive sudo apt-get install -qq --assume-yes grafana

cp -a /tmp/grafana/provisioning /etc/grafana/
cp -a /tmp/grafana/plugins/ /var/lib/grafana/plugins/
cd /tmp/ && wget https://github.com/metrico/grafana-flow/releases/download/v10.0.8/qxip-flow-panel-10.0.8.zip && unzip qxip-flow-panel-10.0.8.zip -d /var/lib/grafana/plugins/


##### INSTALL OF QRYN


apt-get update
apt-get install -y ca-certificates curl gnupg
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

adduser qryn --system
apt-get update
DEBIAN_FRONTEND=noninteractive sudo apt-get install -qq --assume-yes nodejs
npm install -g qryn
mv /tmp/qryn.service /etc/systemd/system/

