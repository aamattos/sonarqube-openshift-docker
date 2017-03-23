FROM jboss/base-jdk:8
MAINTAINER Andres Mattos <andres.mattos@isban.pt>

ENV SONAR_VERSION=6.3 \
    SONARQUBE_HOME=/opt/sonarqube

USER root
EXPOSE 9000
ADD root /
RUN cd /tmp \
    && curl -o sonarqube.zip -fSL https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && cd /opt \
    && unzip /tmp/sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && rm /tmp/sonarqube.zip* \    
    && mkdir -p $SONARQUBE_HOME/extensions/plugins
        
COPY run.sh $SONARQUBE_HOME/bin/

RUN useradd -r sonar
RUN /usr/bin/fix-permissions /opt/sonarqube \
    && chmod 775 $SONARQUBE_HOME/bin/run.sh
    
VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions", "$SONARQUBE_HOME/conf", "$SONARQUBE_HOME/lib/bundled-plugins"]

USER sonar
WORKDIR $SONARQUBE_HOME
ENTRYPOINT ["./bin/run.sh"]
