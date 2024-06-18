FROM php:8.2-apache

ARG APACHE_RUN_USER
ARG APACHE_RUN_GROUP

# crea utente con la shell di default
#RUN useradd -rm --home-dir /home/appuser --shell /bin/bash --gid $INTERNAL_USER_GROUP --uid $INTERNAL_USER_ID
RUN useradd --uid $APACHE_RUN_USER --gid $APACHE_RUN_GROUP --shell /bin/bash --create-home appuser

RUN apt-get update && \
    apt-get install -y -qq git \
        libjpeg62-turbo-dev \
        apt-transport-https \
        libfreetype6-dev \
        libmcrypt-dev \
        libpng-dev \
        libssl-dev \
        libzip-dev \
        zip unzip \
        wget \
        libjpeg-dev \
        libfreetype6-dev \
        curl \
        libcurl3-dev \
        libonig-dev \
        git \
        zsh 
        
RUN pecl install redis && docker-php-ext-enable redis

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd iconv mbstring zip pdo pdo_mysql bcmath curl

RUN apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN printf "\n" | pecl install imagick
RUN docker-php-ext-enable imagick

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

RUN a2enmod rewrite
RUN a2enmod headers

RUN usermod -aG root appuser

RUN chown -R "$APACHE_RUN_USER":"$APACHE_RUN_GROUP" ./
RUN chmod -R 755 ./
