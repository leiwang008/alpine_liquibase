FROM java:jre-alpine

RUN set -x \
    && apk add --no-cache --update --virtual .build-deps openssl

ENV PG_VERSION="42.2.20" \
    LIQUIBASE_VERSION="4.3.5" \
    LIQUIBASE_HOME="/liquibase" \
    LIQUIBASE_DRIVER="org.postgresql.Driver" \
    LIQUIBASE_CLASSPATH="${LIQUIBASE_HOME}/lib/postgresql.jar" \
    LIQUIBASE_URL="jdbc:postgresql://alpine_postgres:5432/postgres" \
    LIQUIBASE_USERNAME="postgres" \
    LIQUIBASE_PASSWORD="postgres" \
    LIQUIBASE_CHANGELOG="changelog.xml" \
    LIQUIBASE_CONTEXTS="" \
    LIQUIBASE_OPTS=""

# Add the liquibase group user and step in the directory
# Make /liquibase directory and change owner to liquibase
RUN set -eux \
    && addgroup -g 1001 -S liquibase \
    && adduser -u 1001 -S -D -G liquibase -H -h ${LIQUIBASE_HOME} -s /bin/sh liquibase \
    && mkdir ${LIQUIBASE_HOME} && chown -R liquibase:liquibase ${LIQUIBASE_HOME}

WORKDIR ${LIQUIBASE_HOME}

#Symbolic link will be broken until later
RUN ln -s ${LIQUIBASE_HOME}/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh \
  && ln -s ${LIQUIBASE_HOME}/docker-entrypoint.sh /docker-entrypoint.sh \
  && ln -s ${LIQUIBASE_HOME}/liquibase /usr/local/bin/liquibase

# Change to the liquibase user
USER liquibase

# Download, verify, extract 'liquibase'
ARG LB_SHA256=5ce62afa9efa5c5b7b8f8a31302959a31e70b1a5ee579a2f701ea464984c0655
RUN set -x \
  && wget -O liquibase-${LIQUIBASE_VERSION}.tar.gz "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" \
  && echo "$LB_SHA256  liquibase-${LIQUIBASE_VERSION}.tar.gz" | sha256sum -c - \
  && tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz \
  && rm liquibase-${LIQUIBASE_VERSION}.tar.gz

# Download JDBC libraries, verify via GPG and checksum
ARG PG_SHA1=36cc2142f46e8f4b77ffc1840ada1ba33d96324f
RUN wget -O ${LIQUIBASE_HOME}/lib/postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar \
	&& wget -O ${LIQUIBASE_HOME}/lib/postgresql.jar.asc https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar.asc \
	&& echo "$PG_SHA1  ${LIQUIBASE_HOME}/lib/postgresql.jar" | sha1sum -c - 


COPY --chown=liquibase:liquibase entrypoint.sh ${LIQUIBASE_HOME}/
COPY --chown=liquibase:liquibase liquibase.sh ${LIQUIBASE_HOME}/
COPY --chown=liquibase:liquibase ${LIQUIBASE_CHANGELOG} ${LIQUIBASE_HOME}/

RUN ls -al ${LIQUIBASE_HOME}

RUN chmod +x ${LIQUIBASE_HOME}/entrypoint.sh \
    && chmod +x ${LIQUIBASE_HOME}/liquibase.sh 

# ENTRYPOINT ["${LIQUIBASE_HOME}/entrypoint.sh"]
ENTRYPOINT ["/liquibase/entrypoint.sh"]

# delete the apk dependencies at the end of building
USER root
RUN apk del --no-cache .build-deps

# docker run -v /home/changelog:/liquibase/changelog liquibase/liquibase --driver=org.postgresql.Driver --url=”jdbc:postgresql://<DATABASE_IP>:5432/postgres”  --changeLogFile=/liquibase/changelog/changelog.xml --username=postgres  --password=postgres