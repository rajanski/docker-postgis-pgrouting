# Dockerfile PostGIS PGrouting

## Info

This Dockerfile creates a container running PostGIS 2.1/PGRouting in PostgreSQL 9.4

- expose port `5439`
- initializes a database in `/var/lib/postgresql/9.4/main`
- superuser in the database: `docker/docker`


## Install

- `docker build -t pgrouting https://github.com/rajanski/docker-postgis-pgrouting


## Data Persistence

You can mount the database directory as a volume to persist your data:

`docker run -d -v $HOME/PG_DATA:/var/lib/postgresql pgrouting`

Makes sure first need to create source folder: `mkdir -p ~HOME/PG_DATA`.

If you copy existing postgresql data, you need to set permission properly (chown/chgrp)

## Running / Usage

To connect to database, use docker inspect CONTAINER and grep IPAddress, e.g.

```
DC=$(docker run -d -v /home/docker/PG_DATA:/var/lib/postgresql -t pgrouting /start.sh)
DC_IP=$(sudo docker inspect $CONTAINER | grep IPAddress | awk '{ print $2 }' | tr -d ',"')
psql -h $DC_IP -p 5439 -U postgres -W 
```





## Meta

Built width docker version `1.x`


## References

- Docker trusted build: [helmi03/docker-postgis](https://index.docker.io/u/helmi03/docker-postgis/)
- [stigi/dockerfile-postgresql](https://github.com/stigi/dockerfile-postgresql)
- [Docker PostgreSQL Service](http://docs.docker.io/en/latest/examples/postgresql_service/)
- [Dockerizing a PostgreSQL Service](http://docs.docker.com/examples/postgresql_service/)
