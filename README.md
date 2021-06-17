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

Expecting the `changelog.xml` is inside the current directory the update process can be started with:

```
docker run --rm \
    -v "$(pwd)":/liquibase/ \
    -e LIQUIBASE_URL=jdbc:postgresql://alpine_postgres:5432/postgres \
    -e LIQUIBASE_USERNAME=postgres \
    -e LIQUIBASE_PASSWORD=postgres \
    leiwang008/alpine_liquibase update
```


Environment variables
---------------------

| Environment variable  | Description                        | Default                               |
|-----------------------|------------------------------------|---------------------------------------|
| `LIQUIBASE_VERSION`   | Installed Liquibase version        | *not changeable*                      |
| `POSTGRES_SERVER`     | postgres host name                 | *alpine_postgres*                     |
| `LIQUIBASE_URL`       | DB url                             | *jdbc:postgresql://${POSTGRES_SERVER}:5432/postgres* (eg. `jdbc:postgresql://host:port/database`) |
| `LIQUIBASE_USERNAME`  | DB username                        | *postgres*                            |
| `LIQUIBASE_PASSWORD`  | DB password                        | *postgres*                            |
| `LIQUIBASE_CHANGELOG` | Changelog file                     | `/liquibase/changelog.xml`            |
| `LIQUIBASE_CONTEXTS`  | Server contexts                    | *empty*                               |
| `LIQUIBASE_OPTS`      | Additional options                 | *empty*                               |

Reference
---------
> https://www.liquibase.org/  
  https://github.com/mobtitude/liquibase  
  https://github.com/liquibase/docker  
  https://docs.liquibase.com/workflows/liquibase-community/using-liquibase-and-docker.html  
  https://github.com/liquibase/liquibase/releases  
  http://www.manongjc.com/article/35945.html  
  https://blog.csdn.net/li_w_ch/article/details/109125209  
  


