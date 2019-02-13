FROM jboss/base-jdk:8

ENV WILDFLY_VERSION 15.0.1.Final
ENV WILDFLY_SHA1 23d6a5889b76702fc518600fc5b2d80d6b3b7bb1
ENV WILDFLY_HOME /opt/wildfly
ENV ORACLE_MODULE_HOME ${WILDFLY_HOME}/modules/system/layers/base/com/oracle/db/main/

USER root

RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $WILDFLY_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${WILDFLY_HOME} \
    && chmod -R g+rw ${WILDFLY_HOME} \
    && mkdir -p ${ORACLE_MODULE_HOME} \
    && mkdir -p /var/log/javaee8-wildfly \
    && chmod 777 /var/log/javaee8-wildfly

COPY standalone.xml ${WILDFLY_HOME}/standalone/configuration/
COPY module.xml ojdbc6.jar ${ORACLE_MODULE_HOME}
COPY wait-for-it.sh ${WILDFLY_HOME}/bin

RUN chmod +x ${WILDFLY_HOME}/bin/wait-for-it.sh

ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

EXPOSE 8080

CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
