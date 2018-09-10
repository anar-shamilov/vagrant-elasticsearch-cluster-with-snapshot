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
path.repo: ["/etc/elasticsearch/elasticsearch-backup"]
path.logs: /var/log/elasticsearch
cluster.name: elkepam
node.name: node-master
node.master: true
node.data: true
network.host: $1
http.port: 9200
discovery.zen.ping.unicast.hosts: ["192.168.120.40", "192.168.120.21","192.168.120.22","192.168.120.23"]
#discovery.zen.minimum_master_nodesdiscovery.zen.minimum_master_nodes: 2
EOF

sudo touch /etc/elasticsearch/elasticsearch.keystore
sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch/
sudo chmod -R 750 /etc/elasticsearch/
sudo systemctl enable elasticsearch && sudo systemctl start elasticsearch

sudo yum install -y kibana
sudo cp /etc/kibana/kibana.yml /root
sudo cat <<EOF > /etc/kibana/kibana.yml
server.host: "$1"
EOF

sudo systemctl enable kibana && sudo systemctl start kibana

sudo yum install -y logstash
sudo echo 'export PATH=$PATH:/usr/share/logstash/bin' >> ~/.bashrc
#sudo echo 'export PATH=$PATH:/usr/share/logstash/bin' >> /etc/environment
sudo cp /etc/logstash/logstash.yml /root/
sudo cat <<'EOF' > /etc/logstash/logstash.yml
path.data: /var/lib/logstash
path.logs: /var/log/logstash
EOF
sudo systemctl start logstash && sudo systemctl enable logstash
