FROM alpine:3.11

LABEL maintainer="JJTC <docker@jjtc.eu>"

ENV PPM_VERSION=2.0.3 \
    PPM_HTTP_VERSION=2.0.2 \
    BOOKSTACK=BookStack \
    BOOKSTACK_VERSION=0.28.2 \
    BOOKSTACK_HOME="/app"

COPY docker-entrypoint.sh /app/docker-entrypoint.sh

RUN set -ex \
  && chmod +x /app/docker-entrypoint.sh \
  # ensure www-data user exists
  # 82 is the standard uid/gid for "www-data" in Alpine
  && addgroup -g 82 -S www-data \
  && adduser -u 82 -D -S -G www-data www-data \
  && apk update \
  && echo "Setting up PHP extensions" \
  && apk add --no-cache \
     curl \
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
  && rm -rf ${BOOKSTACK}-${BOOKSTACK_VERSION}.tar.gz .env.example .gitattributes .github .gitignore .travis.yml tests/ public/index.php \
  && ln -s init.php bootstrap/autoload.php \
  && curl -LJO https://gist.githubusercontent.com/TBK/6abf876e9559cf2477ad0d16bbf648db/raw/c9806280ac859c069d4df640e53b6d3346871637/validator_and_shelf_cover_fix.patch \
  && patch -p1 < validator_and_shelf_cover_fix.patch \
  && rm validator_and_shelf_cover_fix.patch \
  && echo "Get Dependencies:" \
  && composer install \
  && echo "Changing ownership:" \
  && chown www-data:www-data -R . \
  && echo "Ensure www-data got access to Nginx folders:" \
  && chown www-data:www-data -R /var/lib/nginx /var/log/nginx

USER www-data:www-data

WORKDIR $BOOKSTACK_HOME

EXPOSE 8080/tcp

VOLUME ["$BOOKSTACK_HOME/public/uploads", "$BOOKSTACK_HOME/public/storage"]

ENTRYPOINT ["./docker-entrypoint.sh"]
