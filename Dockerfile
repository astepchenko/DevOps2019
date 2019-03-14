FROM tomcat:8.5-jre8-alpine
LABEL maintainer="Aleksandr Stepchenko"

ARG VERSION

RUN apk add --no-cache curl && \
    HOSTIP=$(ip route show | awk '/default/ {print $3}') && \
    curl -v "http://${HOSTIP}:8081/nexus/content/repositories/snapshots/task7a/${VERSION}/greeter.war" -o /usr/local/tomcat/webapps/greeter.war