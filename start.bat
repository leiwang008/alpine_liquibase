
@echo off

echo "Create a network 'rt_database' so that the containers can connect each other by container's name"
docker network create rt_database

echo "Create a postgres database 'alpine_postgres' in network 'rt_database'
docker run --network=rt_database --name alpine_postgres --publish 5432:5432 -e POSTGRES_PASSWORD=mypass -d leiwang008/alpine_postgres postgres


echo "Create a liquibase 'alpine_liquibase' in network 'rt_database' to update database in 'alpine_postgres'
docker run --network=rt_database --name alpine_liquibase --rm  leiwang008/alpine_liquibase update
@REM docker run --network=rt_database --name alpine_liquibase --rm -e LIQUIBASE_CHANGELOG=/liquibase/changelog.txt leiwang008/alpine_liquibase update
@REM docker run --network=rt_database --name alpine_liquibase --rm leiwang008/alpine_liquibase showConf

@REM docker run --network=rt_database --rm -e LIQUIBASE_URL=jdbc:postgresql://alpine_postgres:5432/postgres  -e LIQUIBASE_USERNAME=postgres -e LIQUIBASE_PASSWORD=postgres leiwang008/alpine_liquibase update