FROM	debian:buster

RUN		apt-get update -y 1>/dev/null 2>&1
RUN		apt-get install -y wget curl python3 vim procps net-tools 1>/dev/null 2>&1
RUN		apt-get install -y vsftpd 1>/dev/null 2>&1

#замечательный диспетчер сигналов работающий как pid1 или как поджнец процесс
#RUN		apt-get install -y tini

# брокерирование сигналов для докера для пид 1
# https://habr.com/ru/company/ruvds/blog/326826/
# https://laurvas.ru/bash-trap/
# https://linuxhint.com/bash_trap_command/
# https://ask-dev.ru/info/7031/best-way-to-kill-all-child-processes

# wait
# https://linuxize.com/post/bash-wait/

# хорошее руководство по башскриптам
# https://habr.com/ru/company/ruvds/blog/326826/

# ================= УБИЙСТВО ВСЕ ПРОЦЕССОВ:
# поиск по чистке процессов:
# Как убить все процессы в Linux
# https://superuser.com/questions/161531/how-to-kill-all-processes-in-linux
# хорошие пракитики с tini:
# https://gist.github.com/StevenACoffman/41fee08e8782b411a4a26b9700ad7af5
# https://stackoverflow.com/questions/52968361/different-process-are-running-as-pid-1-when-running-cmd-entrypoint-in-shell-form
# https://gist.github.com/drmalex07/669d7b15b0df33e249a2
# Точка входа сценария Bash (PID = 1) убивает подпроцесс `tail`
# https://stackoverflow.com/questions/45777761/bash-script-entrypoint-pid-1-kills-tail-sub-process-only-if-a-fake-trap-whi
# https://serverfault.com/questions/869543/bash-script-entrypoint-pid-1-kills-tail-sub-process-only-if-a-fake-trap-whi
# Как убить все процессы с заданным частичным именем? [закрыто]
# https://stackoverflow.com/questions/8987037/how-to-kill-all-processes-with-a-given-partial-name

# Как получить pid только что запущенного процесса
# https://serverfault.com/questions/205498/how-to-get-pid-of-just-started-process/205563#205563
# https://stackoverflow.com/questions/1908610/how-to-get-process-id-of-background-process
# For example, if you define a new function in bash and run the function in the background, the $$ within that function contains the PID
# of the process that started the function in the background. If you need PID of the actual process running any given code, you have to use $BASHPID , instead.

# заверешение запущенных процессов по таймауту
# https://codernet.ru/amp/?page=kak_zavershit_dochernij_proczess_po_istechenii_zadannogo_vremeni_ozhidaniya_v_bash
# 

# how to use ps
# http://heap.altlinux.org/issues/textbooks/linux_intro/Processes.html


# В чем преимущество Тини? #8 долгий и полезный рид
# https://github.com/krallin/tini/issues/8

# референс по докер файлы + что делаем с постгресс
# https://docs.docker.com/engine/reference/builder/

# ================= ОБРАБОТКА СИГНАЛОВ:
# https://ru.wikipedia.org/wiki/%D0%A1%D0%B8%D0%B3%D0%BD%D0%B0%D0%BB_(Unix)
# https://phoenixnap.com/kb/bash-trap-command
# https://www.opennet.ru/man.shtml?topic=trap&category=1&russian=5
# посмотреть все возможноые сигналы		:/# trap -l
# посмотреть переопределенные сигналы	:/# trap -p
# также все возможные сигналы от килл	:/# kill -l

# # https://linuxize.com/post/bash-wait/
# #!/bin/bash
# sleep 30 &
# process_id=$!
# echo "PID: $process_id"
# wait $process_id
# echo "Exit status: $?"

# список сигналов
# exit -> SIGTERM / 15 (по умолчанию для kill)
# https://ru.wikipedia.org/wiki/%D0%A1%D0%B8%D0%B3%D0%BD%D0%B0%D0%BB_(Unix)
# https://www.opennet.ru/man.shtml?topic=kill&category=1&russian=2
# https://studfile.net/preview/5687383/
# https://it.wikireading.ru/3301
# 

# https://laurvas.ru/bash-trap/
# #!/bin/bash
# trap 'echo trap SIGINT' SIGINT
# trap 'echo trap SIGTERM' SIGTERM
# trap 'echo trap SIGHUP' SIGHUP
# trap 'echo trap SIGQUIT' SIGQUIT
# trap 'echo trap EXIT' EXIT
# trap 'echo trap ERR' ERR
# echo 'start'
# sleep 1m
# echo 'end'

# https://unix.stackexchange.com/questions/57940/trap-int-term-exit-really-necessary
# https://gist.github.com/x-yuri/c599da097ae610066ff5e3106150ed37
# trap 'ECHO "somesig"' EXIT INT TERM
# echo ' --- press ENTER to close --- '
# read response

