FROM java:jre-alpine

RUN set -x \
    && apk add --no-cache --update --virtual .build-deps openssl \
    && apk del --no-cache .build-deps

ENV MYSQL_CONNECTOR_VERSION=8.0.15 \
    LIQUIBASE_HOME="/liquibase" \
    LIQUIBASE_VERSION="3.5.5" \
    LIQUIBASE_DRIVER="org.postgresql.Driver" \
    LIQUIBASE_CLASSPATH="/liquibase/lib/postgresql.jar" \
    LIQUIBASE_URL="jdbc:postgresql://postgres_host:5432/postgres" \
    LIQUIBASE_USERNAME="postgres" \
    LIQUIBASE_PASSWORD="postgres" \
    LIQUIBASE_CHANGELOG="liquibase.xml" \
    LIQUIBASE_CONTEXTS="" \
    LIQUIBASE_OPTS=""

# Add the liquibase user and step in the directory
RUN addgroup --gid 1001 liquibase
RUN adduser --disabled-password --uid 1001 --ingroup liquibase liquibase

# Make /liquibase directory and change owner to liquibase
RUN mkdir /liquibase && chown liquibase /liquibase
WORKDIR /liquibase

#Symbolic link will be broken until later
RUN ln -s /liquibase/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh \
  && ln -s /liquibase/docker-entrypoint.sh /docker-entrypoint.sh \
  && ln -s /liquibase/liquibase /usr/local/bin/liquibase

# Change to the liquibase user
USER liquibase

# Download, verify, extract 'liquibase'
ARG LIQUIBASE_VERSION=4.3.5
ARG LB_SHA256=5ce62afa9efa5c5b7b8f8a31302959a31e70b1a5ee579a2f701ea464984c0655
RUN set -x \
  && wget -O liquibase-${LIQUIBASE_VERSION}.tar.gz "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz" \
  && echo "$LB_SHA256  liquibase-${LIQUIBASE_VERSION}.tar.gz" | sha256sum -c - \
  && tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz \
  && rm liquibase-${LIQUIBASE_VERSION}.tar.gz

# Download JDBC libraries, verify via GPG and checksum
ARG PG_VERSION=42.2.20
ARG PG_SHA1=36cc2142f46e8f4b77ffc1840ada1ba33d96324f
RUN wget --no-verbose -O /liquibase/lib/postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar \
	&& wget --no-verbose -O /liquibase/lib/postgresql.jar.asc https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_VERSION}/postgresql-${PG_VERSION}.jar.asc \
    && gpg --auto-key-locate keyserver --keyserver ha.pool.sks-keyservers.net --keyserver-options auto-key-retrieve --verify /liquibase/lib/postgresql.jar.asc /liquibase/lib/postgresql.jar \
	&& echo "$PG_SHA1  /liquibase/lib/postgresql.jar" | sha1sum -c - 


COPY --chown=liquibase:liquibase entrypoint.sh /liquibase/
COPY --chown=liquibase:liquibase liquibase.sh /liquibase/

RUN chmod +x /liquibase/entrypoint.sh \
    chmod +x /liquibase/liquibase.sh 

ENTRYPOINT ["/liquibase/entrypoint.sh"]

# docker run -v /home/changelog:/liquibase/changelog liquibase/liquibase --driver=org.postgresql.Driver --url=”jdbc:postgresql://<DATABASE_IP>:5432/postgres”  --changeLogFile=/liquibase/changelog/changelog.xml --username=postgres  --password=postgres