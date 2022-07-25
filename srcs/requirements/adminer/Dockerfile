FROM debian:buster

WORKDIR /var/www/adminer

RUN		apt-get -y update && apt-get -y upgrade 
RUN		apt-get -y install php7.3 php7.3-mysql php7.3-fpm php-json php-xml wget vim 1>/dev/null 2>&1

# будем слушать на 80 порту по cgi-bin стандарту
RUN		sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 80/" "/etc/php/7.3/fpm/pool.d/www.conf"
EXPOSE	80

# закачиваем последнюю версию adminerа в директорию загрузки (откуда потом подтянем быстро при запуске контейнера)
RUN		mkdir /ad_loaded && wget http://www.adminer.org/latest.php -O /ad_loaded/index.php 1>/dev/null 2>&1

# для запуска php пропишем папочку и проставим права на директорию adminer в /var/www/
RUN		chown -R www-data:www-data /var/www/ && \
		chmod 755 -R /var/www/ && \
		mkdir -p /run/php/

RUN		echo "#!/bin/bash \n\
			  if [ ! -f /var/www/adminer/index.php ]; then \n\
			  	echo 'Wnormcor [Adminer] new installation. Create index.php in /var/www/adminer/' \n\
				cp /ad_loaded/index.php /var/www/adminer/index.php \n\
				chown -R www-data:www-data /var/www/ \n\
			  fi \n\
			  echo 'Wnormcor [Adminer] container start with PID1 [php-fpm7.3]'\n\
			  exec \"\$@\"\n" > /wnc_ad_entry.sh && chmod +x /wnc_ad_entry.sh

ENTRYPOINT [ "/wnc_ad_entry.sh" ]
CMD [ "php-fpm7.3", "-F", "-R"]