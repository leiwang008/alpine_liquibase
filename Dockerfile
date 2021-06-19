FROM java:jre-alpine

RUN set -x \
    && apk add --no-cache --update --virtual .build-deps openssl tree bash

# cannot refer to a environment when defining another environment
# we have to define some arguments so that we can use them to define environments

# 'alpine_postgres' is the name of the container running postgres database
ARG ARG_POSTGRES_SERVER="alpine_postgres"
ARG ARG_LIQUIBASE_HOME="/liquibase"
# the directory 'changelogs' hold all liquibase changelog files
ARG ARG_LIQUIBASE_CHANGELOG_DIR="changelogs"
# the changelog 'main_changelog.xml' includes all other changelog files
ARG ARG_LIQUIBASE_MAIN_CHANGELOG="main_changelog.xml"

# define environments
ENV PG_VERSION="42.2.20" \
    LIQUIBASE_VERSION="4.3.5" \
    LIQUIBASE_HOME="${ARG_LIQUIBASE_HOME}" \
    LIQUIBASE_DRIVER="org.postgresql.Driver" \
    LIQUIBASE_CLASSPATH="${ARG_LIQUIBASE_HOME}/lib/postgresql.jar" \
    POSTGRES_SERVER="${ARG_POSTGRES_SERVER}" \
    LIQUIBASE_URL="jdbc:postgresql://${ARG_POSTGRES_SERVER}:5432/postgres" \
    LIQUIBASE_USERNAME="postgres" \
    LIQUIBASE_PASSWORD="mypass" \
    LIQUIBASE_CHANGELOG="${ARG_LIQUIBASE_MAIN_CHANGELOG}" \
    LIQUIBASE_CONTEXTS="" \
    LIQUIBASE_HUB_MODE="off" \
    LIQUIBASE_OPTS=""

# Add the 'liquibase' group user
# Make /liquibase, /liquibase/scripts, /liquibase/changelogs directory and change owner as 'liquibase'
RUN set -eux \
    && addgroup -g 1001 -S liquibase \
    && adduser -u 1001 -S -D -G liquibase -H -h ${LIQUIBASE_HOME} -s /bin/sh liquibase \
    && mkdir -p ${LIQUIBASE_HOME} ${LIQUIBASE_HOME}\scripts ${LIQUIBASE_HOME}\${ARG_LIQUIBASE_CHANGELOG_DIR} \
    && chown -R liquibase:liquibase ${LIQUIBASE_HOME}

WORKDIR ${LIQUIBASE_HOME}

#Symbolic link will be broken until later
RUN ln -s ${LIQUIBASE_HOME}/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh \
  && ln -s ${LIQUIBASE_HOME}/docker-entrypoint.sh /docker-entrypoint.sh \
  && ln -s ${LIQUIBASE_HOME}/liquibase /usr/local/bin/liquibase 

# Change to the liquibase user
USER liquibase

# Download, verify, extract 'liquibase'
ARG LB_SHA256=5ce62afa9efa5c5b7b8f8a31302959a31e70b1a5ee579a2f701ea464984c0655
# RUN set -x \
#   && wget -O liquibase-${LIQUIBASE_VERSION}.tar.gz "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" \
#   && echo "$LB_SHA256  liquibase-${LIQUIBASE_VERSION}.tar.gz" | sha256sum -c - \
#   && tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz \
#   && rm liquibase-${LIQUIBASE_VERSION}.tar.gz

COPY --chown=liquibase:liquibase liquibase-*.tar.gz ${LIQUIBASE_HOME}/
RUN set -x \
  && echo "$LB_SHA256  liquibase-${LIQUIBASE_VERSION}.tar.gz" | sha256sum -c - \
  && tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz \
  && rm liquibase-${LIQUIBASE_VERSION}.tar.gz

# Download JDBC libraries, verify via GPG and checksum
ARG PG_SHA1=36cc2142f46e8f4b77ffc1840ada1ba33d96324f
# RUN wget -O ${LIQUIBASE_HOME}/lib/postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar \
# 	&& wget -O ${LIQUIBASE_HOME}/lib/postgresql.jar.asc https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar.asc \
# 	&& echo "$PG_SHA1  ${LIQUIBASE_HOME}/lib/postgresql.jar" | sha1sum -c - 

COPY --chown=liquibase:liquibase postgresql-*.jar ${LIQUIBASE_HOME}/lib/postgresql.jar

# copy scripts to approperiate directories
COPY --chown=liquibase:liquibase *.sh ${LIQUIBASE_HOME}/
COPY --chown=liquibase:liquibase scripts/*.sh ${LIQUIBASE_HOME}/scripts/
RUN chmod a+x ${LIQUIBASE_HOME}/*.sh \
    && chmod a+x ${LIQUIBASE_HOME}/scripts/*.sh

# copy the main changelog to home directory, copy the whole 'changelogs' directory to home directory
COPY --chown=liquibase:liquibase ${ARG_LIQUIBASE_MAIN_CHANGELOG} ${ARG_LIQUIBASE_HOME}/
COPY --chown=liquibase:liquibase ${ARG_LIQUIBASE_CHANGELOG_DIR}/*.xml ${ARG_LIQUIBASE_HOME}/${ARG_LIQUIBASE_CHANGELOG_DIR}/

# RUN ls -al ${LIQUIBASE_HOME}
RUN tree -a

# ENTRYPOINT ["${LIQUIBASE_HOME}/entrypoint.sh"]
# ENTRYPOINT ["/liquibase/entrypoint.sh"]
# ENTRYPOINT ["/liquibase/init.sh"]

# delete the apk dependencies at the end of building
# USER root
# RUN apk del --no-cache .build-deps

# docker run -v /home/changelog:/liquibase/changelog liquibase/liquibase --driver=org.postgresql.Driver --url=”jdbc:postgresql://<DATABASE_IP>:5432/postgres”  --changeLogFile=/liquibase/changelog/changelog.xml --username=postgres  --password=postgres