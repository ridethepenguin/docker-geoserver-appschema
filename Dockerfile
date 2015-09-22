#--------- Generic stuff --------------------------------------------------------------------
FROM tomcat:6.0
MAINTAINER Stefano Costa <stefano.costa@geo-solutions.it>

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get -y install unzip

ADD resources /tmp/resources

# Fetch the geoserver zip file if it is not available locally in the resources dir
RUN if [ ! -f /tmp/resources/geoserver.zip ]; then \
    wget -c http://ares.boundlessgeo.com/geoserver/release/2.8-RC1/geoserver-2.8-RC1-war.zip -O /tmp/resources/geoserver.zip; \
    fi; \
    mkdir /tmp/resources/geoserver && cd /tmp/resources/geoserver && unzip ../geoserver.zip; \
    mv -v geoserver.war /usr/local/tomcat/webapps && mkdir /usr/local/tomcat/webapps/geoserver && cd /usr/local/tomcat/webapps/geoserver && unzip ../geoserver.war; \
    rm -rf /tmp/resources/geoserver;

# Fetch the geoserver app-schema plugin zip file if it is not available locally in the resources dir
RUN if [ ! -f /tmp/resources/app-schema-plugin.zip ]; then \
    wget -c http://ares.boundlessgeo.com/geoserver/release/2.8-RC1/plugins/geoserver-2.8-RC1-app-schema-plugin.zip -O /tmp/resources/app-schema-plugin.zip; \
    fi; \
    mkdir /tmp/resources/app-schema && cd /tmp/resources/app-schema && unzip ../app-schema-plugin.zip; \
    mv -v *.jar /usr/local/tomcat/webapps/geoserver/WEB-INF/lib; \
    rm -rf /tmp/resources/app-schema;

EXPOSE 8080
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
