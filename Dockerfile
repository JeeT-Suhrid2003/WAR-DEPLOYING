FROM tomcat:10.1-jre21-temurin AS tomcat

FROM eclipse-temurin:21-jre-alpine

RUN apk add --no-cache bash

ENV CATALINA_HOME=/opt/tomcat
ENV PATH="${CATALINA_HOME}/bin:${PATH}"

COPY --from=tomcat /usr/local/tomcat/bin /opt/tomcat/bin
COPY --from=tomcat /usr/local/tomcat/conf /opt/tomcat/conf
COPY --from=tomcat /usr/local/tomcat/lib /opt/tomcat/lib

COPY testapp.war /opt/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]