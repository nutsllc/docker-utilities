# Docker Utilities

Alpine Linux based Docker image.

## Usage

```bash
docker run -it nutsllc/docker-utilities /bin/bash
```

### Mount your working directory

```
docker run -v /path/to/your/workdir:/workspace -it nutsllc/docker-utilities /bin/bash
```

## Common tools 

* bash
* vim - with lua
* git
* htop
* jpegoptim
* optimpng

## Optional tools

Using optional tools, apply environment variable(s) with a value of ``enable``.

* nmap - ``-e NMAP=enable``
* apache2-utils - ``-e APACHE2_UTILS=enable``
* mysql-client - ``-e MYSQL_CLIENT=enable``
* sqlite3 - ``-e SQLITE=enable``

For example:

```
docker run -e NMAP=enable -e SQLITE=enable -it nutsllc/docker-utilities /bin/bash
```





