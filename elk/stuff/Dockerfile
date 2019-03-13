FROM centos
LABEL maintainer="Aleksandr Stepchenko"
LABEL version=1.1

RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y httpd && \
    yum install -y https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.6.1-x86_64.rpm && \
    yum install -y supervisor && \
    yum clean all

ADD filebeat.yml /etc/filebeat/filebeat.yml
RUN chmod go-w /etc/filebeat/filebeat.yml

ADD supervisord.conf /etc/supervisord.conf
ADD httpd.conf /etc/httpd/conf/httpd.conf

EXPOSE 80

ENTRYPOINT ["/usr/bin/supervisord"]