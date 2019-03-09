FROM centos
LABEL maintainer="Aleksandr Stepchenko"
LABEL version=1.0

RUN yum update -y && \
    yum install -y https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.6.1-x86_64.rpm && \
    yum clean all

ADD filebeat.yml /etc/filebeat/filebeat.yml

ENTRYPOINT ["filebeat"]
CMD ["-e"]