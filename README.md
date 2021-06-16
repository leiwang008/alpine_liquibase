mobtitude/liquibase
===================

The [Liquibase](http://www.liquibase.org) docker image, based on `java:jre-alpine` with postgres driver.

This image is inspired by `mobtitude/liquibase`.

Usage
-----

Expecting the `changelog.xml` is inside the current directory the update process can be started with:

```
docker run --rm \
    -v "$(pwd)":/liquibase/ \
    -e LIQUIBASE_URL=jdbc:postgresql://postgres_host:5432/postgres \
    -e LIQUIBASE_USERNAME=postgres \
    -e LIQUIBASE_PASSWORD=postgres \
    leiwang008/liquibase update
```


Environment variables
---------------------

| Environment variable  | Description                        | Default                               |
|-----------------------|------------------------------------|---------------------------------------|
| `LIQUIBASE_VERSION`   | Installed Liquibase version        | *not changeable*                      |
| `LIQUIBASE_URL`       | DB url                             | *jdbc:postgresql://postgres_host:5432/postgres* (eg. `jdbc:postgresql://host:port/database`) |
| `LIQUIBASE_USERNAME`  | DB username                        | *postgres*                               |
| `LIQUIBASE_PASSWORD`  | DB password                        | *postgres*                               |
| `LIQUIBASE_CHANGELOG` | Changelog file                     | `/liquibase/changelog.xml`            |
| `LIQUIBASE_CONTEXTS`  | Server contexts                    | *empty*                               |
| `LIQUIBASE_OPTS`      | Additional options                 | *empty*                               |

