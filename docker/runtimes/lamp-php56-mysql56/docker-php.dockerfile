FROM php:5.6-apache

RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mysql
RUN a2enmod rewrite
RUN a2enmod headers

