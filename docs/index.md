## Postgresql HA Setup

### To Save Data create a offline repo
- Create a localrepo `repos.tgz` with required rpms
  ```bash
  cd files/
  echo "EDB_USER='<edb-username>'
  EDB_PASS='<edb-repo-password>'" > .env
  docker-compose up --build
  ```
### Windows may use Vagrant
- [Vagrnat](Vagrant.md)