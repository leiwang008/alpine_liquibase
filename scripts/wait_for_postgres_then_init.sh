#!/usr/bin/env bash

# wait for "postgres database server" is ready, call init.sh to initialize the database on "postgres server"

${LIQUIBASE_HOME}/scripts/wait-for-it.sh ${POSTGRES_SERVER}:5432 -- ${LIQUIBASE_HOME}/scripts/init.sh $@
