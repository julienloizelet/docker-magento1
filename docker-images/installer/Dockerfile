FROM php:5.6

# Configure PHP
RUN buildDeps=" \
        libpng-dev \
        libjpeg-dev \
        libvpx-dev \
        libxpm-dev \
        libmcrypt-dev \
        libxml2-dev \
        pkg-config \
        libfreetype6-dev \
    "; \
    set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure \
    gd --with-png-dir=/usr --with-jpeg-dir=/usr  --with-freetype-dir=/usr/include/freetype  --with-vpx-dir=/usr --with-xpm-dir=/usr \
    && docker-php-ext-install \
    gd \
    mbstring \
    mysqli \
    mcrypt \
    mysql \
    pdo_mysql \
    soap \
    zip \
    && apt-get purge -y --auto-remove

# Install Tools
RUN apt-get update && \
    apt-get install -y \
    vim \
    telnet \
    netcat \
    git-core \
    zip && \
    apt-get purge -y --auto-remove

# Install magerun
RUN curl -o magerun https://files.magerun.net/n98-magerun.phar && \
    chmod +x ./magerun && \
    cp ./magerun /usr/local/bin/ && \
    rm ./magerun && \
    apt-get update && \
    apt-get install -qy mysql-client && \
    apt-get purge -y --auto-remove

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=bin

# Installs sendmail
RUN apt-get update && apt-get install -q -y ssmtp mailutils && rm -rf /var/lib/apt/lists/*
