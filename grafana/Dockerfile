FROM centos
LABEL maintainer="Aleksandr Stepchenko"
LABEL version=1.0

ENV GF_PATHS_HOME="/usr/share/grafana"

COPY ./grafana.repo /etc/yum.repos.d
RUN yum update -y && \
    yum install -y grafana && \
    yum clean all
COPY ./grafana.ini /etc/grafana

EXPOSE 3000

WORKDIR $GF_PATHS_HOME
ENTRYPOINT ["grafana-server"]