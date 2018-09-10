#!/usr/bin/env bash

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

sudo cat <<'EOF' > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

sudo yum install -y elasticsearch 
sudo cp /etc/elasticsearch/elasticsearch.yml /root 
sudo cat <<EOF > /etc/elasticsearch/elasticsearch.yml
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
path.repo: ["/etc/elasticsearch/elasticsearch-backup"]
cluster.name: elkepam
node.name: node-node$1
node.master: false
node.data: true
network.host: 192.168.120.2$1
http.port: 9200
discovery.zen.ping.unicast.hosts: ["192.168.120.40", "192.168.120.21","192.168.120.22","192.168.120.23"]
#discovery.zen.minimum_master_nodesdiscovery.zen.minimum_master_nodes: 2
EOF

sudo touch /etc/elasticsearch/elasticsearch.keystore
sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch/
sudo chmod -R 750 /etc/elasticsearch/
sudo systemctl enable elasticsearch && sudo systemctl start elasticsearch

