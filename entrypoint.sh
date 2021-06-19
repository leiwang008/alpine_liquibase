#!/usr/bin/env sh

set -o pipefail
set -o nounset
set -o errexit

# set configuration file
configFile=${LIQUIBASE_HOME}/liquibase.properties

LIQUIBASE_OPTS="$LIQUIBASE_OPTS --defaultsFile=${configFile}"

rm -f ${configFile}
touch ${configFile}

## Database driver
if [ -n "$LIQUIBASE_DRIVER" ]; then
    echo "driver: ${LIQUIBASE_DRIVER}" >> ${configFile}
fi

## Classpath
if [ -n "$LIQUIBASE_CLASSPATH" ]; then
    echo "classpath: ${LIQUIBASE_CLASSPATH}" >> ${configFile}
fi

## Database url
if [ -n "$LIQUIBASE_URL" ]; then
    echo "url: ${LIQUIBASE_URL}" >> ${configFile}
fi

## Database username
if [ -n "$LIQUIBASE_USERNAME" ]; then
    echo "username: ${LIQUIBASE_USERNAME}" >> ${configFile}
fi

## Database password
if [ -n "$LIQUIBASE_PASSWORD" ]; then
    echo "password: ${LIQUIBASE_PASSWORD}" >> ${configFile}
fi

## Database contexts
if [ -n "$LIQUIBASE_CONTEXTS" ]; then
    echo "contexts: ${LIQUIBASE_CONTEXTS}" >> ${configFile}
fi

## Database changelog file
if [ -n "$LIQUIBASE_CHANGELOG" ]; then
    echo "changeLogFile: ${LIQUIBASE_CHANGELOG}" >> ${configFile}
fi

## Hub mode
if [ -n "$LIQUIBASE_HUB_MODE" ]; then
    echo "liquibase.hub.mode: ${LIQUIBASE_HUB_MODE}" >> ${configFile}
fi

TASK=""
if [ $# -gt 0 ]; then
    TASK="$1"
fi

case "$TASK" in
    ## show configuration
    conf)
        echo "============================================    ${configFile}  ================================================"
        cat ${configFile}
        echo "==============================================================================================================="
        ;;

    ## start a bash terminal
    bash)
        bash
        ;;

    ## Default task - execute liquibase
    *)
        # shellcheck disable=SC2086
        ${LIQUIBASE_HOME}/liquibase $LIQUIBASE_OPTS "$@"
        ;;
esac