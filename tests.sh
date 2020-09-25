#!/bin/bash


check_if_primary() {
  if [ $(
    lxc exec $1 -- /usr/edb/efm-4.0/bin/efm node-status-json efm | jq -r '.type'
  ) = "Primary" ]; then
    echo "$1 is Primary✅"
  else
    echo "$1 is Not Primary❌"
    exit 1
  fi
}


echo "
[ CHECK INFRA ] =============================================================="
lxc list -c ns4

echo "
[ EFM STATUS ] ==============================================================="
lxc exec db01 -- /usr/edb/efm-4.0/bin/efm cluster-status efm
check_if_primary db01

echo "
[ REPLICATON STATUS ] ========================================================"
lxc exec db01 -- psql -U postgres -xc 'select * from pg_stat_replication;'

echo "
[ EFM SWITCHOVER ] ==========================================================="
check_if_primary db01
db2_ip=$( lxc list db02 -c 4 --format csv | awk '{print $1}' )
db3_ip=$( lxc list db03 -c 4 --format csv | awk '{print $1}' )
lxc exec db01 -- /usr/edb/efm-4.0/bin/efm set-priority efm $db2_ip 1
lxc exec db01 -- /usr/edb/efm-4.0/bin/efm set-priority efm $db3_ip 2
lxc exec db01 -- /usr/edb/efm-4.0/bin/efm promote efm -switchover
sleep 30; lxc exec db01 -- /usr/edb/efm-4.0/bin/efm cluster-status efm
check_if_primary db02

echo "
[ EFM FAILOVER ] ==========================================================="
lxc stop db02
sleep 50; lxc exec db01 -- /usr/edb/efm-4.0/bin/efm cluster-status efm
check_if_primary db01