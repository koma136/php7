FROM php:7.1.9-fpm

COPY ./php.ini /usr/local/etc/php/
COPY ./docker-setup.sh /usr/local/bin/
COPY ./docker-entrypoint /usr/local/bin/

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        curl \
        apt-utils \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libmemcached-dev \
        libmagickwand-6.q16-dev \
        libxslt-dev \
        libssl-dev \
        libicu-dev \
        g++ \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-openssl \
&& docker-php-ext-install -j$(nproc) \
   gd \
   pdo_mysql \
   iconv \
   mcrypt \
   fileinfo \
   json \
   opcache \
   pdo \
   pdo_mysql \
   mysqli \
   xsl \
   gettext \
   xml \
   gettext \
   soap \
   intl \
&& ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin \
&& pecl install imagick \
&& echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
&& pecl install memcached \
&& docker-php-ext-enable memcached
RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install zip \
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