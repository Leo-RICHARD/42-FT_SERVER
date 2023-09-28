# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lrichard <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/03/17 15:51:13 by lrichard          #+#    #+#              #
#    Updated: 2021/04/09 16:12:04 by lrichard         ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

# have to run apt update so that apt command will actually work

RUN	apt-get update

# installation of nginx and mariadb (+ extra stuff that's needed)

RUN apt-get install -y	systemd \
						wget \								
						unzip \
						nginx \
						mariadb-server

# installing php7.3 and dependencies for phpmyadmin

RUN	apt-get install -y	php7.3 \
						php7.3-fpm \
						php7.3-mysql \
						php-common \
						php7.3-cli \
						php7.3-common \
						php7.3-json \
						php7.3-opcache \
						php7.3-readline \
						php7.3-xml \
						php7.3-mbstring

# installation of phpmyadmin

RUN cd var/www/html && \
	wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz && \
	tar -xf phpMyAdmin*.tar.gz && \
	mv phpMyAdmin-*-all-languages phpmyadmin && \
	rm phpMyAdmin-latest-all-languages.tar.gz

# installation of wordpress

RUN	cd var/www/html && \
	wget https://wordpress.org/latest.zip && \
	unzip latest.zip && \
	rm latest.zip

# copying stuff from sources folder to container (mostly configuration files)

RUN mkdir start

COPY srcs/start.sh start
COPY srcs/start_noi.sh start
COPY srcs/default_i start
COPY srcs/default_noi start
COPY srcs/toggle_index_on.sh start
COPY srcs/toggle_index_off.sh start
COPY srcs/config.inc.php var/www/html/phpmyadmin/
COPY srcs/wp-config.php var/www/html/wordpress/wp-config.php
COPY srcs/initdb.sql etc/init.d/initdb.sql
COPY srcs/server.crt etc/ssl/certs/cert.crt
COPY srcs/server.key etc/ssl/private/key.key

# giving right rights

RUN chmod 660 var/www/html/phpmyadmin/config.inc.php && \
	chown -R www-data:www-data /var/www/html/phpmyadmin && \
	chmod +x start/start_noi.sh

# launching sql script to create db and user

RUN service mysql start && \
	mysql -u root < etc/init.d/initdb.sql

# opening ports 80 and 443 (http and https ports)

EXPOSE 80 443

# starting services at launch

ENTRYPOINT bash start/start.sh
