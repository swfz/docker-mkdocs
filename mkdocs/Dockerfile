FROM centos:centos7

MAINTAINER swfz <sawafuji.09@gmail.com>

# ARG project

RUN yum install -y python-setuptools gcc openssl-devel curl-devel make git crontabs

# using markdown to elasticsearh script
RUN curl -LO https://github.com/jpmens/jo/releases/download/v1.0/jo-1.0.tar.gz && \
    tar zxvf jo-1.0.tar.gz && \
    cd jo-1.0 && \
    ./configure && \
    make check && \
    make install

ENV ENTRYKIT_VERSION 0.4.0

RUN curl -LO https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \ 
    tar zxvf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
    mv entrykit /bin/entrykit && \
    chmod +x /bin/entrykit && \
    entrykit --symlink

RUN easy_install pip
RUN pip install mkdocs
#RUN echo '*/30 * * * * root exec /md2es.sh ${project:-sample}' >> /etc/crontab
RUN echo '*/10 * * * * root exec /md2es.sh sample' >> /etc/crontab

COPY entrypoint.sh /entrypoint.sh
COPY md2es.sh /md2es.sh
COPY reveal.sh /reveal.sh
COPY config.js.tmpl /config.js.tmpl

#WORKDIR /docs/${project:-sample}
#VOLUME /docs/${project:-sample}

WORKDIR /docs/sample
VOLUME /docs/sample

EXPOSE 8000 8001

ENTRYPOINT [ \
  "render", "/config.js", "--", \
  "prehook", "cp /config.js /docs/sample/custom/js/config.js", "--", \
  "bash", "/entrypoint.sh" \
]

CMD ["-h"]

