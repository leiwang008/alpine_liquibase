leiwang008/alpine_liquibase
===========================

The [Liquibase](http://www.liquibase.org) docker image, based on `java:jre-alpine` with postgres driver.

This image is inspired by [mobtitude/liquibase](https://github.com/mobtitude/liquibase).

Build
-----

```
docker build -t leiwang008/alpine_liquibase .
```


Usage
-----

+ prerequisite  
  + Expecting an alpine postgres image **alpine_postgres** is running in network **database_network**  

        //create a network database_network
        docker network create database_network  
        //run in detached mode
        docker run --network=database_network --name alpine_postgres --publish 5432:5432 -e POSTGRES_PASSWORD=mypass -d leiwang008/alpine_postgres postgres
        //or run in interactive mode
        docker run --network=database_network --name alpine_postgres --publish 5432:5432 -e POSTGRES_PASSWORD=mypass --rm -it leiwang008/alpine_postgres postgres

  + Expecting the changelog files `changelog1.xml`, `changelog2.xml` etc. are inside the directory **changelogs** which the liquibase 'update process' can run with. User can add more changelog file into that folder.


1. Start the image with a bash terminal, user can inspect the image.

    ```
    docker run --rm --network=database_network -v "<changelogs absolute dir>":/liquibase/changelogs -it leiwang008/alpine_liquibase bash
    ```

2. Showing the configurations

    ```
    docker run --rm --network=database_network -v "<changelogs absolute dir>":/liquibase/changelogs leiwang008/alpine_liquibase conf
    ```

3. Update database in 'alpine_postgres' by changelog files in folder 'changelogs'

    ```
    docker run --rm --network=database_network -v "<changelogs absolute dir>":/liquibase/changelogs leiwang008/alpine_liquibase update
    ```

4. Update database in 'alpine_postgres' by changelog files in folder 'changelogs' with more environment settings
    ```
    docker run --rm \
        --network=database_network \
        -v "<changelogs absolute dir>":/liquibase/changelogs \
        -e LIQUIBASE_URL=jdbc:postgresql://alpine_postgres:5432/postgres \
        -e LIQUIBASE_USERNAME=postgres \
        -e LIQUIBASE_PASSWORD=mypass \
        leiwang008/alpine_liquibase update
    ```

Environment variables
---------------------

| Environment variable  | Description                        | Default                                                                                            |
|-----------------------|------------------------------------|----------------------------------------------------------------------------------------------------|
| `LIQUIBASE_VERSION`   | Installed Liquibase version        | *not changeable*  (4.3.5)                                                                          |
| `PG_VERSION`          | Postgres connector jar version     | *not changeable*  (42.2.20)                                                                        |
| `POSTGRES_SERVER`     | Postgres host name                 | *alpine_postgres*                                                                                  |
| `LIQUIBASE_DRIVER`    | database driver's name             | *org.postgresql.Driver*                                                                            |
| `LIQUIBASE_CLASSPATH` | Postgres connector jar             | */liquibase/lib/postgresql.jar*                                                                    |
| `LIQUIBASE_URL`       | DB url                             | *jdbc:postgresql://${POSTGRES_SERVER}:5432/postgres* (eg. `jdbc:postgresql://host:port/database`)  |
| `LIQUIBASE_USERNAME`  | DB username                        | *postgres*                                                                                         |
| `LIQUIBASE_PASSWORD`  | DB password                        | *mypass*                                                                                           |
| `LIQUIBASE_CHANGELOG` | Changelog file                     | `classpath:/liquibase/changelogs/main.xml`                                                         |
| `LIQUIBASE_CONTEXTS`  | Server contexts                    | *empty*                                                                                            |
| `LIQUIBASE_HUB_MODE`  | If need hub dashboard              | *off* (on | off)                                                                                   |
| `LIQUIBASE_OPTS`      | Additional options                 | *empty*  refer to https://docsstage.liquibase.com/tools-integrations/cli/home.html                 |


Reference
---------
> https://www.liquibase.org/  
  https://docsstage.liquibase.com/tools-integrations/cli/home.html  
  https://docs.liquibase.com/commands/community/home.html  
  https://docs.liquibase.com/commands/pro/home.html  
  https://github.com/mobtitude/liquibase  
  https://github.com/liquibase/docker  
  https://docs.liquibase.com/workflows/liquibase-community/using-liquibase-and-docker.html  
  https://github.com/liquibase/liquibase/releases  
  http://www.manongjc.com/article/35945.html  
  https://blog.csdn.net/li_w_ch/article/details/109125209  
  


