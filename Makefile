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
VOLUME_DIR = /home/jyriarte/data

all: build deploy

build:
	@mkdir -p $(VOLUME_DIR)/{wordpress,adminer,redis,mariadb,portfolio,portainer}
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
	@sudo rm -rf $(VOLUME_DIR)
	@docker compose -f $(COMPOSE_FILE) down --volumes --rmi local

fclean: clean
	@docker system prune -a

re: fclean all

.PHONY: all build deploy up down ps logs watch clean fclean re
