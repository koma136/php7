FROM koma136/php7

RUN apt-get update \
    && apt-get -y install \
            mysql-client \
    && rm -r /var/lib/apt/lists/*
