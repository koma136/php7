FROM koma136/php7:7.1.9

RUN apt-get update \
    && apt-get -y install \
            mysql-client \
    && rm -r /var/lib/apt/lists/*
