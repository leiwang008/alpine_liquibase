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

+ **prerequisite**  
  + Expecting an alpine postgres image **alpine_postgres** is running in network **database_network**  

        //create a network database_network
        docker network create database_network  
        //run in detached mode
        docker run --network=database_network --name alpine_postgres --publish 5432:5432 -e POSTGRES_PASSWORD=mypass -d leiwang008/alpine_postgres postgres
        //or run in interactive mode
        docker run --network=database_network --name alpine_postgres --publish 5432:5432 -e POSTGRES_PASSWORD=mypass --rm -it leiwang008/alpine_postgres postgres

  + Expecting the changelog files `changelog1.xml`, `changelog2.xml` etc. are inside the directory **changelogs** which the liquibase 'update process' can run with. User can add more changelog file into that folder. When running this image, user can map this folder to container's folder '/liquibase/changelogs' by **-v "\<changelogs absolute dir\>":/liquibase/changelogs**


1. **Update database** in 'alpine_postgres' by changelog files in folder 'changelogs'

    ```
    docker run --rm --network=database_network -v "<changelogs absolute dir>":/liquibase/changelogs leiwang008/alpine_liquibase update
    ```

2. **Update database** in 'alpine_postgres' by changelog files in folder 'changelogs' with more environment settings (if the postgres database is started with different parameters other than default, we should start the liquibase with those parameters by environments)
    ```
    docker run --rm \
        --network=database_network \
        -v "<changelogs absolute dir>":/liquibase/changelogs \
        -e LIQUIBASE_URL=jdbc:postgresql://alpine_postgres_host:5432/postgres_db \
        -e LIQUIBASE_USERNAME=postgres_user \
        -e LIQUIBASE_PASSWORD=secretpass \
        leiwang008/alpine_liquibase update
    ```

3. Showing the configurations

    ```
    docker run --rm --network=database_network -v "<changelogs absolute dir>":/liquibase/changelogs leiwang008/alpine_liquibase conf
    ```

4. Start the image with a bash terminal, user can inspect the image.

    ```
    docker run --rm --network=database_network -v "<changelogs absolute dir>":/liquibase/changelogs -it leiwang008/alpine_liquibase bash
    ```


Usage with batch scripts
------------------------
1. create network and start images 

  ```
  start.bat
  ``` 

2. stop and remove containers, and remove network

  ```
  stop.bat
  ``` 

Usage with docker compose (see docker-compose.yaml)
---------------------------------------------------
1. build docker images, the proejct 'alpine_postgres' should be in the same parent-folder as this project

  ```
  docker-compose build
  ```

2. start the images

  ```
  docker-compose up -d
  ```

3. stop the containers

  ```
  docker-compose down
  ```

Environment variables
---------------------

| Environment variable  | Description                        | Default                                                                                            |
|-----------------------|------------------------------------|----------------------------------------------------------------------------------------------------|
| `LIQUIBASE_VERSION`   | Installed Liquibase version        | **4.3.5** (not changeable)                                                                         |
| `POSTGRES_VERSION`    | Postgres connector jar version     | **42.2.20** (not changeable)                                                                       |
| `POSTGRES_SERVER`     | Postgres host name                 | **alpine_postgres**                                                                                |
| `POSTGRES_DB`         | name of database to use            | **postgres**                                                                                       |
| `POSTGRES_USER`       | DB username                        | **postgres**                                                                                       |
| `POSTGRES_PASSWORD`   | DB password                        | **mypass**                                                                                         |
| `LIQUIBASE_DRIVER`    | database driver's name             | **org.postgresql.Driver**  (not changeable)                                                        |
| `LIQUIBASE_CLASSPATH` | Postgres connector jar             | **/liquibase/lib/postgresql.jar**                                                                  |
| `LIQUIBASE_URL`       | DB url                             | "" (eg. `jdbc:postgresql://alpine_postgres_host:5432/dbname`)                                      |
| `LIQUIBASE_CHANGELOG` | Changelog file                     | **main_changelog.xml**                                                                             |
| `LIQUIBASE_CONTEXTS`  | Server contexts                    | ""                                                                                                 |
| `LIQUIBASE_HUB_MODE`  | If need hub dashboard              | **off** (on \| off)                                                                                |
| `LIQUIBASE_OPTS`      | Additional options                 | ""  (refer to https://docsstage.liquibase.com/tools-integrations/cli/home.html)                    |


  **NOTE:** <br/>
  <ol>
  <li>The environment '<b>POSTGRES_SERVER</b>' and '<b>POSTGRES_DB</b>' will be used to form a URL "jdbc:postgresql://${<b>POSTGRES_SERVER</b>}:5432/<b>POSTGRES_DB</b>" for liquibase to connect
  <li>If the environment '<b>LIQUIBASE_URL</b>' is defined, it will be used at the first place for liquibase to connect, '<b>POSTGRES_SERVER</b>' and '<b>POSTGRES_DB</b>' will be ignored.
  <li>'<b>POSTGRES_DB</b>', '<b>POSTGRES_USER</b>' and '<b>POSTGRES_PASSWORD</b>' should contain the same value for starting the 'alpine_postgres' database.
  </ol>

Reference
---------
> liquibase  
  https://www.liquibase.org/  
  https://docsstage.liquibase.com/tools-integrations/cli/home.html  
  https://docs.liquibase.com/commands/community/home.html  
  https://docs.liquibase.com/commands/pro/home.html  
  https://github.com/mobtitude/liquibase  
  https://github.com/liquibase/docker  
  https://docs.liquibase.com/workflows/liquibase-community/using-liquibase-and-docker.html  
  https://github.com/liquibase/liquibase/releases  
  http://www.manongjc.com/article/35945.html  
  https://blog.csdn.net/li_w_ch/article/details/109125209  

> docker compose  
  https://docs.docker.com/compose/  
  https://docs.docker.com/compose/compose-file/  
  https://docs.docker.com/compose/networking/  
  https://docs.docker.com/compose/startup-order/  
  https://www.cnblogs.com/ray-mmss/p/10868754.html  
  https://www.cnblogs.com/g2thend/p/11746679.html  
  https://blog.csdn.net/qq_36148847/article/details/79427878  

