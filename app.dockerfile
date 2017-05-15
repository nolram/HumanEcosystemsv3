FROM php:5.6

RUN apt-get update && apt-get install -y libmcrypt-dev php5-intl \
    mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install mcrypt pdo_mysql
