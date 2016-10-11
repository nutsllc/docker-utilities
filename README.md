# Docker Utilities

Alpine Linux based Docker image.

## Running container

```bash
docker run -it nutsllc/docker-utilities /bin/bash
```

### Mount your working directory

```
docker run -v /path/to/your/workdir:/workspace -it nutsllc/docker-utilities /bin/bash
```

## List of the included tools in container

### Bash

>**Bash** is a Unix shell and command language written by Brian Fox for the GNU Project as a free software replacement for the Bourne shell.

### Vim

>**Vim** (a contraction of Vi IMproved) is a clone of Bill Joy's vi text editor program for Unix. 

### Git

>**Git** is a version control system that is used for software development[7] and other version control tasks. 

### htop

>**htop** is an interactive system-monitor process-viewer. It is designed as an alternative to the Unix program top.

### jpegoptim

>**jpegoptim** is utility to optimize jpeg files. Provides lossless optimization (based on optimizing the Huffman tables) and "lossy" optimization based on setting maximum quality factor.

### OptiPNG

>**OptiPNG** is a PNG optimizer that recompresses image files to a smaller size, without losing any information. This program also converts external formats (BMP, GIF, PNM and TIFF) to optimized PNG, and performs PNG integrity checks and corrections.

## List of the optional tools(for networking)

In order to use optional tools, apply environment variable(s) with a value of enable to docker run command.

``-e NMAP=enable`` for using NMAP  
``-e APACHE_BENCH=enable`` for using ApacheBench(ab)  
``-e HTPASSWD=enable`` for using htpasswd  

### Nmap

>**Nmap (Network Mapper)** is a security scanner originally written by Gordon Lyon (also known by his pseudonym Fyodor Vaskovich) used to discover hosts and services on a computer network, thus creating a "map" of the network

### ApacheBench(ab)

>**ApacheBench (ab)** is a single-threaded command line computer program for measuring the performance of HTTP web servers.

### htpasswd

>**htpasswd** is to create and update user authentication files for the HTTP basic authentication.

## List of the optional tools(for database)

In order to use optional tools, apply environment variable(s) with a value of enable to docker run command.

``-e MYSQL_CLIENT=enable`` for using MySQL Client  
``-e SQLITE=enable`` for using SQLite3

### MySQL Client

>**MySQL Client** is the MySQL database without MySQL database server. You can use the MySQL Client to send commands to any mysql server on a remote computer or local.

### SQLite3

>**SQLite** is an in-process library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine.

