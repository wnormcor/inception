FROM	debian:buster

RUN		apt-get update -y 1>/dev/null 2>&1
RUN		apt-get install -y wget curl python3 vim procps net-tools gosu 1>/dev/null 2>&1

		# https://phoenixnap.com/kb/how-to-install-postgresql-on-ubuntu
		# https://postgrespro.ru/docs/postgresql/14/runtime
RUN		apt-get install -y postgresql postgresql-contrib postgresql-client 1>/dev/null 2>&1

		# https://stackoverflow.com/questions/27093612/in-a-dockerfile-how-to-update-path-environment-variable
ENV		PATH="${PATH}:/usr/lib/postgresql/11/bin"
ENV		PGDATA="/var/lib/pgsql/data"

EXPOSE 5432

ARG		PSQL_PASS

# COPY	wnc_psql_entry.sh /wnc_psql_entry.sh
# RUN	chmod +x wnc_psql_entry.sh
RUN		echo "#!/bin/bash\n\
			if [ \"\$1\" = 'postgres' ]; then\n\
				chown -R postgres:postgres \"\$PGDATA\"\n\
				if [ -z \"\$(ls -A \"\$PGDATA\")\" ]; then\n\
					gosu postgres initdb >/dev/null 2>&1\n\
					gosu postgres echo 'host all all 0.0.0.0/0 md5' >> \$PGDATA/pg_hba.conf\n\
					gosu postgres echo \"ALTER ROLE postgres WITH PASSWORD '${PSQL_PASS}';\" | gosu postgres postgres --single postgres >/dev/null 2>&1\n\
					echo \"Wnormcor [Postgres] new installation. Init complete in \$PGDATA\"\n\
				fi\n\
				# https://postgrespro.ru/docs/postgresql/14/app-postgres
				# postgres — сервер баз данных PostgreSQL
				echo 'Wnormcor [Postgres] container start with PID1 [postgres] and UserID [postgres] using [gosu]'\n\
				exec gosu postgres \"\$@\"\n\
			fi\n\
			exec \"\$@\"\n" > /wnc_psql_entry.sh && chmod +x /wnc_psql_entry.sh

ENTRYPOINT	[ "/wnc_psql_entry.sh" ]
# https://postgrespro.ru/docs/postgresql/14/app-postgres
CMD	[ "postgres", "--listen_addresses=0.0.0.0"]
# CMD postgres >$PGDATA/log_postgres_server.log 2>&1

# SIGINT  -> Ctrl-C
# SIGQUIT -> Ctrl-\
# SIGTSTP -> Ctrl-Z
# https://younglinux.info/bash/ctrl-c Нажатие Ctrl + D говорит терминалу, что надо зарегистрировать
# так называемый EOF (end of file – конец файла), то есть поток ввода окончен. Bash интерпретирует это как желание выйти из программы.

# RUN	echo "while true; do echo 'foreground 30'; sleep 30; done" > /infinity.sh && chmod a+x /infinity.sh
# CMD	[ "/bin/sh", "/infinity.sh" ]