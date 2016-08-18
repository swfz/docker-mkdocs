FROM elasticsearch:latest
MAINTAINER swfz <sawafuji.09@gmail.com>

RUN /usr/share/elasticsearch/bin/plugin install analysis-kuromoji
RUN /usr/share/elasticsearch/bin/plugin install royrusso/elasticsearch-HQ
RUN /usr/share/elasticsearch/bin/plugin install lmenezes/elasticsearch-kopf
RUN /usr/share/elasticsearch/bin/plugin install polyfractal/elasticsearch-inquisitor

COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

EXPOSE 9200 9300
