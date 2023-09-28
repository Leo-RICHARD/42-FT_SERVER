#!/bin/bash

cp start/default_noi /etc/nginx/sites-available/default

service nginx restart
service mysql restart
service php7.3-fpm stop
service php7.3-fpm start

echo "alias autoindex_on='sh /start/toggle_index_on.sh'"  >> ~/.bashrc
echo "alias autoindex_off='sh /start/toggle_index_off.sh'" >> ~/.bashrc
source ~/.bashrc

sleep infinity