# RUN		apk update && apk upgrade
# RUN		apk add --no-cache vsftpd openssl
# COPY tools/ .
# RUN mv selfsigned.key /etc/ssl/private/selfsigned.key
# RUN mv selfsigned.crt /etc/ssl/certs/selfsigned.crt

# делаем реализацию без tls/ssl внутри (доменное имя не передаем как итог)
# ARG		DOMAIN_NAME=wnormcor.42.fr
# RUN		openssl req \
# 		-newkey rsa:2048 \
# 		-x509 \
# 		-new \
# 		-nodes \
# 		-keyout /etc/ssl/wnormcor-selfsigned.key \
# 		-out    /etc/ssl/wnormcor-selfsigned.crt  \
# 		-subj   /C=RU/ST=Russia/L=Moscow/O=42/OU=21/CN=${DOMAIN_NAME}   \
# 		-sha256  \
# 		-days 3650  \
# 		-addext "subjectAltName = DNS:${DOMAIN_NAME},IP:127.0.0.1,IP:192.168.1.1" \
# 		-addext "extendedKeyUsage = serverAuth"

ARG		FTP_PASS=www-data

RUN		useradd -m -s /bin/bash wnormcor && echo "wnormcor:wnormcor" | chpasswd && echo "wnormcor" >> /etc/vsftpd.user_list
RUN		mkdir -p /var/run/vsftpd/ && mkdir -p /var/run/vsftpd/empty
RUN		sed -i "s/www-data:\/var\/www:\/usr\/sbin\/nologin/www-data:\/var\/www:\/bin\/bash/" /etc/passwd
RUN		echo "www-data:${FTP_PASS}" | chpasswd
RUN		echo "www-data" >> /etc/vsftpd.user_list
RUN		mv /etc/vsftpd.conf /etc/vsftpd.conf.orig

# зашиваем конфиг - если что вот так можно получить текущий айпи и сохранить в окружение:
# IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

# описание коонфига для демона:
# https://wiki.debian.org/ru/vsftpd/vsftpd.conf
# https://security.appspot.com/vsftpd/vsftpd_conf.html
# https://wiki.debian.org/ru/vsftpd

# настройка демона
# https://linuxhint.com/setup-vsftpd-ftp-server-on-debian10/
RUN		echo   "listen=YES\n\
listen_ipv6=NO\n\
connect_from_port_20=YES\n\
anonymous_enable=NO\n\
local_enable=YES\n\
write_enable=YES\n\
chroot_local_user=YES\n\
allow_writeable_chroot=YES\n\
secure_chroot_dir=/var/run/vsftpd/empty\n\
pam_service_name=vsftpd\n\
pasv_enable=YES\n\
pasv_min_port=10100\n\
pasv_max_port=10100\n\
userlist_enable=YES\n\
userlist_file=/etc/vsftpd.user_list\n\
userlist_deny=NO\n" > /etc/vsftpd.conf

# как до этого делал конфиг в отдельном файле:
# IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
# echo "pasv_max_port=$FTPPORT" >> /etc/vsftpd/vsftpd.conf
# echo "pasv_min_port=$FTPPORT" >> /etc/vsftpd/vsftpd.conf
# echo "pasv_address=$IP" >> /etc/vsftpd/vsftpd.conf
# echo "local_root=/home/wnormcor" >> /etc/vsftpd/vsftpd.conf
# sed -i "s/anonymous_enable=YES/anonymous_enable=NO/" /etc/vsftpd/vsftpd.conf
# echo "force_local_data_ssl=NO" >> /etc/vsftpd/vsftpd.conf
# echo "force_local_logins_ssl=NO" >> /etc/vsftpd/vsftpd.conf
# echo "ssl_enable=YES" >> /etc/vsftpd/vsftpd.conf
# echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf
# sed -i "s/#local/local/" /etc/vsftpd/vsftpd.conf
# sed -i "s/#write/write/" /etc/vsftpd/vsftpd.conf
# echo "seccomp_sandbox=NO" >> /etc/vsftpd/vsftpd.conf
# echo 'rsa_cert_file=/etc/ssl/wnormcor-selfsigned.crt' >> /etc/vsftpd/vsftpd.conf
# echo 'rsa_private_key_file=/etc/ssl/wnormcor-selfsigned.key' >> /etc/vsftpd/vsftpd.conf
# "vsftpd" "/etc/vsftpd/vsftpd.conf"

# перехват сигналов в баш:
# https://www.opennet.ru/man.shtml?topic=trap&category=1&russian=5

# Trap — обработка сигналов и ошибок в Bash
# https://laurvas.ru/bash-trap/

# Процесс init
# https://parallel.uran.ru/book/export/html/462

