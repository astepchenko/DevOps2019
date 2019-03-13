FROM tomcat:8.5-jre8-alpine
LABEL maintainer="Aleksandr Stepchenko"

ARG VERSION

RUN apk add --no-cache curl
RUN echo "${VERSION}"
RUN curl "http://mate:8081/nexus/content/repositories/snapshots/task7a/${VERSION}/greeter.war" -o /usr/local/tomcat/webapps/greeter.war

# EXPOSE 8080