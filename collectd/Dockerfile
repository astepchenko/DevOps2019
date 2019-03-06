FROM centos
LABEL maintainer="Aleksandr Stepchenko"
LABEL version=1.0

RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y collectd && \
    yum clean all

ENTRYPOINT ["/sbin/collectd"]
CMD ["-f"]