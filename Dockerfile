FROM php:5.6-apache

# Install dependencies
# RUN apt-get update -y
# RUN apt-get install -y git curl apache2 php5 libapache2-mod-php5 php5-mcrypt php5-mysql
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

# Install app
RUN rm -rf /var/www/*
ADD ./HEv3 /var/www
RUN  cd /var/www && /usr/local/bin/composer install

# Configure apache
RUN a2enmod rewrite
ADD apache.conf /etc/apache2/sites-available/default

RUN usermod -u 1000 www-data

EXPOSE 80
CMD ["apache2-foreground"]
