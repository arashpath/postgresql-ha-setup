# Postgresql-12 HA Setup

### Check replication
```bash
vagrant ssh master -c "psql -U postgres -c 'select * from pg_replication_slots;'"
vagrant ssh master -c "psql -U postgres -xc 'select * from pg_stat_replication' "
```
### Check EFM Cluster Info
```bash
vagrant ssh master -c "/usr/edb/efm-3.10/bin/efm cluster-status efm"
vagrant ssh master -c "sudo /usr/edb/efm-3.10/bin/efm promote efm -switchover"
```



# Ref.
- https://www.enterprisedb.com/edb-docs/d/edb-postgres-failover-manager/user-guides/high-availability-scalability-guide/3.10/architecture.html
- https://www.enterprisedb.com/blog/how-provision-and-deploy-highly-available-postgres-terraform-and-ansible-automation-scripts
- https://www.enterprisedb.com/postgres-tutorials/how-deploy-ansible-scripts-edb-postgres-platform