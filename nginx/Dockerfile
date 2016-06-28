FROM nginx
MAINTAINER swfz <sawafuji.09@gmail.com>

COPY ["./mkdocs.conf", "/etc/nginx/conf.d/mkdocs.conf"]
COPY ["./elasticsearch.conf", "/etc/nginx/conf.d/elasticsearch.conf"]

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
