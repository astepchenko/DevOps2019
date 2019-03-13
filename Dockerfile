FROM tomcat:8.5-jre8-alpine
LABEL maintainer="Aleksandr Stepchenko"

ARG VERSION=1.0.0

RUN apk add --no-cache curl
RUN curl -s http://localhost:8081/nexus/content/repositories/snapshots/task7a/${VERSION}/greeter.war -o /usr/local/tomcat/webapps/greeter.war

# EXPOSE 8080