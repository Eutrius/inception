# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jyriarte <jyriarte@student.42roma.it>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/30 21:20:22 by jyriarte          #+#    #+#              #
#    Updated: 2025/06/30 21:20:41 by jyriarte         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = Inception
COMPOSE_FILE = srcs/docker-compose.yml

all: build up

build:
	@mkdir -p /home/jyriarte/data/wordpress
	@mkdir -p /home/jyriarte/data/mariadb
	@docker-compose -f $(COMPOSE_FILE) build

up:
	@docker-compose -f $(COMPOSE_FILE) up -d

down:
	@docker-compose -f $(COMPOSE_FILE) down

stop:
	@docker-compose -f $(COMPOSE_FILE) stop

start:
	@docker-compose -f $(COMPOSE_FILE) start

status:
	@docker-compose -f $(COMPOSE_FILE) ps

logs:
	@docker-compose -f $(COMPOSE_FILE) logs

clean: down
	@docker system prune -af

fclean: clean
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf /home/jyriarte/data

re: fclean all

.PHONY: all build up down stop start status logs clean fclean re
