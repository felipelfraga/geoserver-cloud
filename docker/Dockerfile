FROM tomcat:9.0.69-jdk17

ARG GEOSERVER_VERSION

RUN curl -#Lo "/tmp/geoserver-${GEOSERVER_VERSION}-war.zip" \
    "https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip"

#Sem unzip na imagem final. Extraindo com o jar.
RUN jar xvf /tmp/geoserver-${GEOSERVER_VERSION}-war.zip && \
    rm -rf /tmp/geoserver-${GEOSERVER_VERSION}-war.zip && \
    mv geoserver.war $CATALINA_HOME/webapps

RUN mkdir /var/lib/geoserver_data
ENV GEOSERVER_DATA_DIR=/var/lib/geoserver_data

ADD config/data /var/lib/geoserver_data
