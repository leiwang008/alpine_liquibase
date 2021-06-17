#!/usr/bin/env bash

/liquibase/liquibase \
    --driver=$LIQUIBASE_DRIVER \
    --url=$LIQUIBASE_URL \
    --classpath=$LIQUIBASE_CLASSPATH \
    --changeLogFile=$LIQUIBASE_HOME/$LIQUIBASE_CHANGELOG \
    --username=$LIQUIBASE_USERNAME \
    --password=$LIQUIBASE_PASSWORD \
    --contexts="$LIQUIBASE_CONTEXTS" \
    update
