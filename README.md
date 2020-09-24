# Postgresql-12 HA Setup

## Prerequisite
- Create a localrepo `repos.tgz` with required rpms
  ```bash
  cd files/
  echo "EDB_USER='<edb-username>'
  EDB_PASS='<edb-repo-password>'" > .env
  docker-compose up --build
  ```
## Vagrant Setup
### Setup cluster
```bash
vagrant up
```
### Check replication
```bash
# check replication status, sync_state must be in quorum for synchronous streamming
vagrant ssh db01 -c "psql -U postgres -xc 'select * from pg_stat_replication;'"
vagrant ssh db01 -c "psql -U postgres -c 'select * from pg_replication_slots;'"
```
### Check EFM Cluster
- Check Status
  ```bash
  # Check cluster status
  vagrant ssh db01 -c "/usr/edb/efm-4.0/bin/efm cluster-status efm"
  # If required change Standby priority host list
  vagrant ssh db01 -c "sudo /usr/edb/efm-4.0/bin/efm set-priority efm 192.168.33.12 1"
  vagrant ssh db01 -c "sudo /usr/edb/efm-4.0/bin/efm set-priority efm 192.168.33.13 2"
  ```
- Planned Failover / Failback
  ```bash
  # Do Failover/Failback
  vagrant ssh db01 -c "sudo /usr/edb/efm-4.0/bin/efm promote efm -switchover"
  vagrant ssh db01 -c "watch /usr/edb/efm-4.0/bin/efm cluster-status efm"
  ```
- Unplanned Failover
  ```bash
  # Stimulate a unplanned failure and watch slave become master
  vboxmanage controlvm db01 poweroff
  vagrant ssh db02 -c "watch /usr/edb/efm-4.0/bin/efm cluster-status efm"
  # Start master 
  vagrant up db01
  # master must be recreated as stanby using pg_backup
  ./playbook.yml --limit db01 -t pg_rep,efm_config -e "pg_repl_role=standby pg_master_ip=192.168.33.12" 
  ```

# TO-DO
- [x] Install PostgreSQL12
- [x] Setup Streaming Replication
- [x] Setup EFM 
- [ ] Setup PEM
- [ ] Setup BART

# Ref.
- https://www.enterprisedb.com/edb-docs/d/edb-postgres-failover-manager/user-guides/high-availability-scalability-guide/4.0/architecture.html
- https://www.enterprisedb.com/blog/how-provision-and-deploy-highly-available-postgres-terraform-and-ansible-automation-scripts
- https://www.enterprisedb.com/postgres-tutorials/how-deploy-ansible-scripts-edb-postgres-platform
