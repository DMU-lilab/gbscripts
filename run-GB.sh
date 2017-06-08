#!/bin/bash
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent

docker run --name GB --hostname GB.lilab.com -d -p 80:80 -v /GB/gb/:/gb/ -v /GB/www:/var/www/ -v /GB/mysql/:/var/lib/mysql/ lilab/gb
docker run --name apache -d -p 8080:80 -v /home/trackdir/:/var/www/html/ lilab/http
