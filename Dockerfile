FROM php:7.3-fpm

COPY ./php.ini /usr/local/etc/php/
COPY ./docker-setup.sh /usr/local/bin/
COPY ./docker-entrypoint /usr/local/bin/

RUN apt-get update \
    && apt-get -y install \
            # imagick
            libmagickwand-dev \
            libmagickwand-6.q16-6 \
            # memcache
            libmemcached-dev \
            libmemcached11 \
            # for mcrypt
            libmcrypt-dev \
            libltdl7 \
            # required by composer
            git \
            zlib1g-dev \
            libzip-dev \
        --no-install-recommends \
    # Intl configure and install
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    # memcached
    && pecl install memcached && docker-php-ext-enable memcached \
    # imagick
    && pecl install imagick-3.4.4 && docker-php-ext-enable imagick \
    # mcrypt
    && pecl install mcrypt-1.0.3 && docker-php-ext-enable mcrypt \
    # pdo opcache bcmath mcrypt bz2 pcntl
    && docker-php-ext-install -j$(nproc) pdo_mysql opcache bcmath bz2 pcntl \
    # zip (required by composer)
    && docker-php-ext-install -j$(nproc) zip \
# Cleanup to keep the images size small
    && apt-get purge -y \
        zlib1g-dev \
    && apt-get autoremove -y \
    && rm -r /var/lib/apt/lists/*

RUN yes | pecl install mongodb

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN ls /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-setup.sh
RUN /usr/local/bin/docker-setup.sh \
    && rm /usr/local/bin/docker-setup.sh
WORKDIR /app