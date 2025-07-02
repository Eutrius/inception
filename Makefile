# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jyriarte <jyriarte@student.42roma.it>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/30 21:20:22 by jyriarte          #+#    #+#              #
#    Updated: 2025/07/02 10:00:00 by jyriarte         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
COMPOSE_FILE = srcs/docker-compose.yml
STACK_NAME = $(NAME)

all: init-swarm build deploy

init-swarm:
	@docker swarm init 2>/dev/null || echo "swarm already initialized"

build:
	@mkdir -p /home/jyriarte/data/wordpress
	@mkdir -p /home/jyriarte/data/mariadb
	@docker-compose -f $(COMPOSE_FILE) build

deploy:
	@docker stack deploy -c $(COMPOSE_FILE) $(STACK_NAME)

down:
	@docker stack rm $(STACK_NAME)
	@echo "waiting for all containers"
	@while docker stack ps $(STACK_NAME) 2>/dev/null | grep -q .; do \
		echo "still waiting..."; \
		sleep 2; \
	done
	@echo "all containers down"

status:
	@docker stack services $(STACK_NAME)

ps:
	@docker stack ps $(STACK_NAME)

logs-nginx:
	@docker service logs --follow --tail 50 $(STACK_NAME)_nginx 2>/dev/null || echo "no nginx logs available"

logs-wordpress:
	@docker service logs --follow --tail 50 $(STACK_NAME)_wordpress 2>/dev/null || echo "no wordpress logs available"

logs-mariadb:
	@docker service logs --follow --tail 50 $(STACK_NAME)_mariadb 2>/dev/null || echo "no mariadb logs available"

logs:
	@echo "NGINX:"
	@docker service logs --tail 20 $(STACK_NAME)_nginx 2>/dev/null || echo "no nginx logs"
	@echo ""
	@echo "WORDPRESS:"
	@docker service logs --tail 20 $(STACK_NAME)_wordpress 2>/dev/null || echo "no wordpress logs" 
	@echo ""
	@echo "MARIADB:"
	@docker service logs --tail 20 $(STACK_NAME)_mariadb 2>/dev/null || echo "no mariadb logs"

logs-live:
	@docker service logs --follow $(STACK_NAME)_nginx $(STACK_NAME)_wordpress $(STACK_NAME)_mariadb

clean: down
	@docker system prune -af

fclean: clean
	@sudo rm -rf /home/jyriarte/data
	@docker swarm leave --force 2>/dev/null || true

re: fclean all

.PHONY: all init-swarm build deploy down status ps logs logs-nginx logs-wordpress logs-mariadb logs-live clean fclean re
