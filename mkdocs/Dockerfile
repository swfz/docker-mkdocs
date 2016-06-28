FROM centos:centos7

MAINTAINER swfz <sawafuji.09@gmail.com>

RUN yum install -y python-setuptools gcc openssl-devel
RUN easy_install pip
RUN pip install mkdocs

WORKDIR /docs/sample

VOLUME /docs/sample

EXPOSE 8000

ENTRYPOINT ["mkdocs"]

CMD ["-h"]
