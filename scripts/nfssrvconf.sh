#!/usr/bin/env bash

sudo cat <<'EOF' > /etc/exports
/etc/elasticsearch/elasticsearch-backup 192.168.120.21(rw,sync,no_root_squash)
/etc/elasticsearch/elasticsearch-backup 192.168.120.22(rw,sync,no_root_squash)
/etc/elasticsearch/elasticsearch-backup 192.168.120.23(rw,sync,no_root_squash)
EOF

sudo systemctl restart nfs-server && sudo systemctl enable nfs-server
