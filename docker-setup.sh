#!/bin/sh

apt-get -y update
apt-get -y install memcached zlib1g-dev

groupadd -r memcached && useradd -r -g memcached memcached

mkdir -p /code/pecl-memcache
cd /code

curl -L -o pecl-memcache.tar.gz https://github.com/websupport-sk/pecl-memcache/archive/NON_BLOCKING_IO_php7.tar.gz
tar --strip-components=1 -C /code/pecl-memcache/ -zxf pecl-memcache.tar.gz

cd /code/pecl-memcache
phpize
./configure
make
make install

cd /code
rm -rf /code/pecl-memcache/ pecl-memcache.tar.gz

echo "Install composer"
EXPECTED_SIGNATURE=$(curl https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --install-dir=/usr/bin --filename=composer
RESULT=$?
rm composer-setup.php
exit $RESULT
