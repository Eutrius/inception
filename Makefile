# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jyriarte <jyriarte@student.42roma.it>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/30 21:20:22 by jyriarte          #+#    #+#              #
#    Updated: 2025/07/05 01:37:00 by jyriarte         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

COMPOSE_FILE = srcs/docker-compose.yml

all: build deploy

build:
	@mkdir -p /home/jyriarte/data/{wordpress,redis,mariadb}
	@docker compose -f $(COMPOSE_FILE) build

deploy:
	@docker compose -f $(COMPOSE_FILE) up -d

up:
	@docker compose --force-recreate -f $(COMPOSE_FILE) up -d

down:
	@docker compose -f $(COMPOSE_FILE) down

ps:
	@docker compose -f $(COMPOSE_FILE) ps

logs:
	@docker compose -f $(COMPOSE_FILE) logs

watch:
	@docker compose -f $(COMPOSE_FILE) logs --follow

clean: 
	@sudo rm -rf /home/jyriarte/data
	@docker compose -f $(COMPOSE_FILE) down --volumes

fclean: clean
	@docker compose -f $(COMPOSE_FILE) down --rmi local

re: fclean all

.PHONY: all build deploy up down ps logs watch clean fclean re
