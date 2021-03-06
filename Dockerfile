FROM php:7.1-fpm-alpine3.4

MAINTAINER swz <yan521zheng@163.com>

WORKDIR /tmp

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv

RUN echo 'https://mirrors.aliyun.com/alpine/v3.4/main/' > /etc/apk/repositories \
    && echo 'https://mirrors.aliyun.com/alpine/v3.4/community/' >> /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache --virtual .persistent-deps \
    bash \
    git \
    bzip2-dev \
    build-base\
    gettext-dev \
    imap-dev \
    libaio-dev \
    libedit-dev \
    freetype-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libxml2-dev \
    zlib-dev \
    libxslt-dev \
    icu-dev \
    openssl-dev \
    openldap-dev \
    bison \
    libvpx \
    openssh \
    imagemagick-dev \
    && set -xe \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    linux-headers \
    python pcre-dev libtool\
    # install composer
    && curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && composer clear-cache \
    && composer config -g repo.packagist composer https://packagist.phpcomposer.com \
    && composer global require hirak/prestissimo \
    && composer global dumpautoload --optimize \
    && composer clear-cache \
    && rm -rf /var/www \
    && mkdir -p /var/www \
    && rm -rf /root/.composer/cache


WORKDIR /var/www/html