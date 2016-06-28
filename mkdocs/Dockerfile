FROM centos:centos7

MAINTAINER swfz <sawafuji.09@gmail.com>

RUN yum install -y python-setuptools gcc openssl-devel curl-devel make

# using markdown to elasticsearh script
RUN curl -LO https://github.com/jpmens/jo/releases/download/v1.0/jo-1.0.tar.gz && \
    tar zxvf jo-1.0.tar.gz && \
    cd jo-1.0 && \
    ./configure && \
    make check && \
    make install

RUN easy_install pip
RUN pip install mkdocs

COPY entrypoint.sh /entrypoint.sh
COPY md2es.sh /md2es.sh

WORKDIR /docs/sample

VOLUME /docs/sample

EXPOSE 8000

ENTRYPOINT ["bash", "/entrypoint.sh"]
#ENTRYPOINT ["mkdocs"]

CMD ["-h"]

