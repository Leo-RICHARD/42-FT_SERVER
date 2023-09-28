#!/bin/sh

cp /start/default_noi /etc/nginx/sites-available/default

service mysql restart
service nginx restart
service php7.3-fpm stop
service php7.3-fpm start
