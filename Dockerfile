FROM tomcat:8.5-jre8-alpine
LABEL maintainer="Aleksandr Stepchenko"

ARG VER

RUN apk add --no-cache curl
RUN echo ${VER}
RUN curl http://localhost:8081/nexus/content/repositories/snapshots/task7a/${VER}/greeter.war -o /usr/local/tomcat/webapps/greeter.war

# EXPOSE 8080