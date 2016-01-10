# docker-php-ci
Docker for a CI tool written in PHP.

This docker simple make the project [CI](https://github.com/antonioribeiro/ci) project available through a docker.

## Tools available

A lot of QA tools exist in PHP. Here is the list available in this docker :
* [atoum](http://atoum.org/): `atoum`
* [behat](http://docs.behat.org/): `behat`
* [Codeception](http://codeception.com/): `codecept`
* [PDepend](http://pdepend.org/): `pdepend`
* [PHP_CodeSniffer](http://pear.php.net/PHP_CodeSniffer): `phpcs` and `phpcbf`
* [PHP Coding Standards Fixer](http://cs.sensiolabs.org/): `php-cs-fixer`
* [PHP Copy/Paste Detector](http://github.com/sebastianbergmann/phpcpd): `phpcpd`
* [PHP Dead Code Detector](http://github.com/sebastianbergmann/phpdcd): `phpdcd`
* [Phing](https://www.phing.info/): `phing`
* [PHPLoc](http://github.com/sebastianbergmann/phploc): `phploc`
* [PHP Mess Detector](http://phpmd.org/): `phpmd`
* [PhpMetrics](http://www.phpmetrics.org/): `phpmetrics`
* [phpspec](http://www.phpspec.net/): `phpspec`
* [PHPUnit](https://phpunit.de/): `phpunit`

## Use the docker image

```
docker pull grummfy/docker-php-ci
docker run -ti -v /workspace/my-repositories:/var/www/repositories -v ~/workspace/my-config:/var/www/config -p 8000:80 grummfy/docker-php-ci
```

This will make the tools available through http://localhost:8000

## Understand the mounted volumes

You need to have two volumes to mount :
* repositories
 * the volume that will contains the code to load
 * in the command line it's materialized with `/workspace/my-repositories`
* config
 * the volume that will contains the [ci.php](https://github.com/Grummfy/docker-php-ci/blob/master/config/ci.php) file to load for the CI tools
 * in the command line it's materialized with `/workspace/my-config`

So in your `ci.php` file you simply need to let the `path` value point to `/var/www/repositories/name-of-the-project/`.

## Use for the tools only

If you want you can use this image for a specific tools. Here with `phploc`.

```
docker run --rm -ti grummfy/docker-php-ci phploc /workspace/my-repositories/my-super-project
```
