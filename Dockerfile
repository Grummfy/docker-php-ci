FROM php:5.6-apache

MAINTAINER Grummfy me@grummfy.be

RUN mkdir -p /var/www/laravel-ci/bin && cd /var/www/laravel-ci

VOLUME ["/var/www/config", "/var/www/repositories"]

WORKDIR /var/www/laravel-ci

# init extension and requirements
RUN apt-get update && apt-get install -y zlib1g-dev git wget --no-install-recommends

COPY bin/* /var/www/laravel-ci/bin/
RUN bin/docker-php-pecl-install xdebug \
	&& docker-php-ext-install zip mbstring \
	&& echo "xdebug.remote_enable=1"       >> /usr/local/etc/php/conf.d/docker-php-pecl-xdebug.ini \
    && echo "xdebug.remote_port=9000"      >> /usr/local/etc/php/conf.d/docker-php-pecl-xdebug.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-pecl-xdebug.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer
# install tools
RUN cd bin \
	&& wget https://phar.phpunit.de/phploc.phar \
	&& mv phploc.phar phploc \
	&& wget https://phar.phpunit.de/phpcpd.phar \
	&& mv phpcpd.phar phpcpd \
	&& wget http://downloads.atoum.org/nightly/mageekguy.atoum.phar \
	&& mv mageekguy.atoum.phar atoum \
	&& wget http://static.pdepend.org/php/latest/pdepend.phar \
	&& mv pdepend.phar pdepend \
	&& wget http://static.phpmd.org/php/latest/phpmd.phar \
	&& mv phpmd.phar phpmd \
	&& wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
	&& mv phpcs.phar phpcs \
	&& wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
	&& mv phpcbf.phar phpcbf \
	&& wget http://get.sensiolabs.org/php-cs-fixer.phar \
	&& mv php-cs-fixer.phar php-cs-fixer \
	&& wget https://www.phing.info/get/phing-latest.phar \
	&& mv phing-latest.phar phing \
	&& wget https://github.com/Behat/Behat/releases/download/v2.5.5/behat.phar \
	&& mv behat.phar behat \
	&& wget http://codeception.com/codecept.phar \
	&& mv codecept.phar codecept \
	&& wget https://github.com/Halleck45/PhpMetrics/raw/master/build/phpmetrics.phar \
	&& mv phpmetrics.phar phpmetrics \
	&& chmod +x * \
	&& mv * /usr/local/bin/

# install project
RUN composer create-project --no-dev laravel/laravel ci 5.1 \
	&& cd ci \
	&& composer require --update-no-dev -o pragmarx/ci \
	&& awk '/App\\Providers\\RouteServiceProvider::class,/ { print; print "PragmaRX\\Ci\\Vendor\\Laravel\\ServiceProvider::class,"; next }1' config/app.php > tmp \
	&& cat tmp > config/app.php
RUN sed -i '/return view('welcome');/return view('pragmarx\/ci::dashboard');/' ci/app/Http/routes.php

# link apache repository and ci tools
RUN rm -r /var/www/html \
	&& ln -s /var/www/laravel-ci/ci/public /var/www/html

# cleanup
RUN rm -rf /tmp/pear && rm -rf /var/lib/apt/lists/* && rm -rf /usr/src/php

# get back to directory of apache
WORKDIR /var/www/html

CMD ["docker-php-ci-runner"]
