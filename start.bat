@echo off

SET DATABASE_IMAGE=leiwang008/alpine_postgres
SET LIQUIBASE_IMAGE=leiwang008/alpine_liquibase

echo "Create a network 'database_network' so that the containers can connect each other by container's name"
docker network create database_network

echo "Create a postgres database 'alpine_postgres' in network 'database_network'
docker run --network=database_network --name alpine_postgres --publish 5432:5432 -e POSTGRES_PASSWORD=mypass -d %DATABASE_IMAGE% postgres

echo "Create a liquibase 'alpine_liquibase' in network 'database_network' to update database in 'alpine_postgres' container
docker run --network=database_network --name alpine_liquibase --rm  %LIQUIBASE_IMAGE% update
@REM docker run --network=database_network --name alpine_liquibase --rm %LIQUIBASE_IMAGE% config

@REM docker run --network=database_network --rm -e LIQUIBASE_URL=jdbc:postgresql://alpine_postgres:5432/postgres  -e LIQUIBASE_USERNAME=postgres -e LIQUIBASE_PASSWORD=postgres %LIQUIBASE_IMAGE% update