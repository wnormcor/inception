# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: wnormcor <wnormcor@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/01 10:18:16 by wnormcor          #+#    #+#              #
#    Updated: 2022/07/24 14:37:08 by wnormcor         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

help:
	@echo "help: make build / up_fg / up / status / start / stop / down / clean"

mkdir:
	docker-machine ssh default sudo mkdir -p /home/wnormcor
	docker-machine ssh default sudo mkdir -p /home/wnormcor/data
	docker-machine ssh default sudo mkdir -p /home/wnormcor/data/mariadb
	docker-machine ssh default sudo mkdir -p /home/wnormcor/data/wordpress
	docker-machine ssh default sudo mkdir -p /home/wnormcor/data/adminer
	docker-machine ssh default sudo mkdir -p /home/wnormcor/data/postgres
	docker-machine ssh default sudo mkdir -p /home/wnormcor/data/portainer

build: mkdir
	docker-compose -f srcs/docker-compose.yml build

up_fg: mkdir
	docker-compose -f srcs/docker-compose.yml up

up: mkdir
	docker-compose -f srcs/docker-compose.yml up -d

ps:
	docker-compose -f srcs/docker-compose.yml ps

logs:
	docker-compose -f srcs/docker-compose.yml logs -f

start:
	docker-compose -f srcs/docker-compose.yml start

stop:
	docker-compose -f srcs/docker-compose.yml stop

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker-compose -f srcs/docker-compose.yml down
	docker-machine ssh default sudo rm -rf /home/wnormcor/data/*