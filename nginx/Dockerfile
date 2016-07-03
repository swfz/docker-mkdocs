FROM nginx
MAINTAINER swfz <sawafuji.09@gmail.com>

COPY ["./nginx.conf", "/etc/nginx/nginx.conf"]

RUN rm /etc/nginx/conf.d/default.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
