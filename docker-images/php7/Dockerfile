FROM php:7.2-fpm

MAINTAINER Julien Loizelet <julienloizelet@okaeli.com>

# Install extra modules here
RUN buildDeps=" \
            libpng-dev \
            libjpeg-dev \
            libmcrypt-dev \
            libxml2-dev \
            libfreetype6-dev \
            librabbitmq-dev \
            libtool \
            git \
            automake \
            freetype* \
            mailutils \
            zsh \
            mariadb-client \
            ftp \
        "; \
        set -x \
        && apt-get update \
        && apt-get install -y $buildDeps --no-install-recommends --no-install-suggests \
        && apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* \
        && docker-php-ext-configure \
        gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir \
        && docker-php-ext-install \
        gd \
        bcmath \
        sockets \
        mbstring \
        mysqli \
        pdo \
        pdo_mysql \
        soap \
        zip \
        && apt-get purge -y --auto-remove

#mcrypt install
RUN pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt

#Imagemagick Install
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*
RUN pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick

#PECL Install AMQP
RUN mkdir -p $HOME/rabbitmq-c \
    && cd $HOME/rabbitmq-c \
    && git clone https://github.com/alanxz/rabbitmq-c.git . && git checkout v0.8.0 \
    && autoreconf -i \
    && ./configure \
    && make \
    && make install \
    && pecl install amqp \
    && docker-php-ext-enable amqp

# Install REDIS
ENV PHPREDIS_VERSION 3.0.0

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

#PECL install lib sodium
#RUN pecl install libsodium-1.0.6 \
#    && echo "extension=libsodium.so" > /usr/local/etc/php/conf.d/sodium.ini

#PECL Install X-debug
RUN pecl install xdebug-2.6.0beta1 \
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.idekey=phpstorm-xdebug" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini


# Install magerun
RUN curl -o magerun https://files.magerun.net/n98-magerun.phar \
    && chmod +x ./magerun \
    && cp ./magerun /usr/local/bin/ \
    && rm ./magerun

# Set environment variables
ENV PATH=$PATH:/app/vendor/bin \
    COMPOSER_ALLOW_SUPERUSER=1

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin
RUN composer config -g repositories.firegento composer https://packages.firegento.com

# Install modman
RUN curl -SL https://raw.githubusercontent.com/colinmollenhour/modman/master/modman -o modman \
    && chmod +x ./modman \
&& mv ./modman /usr/local/bin/

#Install generate-modman
RUN curl -sS https://raw.githubusercontent.com/mhauri/generate-modman/master/generate-modman > generate-modman \
&& chmod +x ./generate-modman \
&& mv ./generate-modman /usr/local/bin/

#Install Oh-my-zsh
RUN git clone git://github.com/bwithem/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

RUN echo 'alias magerun="magerun --skip-root-check"' >> ~/.zshrc
RUN echo 'alias magerun="magerun --skip-root-check"' >> ~/.bashrc

# Installs msmtp and sendmail
RUN apt-get update && apt-get install -q -y msmtp mailutils && rm -rf /var/lib/apt/lists/*


# Fully qualified domain name configuration for sendmail on localhost.
# Without this sendmail will not work.
# This must match the value for 'hostname' field that you set in ssmtp.conf.
RUN echo "localhost magento1.ngrok.io" >> /etc/hosts