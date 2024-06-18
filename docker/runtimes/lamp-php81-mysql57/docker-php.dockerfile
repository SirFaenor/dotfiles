FROM sirfaenor/dev-php:8.1-apache

ARG APACHE_RUN_USER
ARG APACHE_RUN_GROUP

RUN apt-get update && apt-get install -y libxml2-dev 
RUN docker-php-ext-install soap

# crea utente con la shell di default
#RUN useradd -rm --home-dir /home/appuser --shell /bin/bash --gid $INTERNAL_USER_GROUP --uid $INTERNAL_USER_ID
RUN useradd --uid $APACHE_RUN_USER --gid $APACHE_RUN_GROUP --shell /bin/bash --create-home appuser

RUN usermod -aG root appuser

RUN chown -R "$APACHE_RUN_USER":"$APACHE_RUN_GROUP" ./
RUN chmod -R 755 ./
