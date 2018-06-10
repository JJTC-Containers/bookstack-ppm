FROM alpine:edge

LABEL maintainer JJTC "docker@jjtc.eu"

ENV version=1.0.2 \
    http_version=1.0.2 \
    BOOKSTACK=BookStack \
    BOOKSTACK_VERSION=0.22.0 \
    BOOKSTACK_HOME="/app"

COPY docker-entrypoint.sh /app/docker-entrypoint.sh

#COPY php.ini /usr/local/etc/php/conf.d/php.ini
#COPY default.conf /etc/nginx/sites-enabled/default
#COPY nginx.conf /etc/nginx/nginx.conf

# Below the following PHP extensions are installed PCNTL, PDO_MYSQL, ZIP, GD, Tidy, XML, Redis, Memcached, msgpack, igbinary
# PHP extensions such as DOM, OpenSSL, PDO, MBstring, Tokenizer are provided by the base image.
RUN set -ex \
  && chmod +x /app/docker-entrypoint.sh \
  # ensure www-data user exists
  # 82 is the standard uid/gid for "www-data" in Alpine
  && addgroup -g 82 -S www-data \
  && adduser -u 82 -D -S -G www-data www-data \
  && apk update \
  && echo "Setting up PHP extensions" \
  && apk add --no-cache \
     bash \
     curl \
     su-exec \
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
  && composer require php-pm/php-pm:${version} php-pm/httpkernel-adapter:${http_version} \
  && echo "Get BookStack:" \
  && mkdir -p ${BOOKSTACK_HOME} \
  && cd ${BOOKSTACK_HOME} \
  && curl -LJO https://github.com/BookStackApp/BookStack/archive/v${BOOKSTACK_VERSION}.tar.gz \
  && tar --strip-components=1 -xzf BookStack-${BOOKSTACK_VERSION}.tar.gz \
  && rm -rf ${BOOKSTACK}-${BOOKSTACK_VERSION}.tar.gz .env.example .gitattributes .github .gitignore .travis.yml tests/ public/index.php \
  && curl https://raw.githubusercontent.com/BookStackApp/BookStack/873b1099f81f6a9d2619644aef0587e2b73d918a/bootstrap/autoload.php -o bootstrap/autoload.php \
  && echo "Get Dependencies:" \
  && composer install \
  && echo "Changing ownership:" \
  && chown -R www-data:www-data .

WORKDIR $BOOKSTACK_HOME

EXPOSE 80

VOLUME ["$BOOKSTACK_HOME/public/uploads", "$BOOKSTACK_HOME/public/storage"]

ENTRYPOINT ["./docker-entrypoint.sh"]
