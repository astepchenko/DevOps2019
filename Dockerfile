FROM tomcat:8.5-jre8-alpine
LABEL maintainer="Aleksandr Stepchenko"

ARG VERSION

# RUN apk add --no-cache curl
RUN apk add --no-cache wget

RUN echo "${VERSION}"
# RUN curl -v "http://localhost:8081/nexus/content/repositories/snapshots/task7a/${VERSION}/greeter.war" -o /usr/local/tomcat/webapps/greeter.war
RUN wget -v "http://localhost:8081/nexus/content/repositories/snapshots/task7a/${VERSION}/greeter.war" -O /usr/local/tomcat/webapps/greeter.war

# EXPOSE 8080