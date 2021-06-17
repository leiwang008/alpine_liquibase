#!/usr/bin/env bash
/opt/docker/scripts/wait-for-it.sh $LQ_POSTGRES_SERVER:5432 -- /opt/docker/scripts/init.sh
