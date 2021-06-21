
@echo off

echo "Stop & Remove the liquibase 'alpine_liquibase' in network 'database_network, it is normal to see Errors as the container has already stopped/been removed'
docker container stop alpine_liquibase
docker container rm alpine_liquibase

echo "Stop & Remove the postgres database 'alpine_postgres' in network 'database_network'
docker container stop alpine_postgres
docker container rm alpine_postgres

echo "Remove the network 'database_network'
docker network rm database_network