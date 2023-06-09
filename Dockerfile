FROM alpine:3.14

RUN apk add --no-cache \
    gettext \
    nginx \
    nginx-mod-http-set-misc \
    nginx-mod-http-image-filter && \
    mkdir -p /run/nginx && \
    mkdir -p /var/cache/nginx/static && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY docker/nginx/http.d/default.conf.template /etc/nginx/http.d/default.conf.template

COPY docker/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
