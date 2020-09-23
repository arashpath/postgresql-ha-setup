FROM centos:7
RUN yum install -y createrepo
WORKDIR /repos
ARG DLREPO="yum install -y --downloadonly --downloaddir=/repos"

# PostgreSQL
RUN yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
ARG PGVER=12
RUN ${DLREPO} postgresql${PGVER} postgresql${PG_VER}-server
RUN ${DLREPO} postgresql${PGVER}-contrib pgpool-II-${PG_VER}

# EPEL
RUN yum -y install epel-release
RUN ${DLREPO} java-1.8.0-openjdk mailx which
RUN ${DLREPO} python-pip python-psycopg2

# EDB
RUN yum -y install https://yum.enterprisedb.com/edbrepos/edb-repo-latest.noarch.rpm
ARG EDB_USER
ARG EDB_PASS
RUN sed -i "s@<username>:<password>@${EDB_USER}:${EDB_PASS}@" /etc/yum.repos.d/edb.repo
RUN ${DLREPO} edb-bart edb-pem edb-efm40 

# Clean and create fresh repo
RUN rm -rf /repos/repodata 
RUN createrepo /repos