FROM webhippie/php-nginx:latest-alpine

ENV INSTALL=true
ENV MODIFY=false

WORKDIR /dujiaoka

COPY dujiaoka/ /dujiaoka
COPY ./conf/default.conf /opt/docker/etc/nginx/vhost.conf
COPY ./conf/dujiao.conf /opt/docker/etc/supervisor.d/
# COPY ./modify/StripeController.php /dujiaoka/app/Http/Controllers/Pay/StripeController.php
COPY ./modify /dujiaoka/modify
COPY start.sh /

RUN set -xe \
    && composer install -vvv \
    && chmod +x /start.sh \
    && chown -R application:application /dujiaoka/ \
    && chmod -R 0755 /dujiaoka/ \
    && mv /dujiaoka/storage /dujiaoka/storage_bak \
    && sed -i "s?\$proxies;?\$proxies=\'\*\*\';?" /dujiaoka/app/Http/Middleware/TrustProxies.php \
    && rm -rf /root/.composer/cache/ /tmp/*

CMD /start.sh
