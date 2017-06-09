#!/bin/bash

firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=8000/tcp --permanent

docker run --name GB --hostname GB.lilab.com -d -p 80:80 -v /GB/gb/:/gb/ -v /GB/www:/var/www/ -v /GB/mysql/:/var/lib/mysql/ lilab/gb
docker run --name trackhub -d -p 8080:80 -v /home/trackdir/:/var/www/html/ lilab/http
docker run --name seqdb -d -it -p 8000:80 -v /seqdb/www/:/var/www/seqdb/ -v /seqdb/mysql/:/var/lib/mysql/ -v /seqdb/update/:/update/ lilab/seqdb:latest /bin/bash
