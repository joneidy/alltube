FROM php:7.3-apache
RUN apt-get update && apt-get install -y \
    libicu-dev \
    xz-utils \
    git \
    zlib1g-dev \
    python \
    python-pip \
    nano \
    locales \
    libgmp-dev \
    gettext \
    libzip-dev


#Set locales, replaces _ (underscores) with spaces on output file name
RUN sed --in-place '/en_US.UTF-8/s/^# //' /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#Install/upgrade youtube-dl
RUN pip install --upgrade youtube_dl

RUN docker-php-ext-install mbstring
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install gmp
RUN docker-php-ext-install gettext
RUN a2enmod rewrite
RUN curl -sS https://getcomposer.org/installer | php
COPY resources/php.ini /usr/local/etc/php/
COPY . /var/www/html/
RUN php composer.phar install --prefer-dist --no-progress
ENV CONVERT=1
