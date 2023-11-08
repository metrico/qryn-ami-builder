<img src="https://github.com/sipcapture/homer7-docker/assets/1423657/36a8e515-ab0e-482b-bf49-2156e290c764" height=200><img src="https://github.com/sipcapture/homer-docker/assets/1423657/8997d282-0c29-4137-a1ef-e9be79a54284" height=200/>

# homer

To build the packer image you can do as follows
```
packer init aws-debian.pkr.hcl
packer build aws-debian.pkr.hcl
```

To build for production you must specify the region
```
packer init aws-debian.pkr.hcl
packer build -var 'region=eu-west-1' aws-debian.pkr.hcl
```

# user-data
In the user-data of the instance you must set the following env vars and invoke /usr/sbin/genconf.sh
```
CLICKHOUSE_SERVER
CLICKHOUSE_USER
CLICKHOUSE_PASSWORD
CLICKHOUSE_DB
CLICKHOUSE_PROTO
CLICKHOUSE_PORT
QRYN_USER
QRYN_PASSWORD
```

# logging into grafana first time
Default login:
admin / admin

# logging into the debian instance
Username: admin


