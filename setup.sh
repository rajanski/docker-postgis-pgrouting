#!/bin/bash


# Add any additional setup tasks here

service postgresql start 
su postgres -c "createuser -d -s -r -l docker" 
su postgres -c "psql postgres -c \"ALTER USER docker WITH PASSWORD 'docker'\""

su postgres -c "createuser -d -s -r -l docker" 
su postgres -c "psql postgres -c \"ALTER USER docker WITH ENCRYPTED PASSWORD 'docker'\"" 
su postgres -c "psql postgres -c \"CREATE DATABASE docker\"" 
su postgres -c "psql postgres -c \"GRANT ALL ON DATABASE docker to docker\""

su postgres -c "createdb routes -U postgres -O postgres"
su postgres -c "psql postgres -d routes -c \"create extension postgis;\"" 
su postgres -c "psql postgres -d routes -c \"create extension pgrouting;\""
su postgres -c "psql postgres -d routes -c \"create extension hstore;\""
su postgres -c "psql postgres -d routes -c \"create extension uuid-ossp;\""

service postgresql stop
