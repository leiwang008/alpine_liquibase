#!/usr/bin/env bash
/opt/liquibase/liquibase \
    --driver=org.postgresql.Driver \
    --url=$LQ_POSTGRES_URL \
    --classpath=/usr/share/java/postgresql.jar \
    --changeLogFile=/liquibase/changelog.yaml \
    --username=$LQ_POSTGRES_USER \
    --password=$LQ_POSTGRES_PASSWORD \
    --contexts="$LQ_CONTEXT" \
    update