# ловышка на EXIT
# https://gist.github.com/x-yuri/c599da097ae610066ff5e3106150ed37
# https://unix.stackexchange.com/questions/57940/trap-int-term-exit-really-necessary
# https://stackoverflow.com/questions/2175647/is-it-possible-to-detect-which-trap-signal-in-bash (как узнать код сигнала который зашел в функцию)
# https://phoenixnap.com/kb/bash-trap-command
# https://linuxize.com/post/bash-wait/
# https://sites.google.com/site/bashhackers/scripting/posparams
# https://sites.google.com/site/bashhackers/commands/set

# google "signal bash exit quit"
# The exit signal is a bash builtin and can be used to catch any signal. For all intents and purposes, if you trap exit, 
# it will be executed when the shell process terminates. Exit the shell, returning a status of n to the shell's parent. 
# If n is omitted, the exit status is that of the last command executed.10 мар. 2019 г.

RUN		echo "#!/bin/bash \n\
echo \"Start init script on PID \$\$\" \n\
function cleanup() { \n\
	trap '' EXIT SIGINT\n\
    echo \"Receive sigterm and now TERM \$1: kill \$(pgrep '\$1')\" \n\
	#ps auxf\n\
	pkill -f vsftpd \n\
	#ps auxf\n\
    echo 'ftpd terminated' \n\
    exit 0 \n\
} \n\
trap cleanup EXIT\n\
trap cleanup SIGINT\n\
echo \"Wnormcor [Ftp] container start with PID1-bash and \$1 as sub-proccess\"\n\
\$@\n\
" > /wnc_ftp_entry.sh && chmod +x /wnc_ftp_entry.sh

ENTRYPOINT [ "/wnc_ftp_entry.sh" ]
# ENTRYPOINT [ "/init.sh" ]
CMD ["vsftpd"]

# ENTRYPOINT [ "vsftpd" ]

# RUN	echo "while true; do echo 'foreground 30'; sleep 30; done" > /infinity.sh && chmod a+x /infinity.sh
# CMD	[ "/bin/sh", "/infinity.sh" ]

# =========================== ПОСЛЕДНИЙ ТЕСТИРУЕМЫЙ ВАРИАНТ:

# # сигналы:
# # "SIGTERM -> 15" Завершение Сигнал завершения (сигнал по умолчанию для утилиты kill)
# # && kill $(pgrep 'vsftpd')

# RUN		echo "#!/bin/bash \n\
# # завершим баш оболочку при получении сигнала от докера о завершении (по умолчанию не обрабатывается)
# # trap \"echo 'receive sigterm and now we exit'\" EXIT\n\
# # если ловить эти сигналы - то ничего не произойдет
# trap \"echo 'exit code $? and Recieve signal INT...' && echo 'exit_TERM' >> /exit.code && exit 0\" INT\n\
# trap \"echo'exit code $? and Recieve signal QUIT...' && echo 'exit_QUIT' >> /exit.code && exit 0\" QUIT\n\
# # а обработка этого сигнала вешает баш (((
# # trap \"echo 'exit code $? and Recieve signal ...' && echo 'exit_TERM' >> /exit.code && exit 0\" TERM\n\
# trap -p\n\
# # trap \"ps -auxf && echo 'recieve sigterm' && sleep 5\" SIGTERM EXIT\n\
# # trap \"pkill sshd\" SIGTERM\n\
# # trap \"echo 'some info edit code 0' > /exit_code\" SIGHUP SIGINT SIGQUIT SIGTERM\n\
# echo "Start init script on PID \$\$"\n\
# # echo 'Wnormcor [Ftp] container start with PID1 [vsftpd]'\n\
# vsftpd\n\
# # FOO_PID=$!\n\
# # (sleep 55) &\n\
# # FOO_PID=${!}\n\
# echo \"now we start proccess on $FOO_PID / ${!} / $! and ready to exit (but be in infinity loop)\"\n\
# while true; do sleep 1; done\n\
# exit 100\n\
# " > /wnc_ftp_entry.sh && chmod +x /wnc_ftp_entry.sh

# =========================== ВАРИАНТЫ ЭНТРИ ПОИНТОВ КОТОРЫЕ ПИСАЛ (чтобы лучше понять суть PID1)

# #напишем инит файл наш -> init.sh
# COPY	init.sh /init.sh
# RUN		chmod +x init.sh
#
# Содержание инит: ==================
#
# #!/bin/bash
# function cleanup()
# {
# 	echo "try to stop docker (killing...)"
#     local pids=`jobs -p`
# 	echo "kill $pids"
#     if [[ "$pids" != "" ]]; then
#         kill $pids >/dev/null 2>/dev/null
#     fi
# 	echo "try to sleep"
# 	sleep 4
# 	echo "exit..."
# }
# trap cleanup EXIT
# # запустим приложение из CMD или отдельно переданное
# echo 'start vtpd...'
# "$@"