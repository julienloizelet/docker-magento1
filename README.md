# Dockerized - Already Existant Project On Magento 1.✕

A dockerized version for an  "already existant project On Magento 1.✕".
By "already existant project On Magento 1.✕", I mean a project based on Magento 1.✕ version (community or enterprise) for which you have sources and database.

Originally forked from [andreaskoch/dockerized-magento](https://github.com/andreaskoch/dockerized-magento).

## Requirements

If you are on Linux you should install

- [docker](http://docs.docker.com/compose/install/#install-docker) and
- [docker-compose (formerly known as fig)](http://docs.docker.com/compose/install/#install-compose)

If you are running on [Mac OS](https://docs.docker.com/engine/installation/mac/) or [Windows](https://docs.docker.com/engine/installation/windows/) you can install the [Docker Toolbox](https://docs.docker.com/engine/installation/mac/) which contains docker, docker-compose and docker-machine.

## Preparations

The web-server will be bound to your local ports 80 and 443. In order to access the shop you must add a hosts file entry for `yourlocaldomain.local`.

### Add the domain name

For Linux Users, n order to access the shop you must add the domain name "yourlocaldomain.local" to your hosts file (`/etc/hosts`).
If you are using docker **natively** you can use this command:

```bash
sudo su
echo "127.0.0.1    yourlocaldomain.local" >> /etc/hosts
```
 
### Get your sources ready
 We will assume sources are in a directory called `/some/path/for/your-project-sources`.
 For example, my own is `/home/julien/workspace/name-of-a-project`
 
### Get your database ready
    Copy a dump `yourdatabasedump.sql` in the path `data/dump`

## Installation

1. Make sure you have docker and docker-compose on your system
2. Clone the repository `git clone https://github.com/julienloizelet/docker-magento1.git`
3. Create a  `docker-compose.override.yml` from the example `docker-compose.override.yml.dist` and make the necessary changes. (e.g replace `/some/path/for/your-project-sources` depending on your own and remove comments.) 
4. Start the projects using `./magento start` or `docker-compose up`  (maybe you will have to do a `chmod +x magento`).

During the first start of the project **docker-compose** will

1. first **build** all docker-images referenced in the [docker-compose.yml](docker-compose.yml)
2. then **start** the containers
3. and **trigger the installer** 

Once the installation is finished the installer will print the URL and the credentials for the backend to the installer log:

```
...
installer_1      | phpMyAdmin: http://yourlocaldomain.local:8081
installer_1      |  - Username: root
installer_1      |  - Password: pw
installer_1      |
installer_1      |
installer_1      | Frontend: http://yourlocaldomain.local/

```


**Note**: The build process and the installation process will take a while if you start the project for the first time. After that, starting and stoping the project will be a matter of seconds.

## Post Installation

### Import the database
1. Create a `yourdatabase` database (a simple way is to use `phpmyadmin` by going to the url : `http://localhost:8081`)
2. We will the import the database with the following commands (use `pw` as root password when prompted.):
```sudo ./magento enter mysql
cd /etc/dump
mysql -u root -h localhost -p yourdatabase < yourdatabase.sql
```
### Modify the `app/etc/local.xml` file
Go to the `/some/path/for/magento/sources``and edit the `app/etc/local.xml` file with the following content :
```
<?xml version="1.0"?>
<config>
    <global>
        <install>
            <date><![CDATA[Sat, 11 Apr 2015 12:33:05 +0000]]></date>
        </install>
        <crypt>
            <key><![CDATA[731aea833710535779fe8c7c49bc6c4d]]></key>
        </crypt>
        <disable_local_modules>false</disable_local_modules>
        <resources>
            <db>
                <table_prefix><![CDATA[]]></table_prefix>
            </db>
            <default_setup>
                <connection>
                    <host><![CDATA[mysql]]></host>
                    <username><![CDATA[root]]></username>
                    <password><![CDATA[pw]]></password>
                    <dbname><![CDATA[yourdatabase]]></dbname>
                    <initStatements><![CDATA[SET NAMES utf8]]></initStatements>
                    <model><![CDATA[mysql4]]></model>
                    <type><![CDATA[pdo_mysql]]></type>
                    <pdoType><![CDATA[]]></pdoType>
                    <active>1</active>
                </connection>
            </default_setup>
        </resources>
        <session_save>db</session_save>
        <redis_session>
            <host>redissession</host>
            <log_level>7</log_level>
            <port>6379</port>
            <password></password>
            <timeout>2.5</timeout>
            <persistent></persistent>
            <db>0</db>
            <compression_threshold>2048</compression_threshold>
            <compression_lib>gzip</compression_lib>
            <log_level>1</log_level>
            <max_concurrency>6</max_concurrency>
            <break_after_frontend>5</break_after_frontend>
            <break_after_adminhtml>30</break_after_adminhtml>
            <bot_lifetime>7200</bot_lifetime>
            <disable_locking>0</disable_locking>
        </redis_session>
        <cache>
            <backend>Mage_Cache_Backend_Redis</backend>
            <backend_options>
                <server>rediscache</server>
                <port>6379</port>
                <persistent></persistent>
                <db>0</db>
                <password></password>
                <force_standalone>0</force_standalone>
                <connect_retries>1</connect_retries>
                <read_timeout>10</read_timeout>
                <automatic_cleaning_factor>0</automatic_cleaning_factor>
                <compress_data>1</compress_data>
                <compress_tags>1</compress_tags>
                <compress_threshold>20480</compress_threshold>
                <compression_lib>gzip</compression_lib>
                <use_lua>0</use_lua>
            </backend_options>
        </cache>
    </global>
</config>
```

## Usage

You can control the project using the built-in `magento`-script which is basically just a **wrapper for docker and docker-compose** that offers some **convenience features**:

```bash
./magento <action>
```

**Available Actons**

- **start**: Starts the docker containers (and triggers the installation if magento is not yet installed)
- **stop**: Stops all docker containers
- **restart**: Restarts all docker containers and flushes the cache
- **status**: Prints the status of all docker containers
- **stats**: Displays live resource usage statistics of all containers
- **magerun**: Executes magerun in the magento root directory
- **composer**: Executes composer in the magento root directory
- **enter**: Enters the bash of a given container type (e.g. php, mysql, ...)
- **destroy**: Stops all containers and removes all data

**Note**: The `magento`-script is just a small wrapper around `docker-compose`. You can just use [docker-compose](https://docs.docker.com/compose/) directly.

## Components

### Overview

The dockerized Magento project consists of the following components:

- **[docker images](docker-images)**
  1. a [Apache-PHP](docker-images/apache2/Dockerfile) image
  1. a standard [MySQL](https://hub.docker.com/_/mysql/) database server image
  1. multiple instances of the standard [Redis](https://hub.docker.com/_/redis/) docker image
  1. a standard [phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin/) image that allows you to access the database on port 8080
  1. a Maildev image to prevent sending email on test environnment.
  1. and a [Installer](docker-images/installer/Dockerfile) image which contains all tools for installing the project from scratch using an [install script](docker-images/installer/bin/install.sh)
- a **[shell script](magento)** for controlling the project: [`./magento <action>`](magento)
- a [composer-file](composer.json) for managing the **Magento modules**
- and the [docker-compose.yml](docker-compose.yml)-file which connects all components

If you are interested in a **guide on how to dockerize a Magento** shop yourself you can have a look at a blog-post of Andreas Koch: [Dockerizing  Magento](https://andykdocs.de/development/Docker/Dockerize-Magento) on [AndyK Docs](https://andykdocs.de)

## Custom Configuration

All parameters of the Magento installation are defined via environment variables that are set in the [docker-compose.yml](docker-compose.yml) file - if you want to tailor the Magento Shop installation to your needs you can do so **by modifying the environment variables** before you start the project.

If you have started the shop before you must **repeat the installation process** in order to apply changes:

1. Modify the parameters in the `docker-compose.yml`
2. Shutdown the containers and remove all data (`./magento destroy`)
3. Start the containers again (`./magento start`)

### Changing the domain name

I set the default domain name to `yourlocaldomain.local`. To change the domain name replace `yourlocaldomain.local` with `your-domain.tld` in the `docker-compose.yml` file:

```yaml
installer:
  environment:
    DOMAIN: yourlocaldomain.local
```

### Change the MySQL Root User Password

I chose a very weak passwords for the MySQL root-user. You can change it by modifying the respective environment variables for the **mysql-container** ... and **installer** because otherwise the installation will fail:

```yaml
installer:
  environment:
    MYSQL_PASSWORD: <your-mysql-root-user-password>
mysql:
  environment:
    MYSQL_ROOT_PASSWORD: <your-mysql-root-user-password>
```
