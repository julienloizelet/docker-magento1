FROM php:5.5-fpm

# Install
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
    && apt-get update -qy && apt-get install -qy git-core \
    && cd /tmp/ && git clone https://github.com/derickr/xdebug.git \
    && cd xdebug && git checkout XDEBUG_2_2_2 && phpize && ./configure --enable-xdebug && make \
    && mkdir /usr/lib/php5/ && cp modules/xdebug.so /usr/lib/php5/xdebug.so \
    && touch /usr/local/etc/php/ext-xdebug.ini \
    && rm -r /tmp/xdebug && apt-get purge -y git-core \
    && apt-get purge -y --auto-remove

# Configure
COPY php.ini /usr/local/etc/php/php.ini
COPY php-fpm.conf /usr/local/etc/
COPY ext-xdebug.ini /usr/local/etc/php/conf.d/ext-xdebug.ini

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/*

# Install magerun
RUN curl -o magerun https://files.magerun.net/n98-magerun.phar && \
    chmod +x ./magerun && \
    cp ./magerun /usr/local/bin/ && \
    rm ./magerun && \
    apt-get update && \
    apt-get install -qy mysql-client && \
    apt-get purge -y --auto-remove

# Install Tools
RUN apt-get update && \
    apt-get install -y \
    vim \
    telnet \
    netcat \
    git-core \
    zip && \
    apt-get purge -y --auto-remove

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin

# Installs sendmail
RUN apt-get update && apt-get install -q -y ssmtp mailutils && rm -rf /var/lib/apt/lists/*

# set up sendmail config, see http://linux.die.net/man/5/ssmtp.conf for options
RUN echo "hostname=magento1.ngrok.io" > /etc/ssmtp/ssmtp.conf
RUN echo "root=julienloizelet@okaeli.com" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=maildev" >> /etc/ssmtp/ssmtp.conf
# The above 'maildev' is the name you used for the link command
# in your docker-compose file or docker link command.
# Docker automatically adds that name in the hosts file
# of the container you're linking MailDev to.

# Set up php sendmail config
RUN echo "sendmail_path=sendmail -i -t" >> /usr/local/etc/php/conf.d/php-sendmail.ini

# Fully qualified domain name configuration for sendmail on localhost.
# Without this sendmail will not work.
# This must match the value for 'hostname' field that you set in ssmtp.conf.
RUN echo "localhost magento1.ngrok.io" >> /etc/hosts

# Configure ERROR REPORT
COPY php.ini /usr/local/etc/php/php.ini