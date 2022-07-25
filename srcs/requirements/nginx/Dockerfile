FROM debian:buster

# поставим nginx openssl и удалим страницу индекса по умолчанию
RUN		apt-get update -y 1>/dev/null 2>&1
RUN		apt-get install -y wget curl python3 vim procps net-tools gosu 1>/dev/null 2>&1
RUN		apt-get -y install nginx openssl && rm /var/www/html/index.nginx-debian.html

# скопируем наш конфиг nginx 
COPY ./nginx.conf /etc/nginx/conf.d

ARG		DOMAIN_NAME

# альтернатива: thisisunsafe
# https://stackoverflow.com/questions/58802767/no-proceed-anyway-option-on-neterr-cert-invalid-in-chrome-on-macos
# создаем сертификат с опцией extendedKeyUsage
RUN		openssl req \
		-newkey rsa:2048 \
		-x509 \
		-new \
		-nodes \
		-keyout /etc/ssl/wnormcor-selfsigned.key \
		-out    /etc/ssl/wnormcor-selfsigned.crt  \
		-subj   /C=RU/ST=Russia/L=Moscow/O=42/OU=21/CN=${DOMAIN_NAME}   \
		-sha256  \
		-days 3650  \
		-addext "subjectAltName = DNS:${DOMAIN_NAME},IP:127.0.0.1,IP:192.168.1.1" \
		-addext "extendedKeyUsage = serverAuth"

EXPOSE 443

# создаем нашу главную старницу
RUN		echo "\
			<!doctype html>\
			<html lang='ru' class='h-100'>\
			<head>\
				<meta charset='utf-8'>\
				<meta name='viewport' content='width=device-width, initial-scale=1'>\
				<title>INCEPTION WNORMCOR</title>\
				<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css' \
				integrity='sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm' crossorigin='anonymous'>\
			</head>\
			<body class='d-flex h-100 text-center text-white bg-dark'>\
			\    
			<div class='cover-container d-flex w-100 h-100 p-3 mx-auto flex-column'>\
			<header class='mb-auto'>\
				<div>\
				<h3 class='float-md-start mb-0'>INCEPTION WNORMCOR</h3>\
				</div>\
			</header>\
			\
			<main class='px-3'>\
				<h1>Services: mariadb + wordpress + nginx + adminer</h1>\
				<p class='lead'>Это главная страница проекта Interception</p>\
				<p class='lead'>\
				<a href='/wordpress' target='_blank' class='btn btn-lg btn-primary fw-bold'>Wordpress</a>\
				<a href='/wordpress/wp-admin' target='_blank' class='btn btn-lg btn-primary fw-bold'>Wordpress Admin</a>\
				<a href='/adminer' target='_blank' class='btn btn-lg btn-primary fw-bold'>Adminer</a>\
				<a href='http://${DOMAIN_NAME}:9000' target='_blank' class='btn btn-lg btn-primary fw-bold'>Portainer</a>\
				</p>\
			</main>\
			<footer class='mt-auto text-white-50'>\
				<p>Описание проекта <a href='https://projects.intra.42.fr/projects/inception' class='text-white'>inception</a></p>\
			</footer>\
			</div>\
			\
			</body>\
			</html>" > /var/www/html/index.html

RUN		echo "#!/bin/bash \n\
			  echo 'Wnormcor [Nginx] container start with PID1 [nginx]'\n\
			  exec \"\$@\"\n" > /wnc_nginx_entry.sh && chmod +x /wnc_nginx_entry.sh

ENTRYPOINT [ "/wnc_nginx_entry.sh" ]
CMD ["nginx", "-g", "daemon off;"]