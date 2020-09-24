FROM alpine:3.12

LABEL maintainer="JJTC <oci@jjtc.eu>"

ENV PPM_VERSION=2.1.3 \
    PPM_HTTP_VERSION=2.0.6 \
    BOOKSTACK=BookStack \
    BOOKSTACK_VERSION=0.30.0 \
    BOOKSTACK_HOME="/app"

COPY entrypoint.sh /app/entrypoint.sh

RUN set -ex \
  && chmod +x /app/entrypoint.sh \
  # ensure www-data user exists
  # 82 is the standard uid/gid for "www-data" in Alpine
  && addgroup -g 82 -S www-data \
  && adduser -u 82 -D -S -G www-data www-data \
  && addgroup -S bookstack \
  && adduser -S -D -H -s /sbin/nologin  -G bookstack  -g bookstack bookstack \
  && apk update \
  && echo "Setting up PHP extensions" \
  && apk add --no-cache \
     curl \
     multirun \
     nginx \
     tar \
     php7 \
     php7-cgi \
     php7-ctype \
     php7-curl \
     php7-dom \
     php7-exif \
     php7-fileinfo \
     php7-gd \
     php7-iconv \
     php7-intl \
     php7-json \
     php7-ldap \
     php7-mbstring \
     php7-mcrypt \
     php7-opcache \
     php7-openssl \
     php7-pcntl \
     php7-pdo_mysql \
     php7-pecl-imagick \
     php7-phar \
     php7-posix \
     php7-redis \
     php7-session \
     php7-simplexml \
     php7-sockets \
     php7-tidy \
     php7-tokenizer \
     php7-xml \
     php7-xmlwriter \
     php7-zip \
     php7-zlib \
     composer \
  && echo "Setting up PPM:" \
  && mkdir -p /ppm/run \
  && cd /ppm \
  && chmod -R 777 run/ \
  && composer require php-pm/php-pm:${PPM_VERSION} php-pm/httpkernel-adapter:${PPM_HTTP_VERSION} \
  && chown www-data:www-data -R . \
  && echo "Get BookStack:" \
  && mkdir -p ${BOOKSTACK_HOME} \
  && cd ${BOOKSTACK_HOME} \
  && curl -LJO https://github.com/BookStackApp/BookStack/archive/v${BOOKSTACK_VERSION}.tar.gz \
  && tar --strip-components=1 -xzf BookStack-${BOOKSTACK_VERSION}.tar.gz \
  && rm -rf ${BOOKSTACK}-${BOOKSTACK_VERSION}.tar.gz .env.example .env.example.complete .gitattributes .github .gitignore .travis.yml tests/ public/index.php \
  && ln -s init.php bootstrap/autoload.php \
  && echo "Get Dependencies:" \
  && composer install \
  && echo "Changing ownership:" \
  && chown bookstack:bookstack -R . \
  && echo "Ensure www-data got access to Nginx folders:" \
  && chown www-data:www-data -R /var/lib/nginx /var/log/nginx

USER www-data:www-data

WORKDIR $BOOKSTACK_HOME

EXPOSE 8080/tcp

VOLUME ["$BOOKSTACK_HOME/public/uploads", "$BOOKSTACK_HOME/public/storage"]

ENTRYPOINT ["./entrypoint.sh"]
