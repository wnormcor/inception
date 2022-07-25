FROM debian:buster

EXPOSE 3306

RUN		apt update >/dev/null 2>&1 && apt install -y mariadb-server procps vim >/dev/null 2>&1
RUN		mkdir -p /run/mysqld && chown -R mysql /run/mysqld
RUN 	sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

ARG		DB_RPWD
ARG		DB_NAME
ARG		DB_USER
ARG		DB_PASS
RUN		echo "create database if not exists $DB_NAME;\n\
			  grant all privileges on $DB_NAME.* to '$DB_USER'@'%' identified by '$DB_PASS';\n\
			  grant all privileges on *.* to 'root'@'%' identified by '$DB_RPWD';\n\
			  flush privileges;\n" > /sql_init.sql

RUN		echo "#!/bin/bash\n\
			  chown -R mysql:mysql /var/lib/mysql\n\
			  if [ ! -f /var/lib/mysql/init_done ]; then \n\
			  mysql_install_db --user=mysql --datadir=/var/lib/mysql >/dev/null 2>1\n\
			  touch /var/lib/mysql/init_done\n\
			  echo 'Wnormcor [MariaDB] new installation. Init complete in /var/lib/mysql'\n\
			  fi\n\
			  echo 'Wnormcor [MariaDB] container start with PID1 [mysqld]'\n\
			  exec \"\$@\"\n" > /wnc_db_entry.sh && chmod +x /wnc_db_entry.sh

ENTRYPOINT	[ "/wnc_db_entry.sh" ]
CMD			[ "mysqld" , "--init-file=/sql_init.sql" ]

# RUN	echo "while true; do echo 'foreground 30'; sleep 30; done" > /infinity.sh && chmod a+x /infinity.sh
# CMD	[ "/bin/sh", "/infinity.sh" ]