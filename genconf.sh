#!/bin/bash

#### Vector 
echo "QRYN_SERVER=http://localhost:3100" >> /etc/default/vector
echo "QRYN_USER=$QRYN_USER" >> /etc/default/vector
echo "QRYN_PASSWORD=$QRYN_PASSWORD" >> /etc/default/vector
service vector restart

#### QRYN setup
echo "CLICKHOUSE_SERVER=\"$CLICKHOUSE_SERVER\"" > /etc/default/qryn
echo "CLICKHOUSE_AUTH=\"$CLICKHOUSE_USER:$CLICKHOUSE_PASSWORD\""  >> /etc/default/qryn
echo "CLICKHOUSE_DB=\"$CLICKHOUSE_DB\""  >> /etc/default/qryn
echo "CLICKHOUSE_PROTO=\"$CLICKHOUSE_PROTO\"" >> /etc/default/qryn
echo "CLICKHOUSE_PORT=\"$CLICKHOUSE_PORT\"" >> /etc/default/qryn
echo "QRYN_LOGIN=\"$QRYN_USER\"" >> /etc/default/qryn
echo "QRYN_PASSWORD=\"$QRYN_PASSWORD\"" >> /etc/default/qryn

systemctl enable qryn
service qryn start

#### Grafana configuration
echo "GF_USERS_ALLOW_SIGN_UP=false" >> /etc/default/grafana-server
echo "GF_USERS_DEFAULT_THEME=light" >> /etc/default/grafana-server
echo "GF_EXPLORE_ENABLED=true" >> /etc/default/grafana-server
echo "GF_ALERTING_ENABLED=false" >> /etc/default/grafana-server
echo "GF_UNIFIED_ALERTING_ENABLED=true" >> /etc/default/grafana-server
echo "GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS=qxip-flow-panel" >> /etc/default/grafana-server
echo "QRYN_USER=$QRYN_USER" >> /etc/default/grafana-server
echo "QRYN_PASSWORD=$QRYN_PASSWORD" >> /etc/default/grafana-server

systemctl enable grafana-server
service grafana-server restart


#### HOMER SETUP
sed -i -e "s/LokiURL\s*=\s*\"[^\"]*\"/LokiURL        = \"http:\/\/$QRYN_USER:$QRYN_PASSWORD@127.0.0.1:3100\"/g" /etc/heplify-server.toml

systemctl enable heplify-server
service heplify-server start
