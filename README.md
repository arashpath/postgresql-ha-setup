# Postgresql-12 HA Setup

### Setup cluster
```bash
vagrant up
```
### Check replication
```bash
vagrant ssh master -c "psql -U postgres -xc 'select * from pg_stat_replication;'"
vagrant ssh master -c "psql -U postgres -c 'select * from pg_replication_slots;'"
```
### Check EFM Cluster
- Check Status
  ```bash
  # Check cluster status
  vagrant ssh master -c "/usr/edb/efm-3.10/bin/efm cluster-status efm"
  # Change standby prority if required.
  vagrant ssh master -c "sudo /usr/edb/efm-3.10/bin/efm set-priority efm 192.168.33.12 1"
  ```
- Planned Failover / Failback
  ```bash
  # Do Failover and Failback using
  vagrant ssh master -c "sudo /usr/edb/efm-3.10/bin/efm promote efm -switchover"
  vagrant ssh master -c "watch /usr/edb/efm-3.10/bin/efm cluster-status efm"
  ```
- Unplanned Failover
  ```bash
  # Stimulate a unplanned failure and watch slave become master
  vboxmanage controlvm master poweroff
  vagrant ssh slave1 -c "watch /usr/edb/efm-3.10/bin/efm cluster-status efm"
  # Start master 
  vagrant up
  # master must be recreated using pg_backup
  ./playbook.yml --tags pg_rep --limit master \
  -e "SLAVE1_IP=192.168.33.11 MASTER_IP=192.168.33.12"
  ```



# Ref.
- https://www.enterprisedb.com/edb-docs/d/edb-postgres-failover-manager/user-guides/high-availability-scalability-guide/3.10/architecture.html
- https://www.enterprisedb.com/blog/how-provision-and-deploy-highly-available-postgres-terraform-and-ansible-automation-scripts
- https://www.enterprisedb.com/postgres-tutorials/how-deploy-ansible-scripts-edb-postgres-platform