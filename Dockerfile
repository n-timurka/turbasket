FROM php:7.4-apache

RUN apt-get update

RUN apt-get install -y \
	git \
	zip \
	curl \
	sudo \
	unzip \
	libzip-dev\
	libicu-dev \
	libbz2-dev \
	libpng-dev \
	libjpeg-dev \
	libmcrypt-dev \
	libreadline-dev \
	libfreetype6-dev \
	g++ \
	libldap2-dev \
	npm

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN a2enmod rewrite headers

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN docker-php-ext-install \
    bz2 \
    intl \
    iconv \
    bcmath \
    opcache \
    calendar \
    pdo_mysql \
    zip \
    sockets \
    ldap

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
