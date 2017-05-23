FROM php:5.6-apache
MAINTAINER occitech <contact@occitech.fr>

RUN requirements="libmcrypt-dev g++ libicu-dev libmcrypt4 libicu52" \
    && apt-get update && apt-get install -y $requirements \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install intl \
    && requirementsToRemove="libmcrypt-dev g++ libicu-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && apt-get update \
    && apt-get install -y zlib1g-dev git \
    && docker-php-ext-install zip \
    && apt-get purge -y --auto-remove zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*


# RUN cd /var/www/html && /usr/local/bin/composer install
# RUN cd /var/www/html && /usr/local/bin/composer require jublonet/codebird-php
# RUN cd /var/www/html && /usr/local/bin/composer require raiym/instagram-php-scraper


RUN sed -i "s|Timeout 300|Timeout 1000 |g" /etc/apache2/apache2.conf

RUN a2enmod rewrite

RUN usermod -u 1000 www-data
