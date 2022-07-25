# справочник по докер
# https://docs.docker.com/engine/reference/builder/

FROM	debian:buster

RUN		apt-get update -y 1>/dev/null 2>&1 && apt-get install -y wget php7.3 php7.3-mysql php7.3-fpm php-json php-xml mariadb-client curl python3 vim 1>/dev/null 2>&1

# слушаем на 9000 порту по cgi-bin старндарту
RUN		sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/" "/etc/php/7.3/fpm/pool.d/www.conf"
EXPOSE	9000

RUN		mkdir -p /var/www/ && \
		chown -R www-data:www-data /var/www/ && \
		chmod 755 -R /var/www/ && \
		mkdir -p /run/php/

# установка инструмента командной строки для управления WordPress https://www.wpoven.com/tutorial/how-to-install-wp-cli-on-your-linux-server/
RUN		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 1>/dev/null 2>&1 && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp-cli

RUN		mkdir /wp_loaded && cd /wp_loaded && wp-cli core download --allow-root && cd /

# для возможности в будущем поставить "Object Cache Pro!": The PhpRedis extension is not installed.
RUN		apt-get install -y php-redis

ARG		DB_NAME
ARG		DB_USER
ARG		DB_PASS
ARG		WP_URL
ARG		WP_TITLE
ARG		WP_USER
ARG		WP_PASS
ARG		WP_EMAIL

RUN		echo "#!/bin/bash \n\
			  if [ ! -d /var/www/wordpress/wp-content ]; then \n\
				echo 'Wnormcor [WordPress] new installation. Create table in MariaDB' \n\
				cp -r /wp_loaded/* /var/www/wordpress/ \n\
				cd /var/www/wordpress \n\
				echo 'Checking if database Wordpress exists in MariaDB...' \n\
				# написал фукнцию которая перед инициализацией проверяет возможность подключения к базе и смотрит код возврата \
				function check_db_is_exists () { \n\
					mysql -u ${DB_USER} -p${DB_PASS} -h mariadb -e 'show databases' ${DB_NAME} 1>/dev/null 2>&1 \n\
					return_my_exit_code=\$? \n\
				} \n\
				# проверяем код возврата перед циклом \
				check_db_is_exists \n\
				# если код установил глобальную переменную в ошибку - то спим секунду и пробуем снова (в среднем нужно 2-3 секунды на поднятие базы) \
				while ((\$return_my_exit_code)) \n\
				do \n\
					echo 'MariaDB (mysql) not ready/or connection error. Wait for mariadb container for 1 sec' \n\
					sleep 1 \n\
					check_db_is_exists \n\
				done; \n\
				echo 'Now we can connect to MariaDB and create database' \n\
				wp-cli core config   --allow-root --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --dbhost=mariadb \n\
				wp-cli core install  --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_USER} --admin_password=${WP_PASS} --admin_email=${WP_EMAIL} \n\
				wp-cli user create   --allow-root wnormcor wnormcor@student.21-school.ru --user_pass=wnormcor \n\
				\n\
				# бонусы (+нужен интернет - из кэша не получится)
				wp-cli plugin install redis-cache --path=/var/www/wordpress --allow-root \n\
				wp-cli plugin activate redis-cache --path=/var/www/wordpress --allow-root \n\
				wp-cli redis enable --force --path=/var/www/wordpress --allow-root \n\
				# поменять адрес сервера:
				sed -i \"s|'host' => '127.0.0.1',|'host' => 'cnt_redis',|g\" /var/www/wordpress/wp-content/object-cache.php \n\
				# еще один скрипт настройки из: 
				# https://www.digitalocean.com/community/tutorials/how-to-configure-redis-caching-to-speed-up-wordpress-on-ubuntu-14-04
				# wget https://assets.digitalocean.com/articles/wordpress_redis/object-cache.php
				# поменяем права на все скопированные и сконфигурированные файлы
				chown -R www-data:www-data /var/www/ \n\
			  fi \n\
			echo 'Wnormcor [WordPress] container start with PID1 [php-fpm7.3]'\n\
			\"\$@\"\n\n" > /wnc_wp_entry.sh && chmod +x /wnc_wp_entry.sh

ENTRYPOINT [ "/wnc_wp_entry.sh" ]
CMD [ "php-fpm7.3", "-F"]

# RUN	echo "while true; do echo 'foreground 30'; sleep 30; done" > /infinity.sh && chmod a+x /infinity.sh
# CMD	[ "/bin/sh", "/infinity.sh" ]
