FROM alpine 
MAINTAINER "Nono Elvadas" 


ENV FLYWAY_VERSION=7.8.1

ENV FLYWAY_HOME=/opt/flyway/$FLYWAY_VERSION  \
    FLYWAY_PKGS="https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz"


LABEL com.redhat.component="flyway" \
      io.k8s.description="Platform for upgrading database using flyway" \
      io.k8s.display-name="DB Migration with flyway	" \
      io.openshift.tags="builder,sql-upgrades,flyway,db,migration" 


RUN apk add --update \
       openjdk8-jre \
        wget \
        bash

RUN apk install zip unzip -y

#Download and flyway
RUN wget --no-check-certificate  $FLYWAY_PKGS &&\
   mkdir -p $FLYWAY_HOME && \
   mkdir -p /var/flyway/data  && \
   tar -xzf flyway-commandline-$FLYWAY_VERSION.tar.gz -C $FLYWAY_HOME  --strip-components=1

COPY docker-entrypoint.sh /
RUN chmod 777 /docker-entrypoint.sh

VOLUME /var/flyway/data

ENTRYPOINT ["/docker-entrypoint.sh"]
