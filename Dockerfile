FROM php:7.0-apache
RUN apt-get update && apt-get install -my gnupg
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

#Install dependencies
RUN apt-get update && apt-get install -y \
	libicu-dev \
	xz-utils \
	git \
	zlib1g-dev \
	python \
	nodejs \
	libgmp-dev \
	gettext \
	yarn \
	nano \
	python-pip \
	locales \
	libxslt-dev

#Set locales, replaces _ (underscores) with spaces on output file name
RUN sed --in-place '/en_US.UTF-8/s/^# //' /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#Install/upgrade youtube-dl
RUN pip install --upgrade youtube_dl

#Install docker-php extensions
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install gmp
RUN docker-php-ext-install gettext
RUN docker-php-ext-install xsl
RUN a2enmod rewrite
RUN curl -sS https://getcomposer.org/installer | php

#Copy files to root (/var/www/html)
COPY resources/php.ini /usr/local/etc/php/
COPY . /var/www/html/

RUN php composer.phar install --prefer-dist
RUN yarn install --prod
RUN yarn grunt
ENV CONVERT=1
