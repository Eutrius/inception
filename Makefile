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

STACK_NAME = inception
SERVICES = nginx wordpress mariadb redis ftp
COMPOSE_FILE = srcs/docker-compose.yml

all: init-swarm build deploy

init-swarm:
	@docker swarm init 2>/dev/null || echo "swarm already initialized"

build:
	@mkdir -p /home/jyriarte/data/wordpress
	@mkdir -p /home/jyriarte/data/redis
	@mkdir -p /home/jyriarte/data/mariadb
	@mkdir -p /home/jyriarte/data/ftp
	@docker compose -f $(COMPOSE_FILE) build

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

logs:
	@for service in $(SERVICES); do \
        echo ""; \
		echo "$$service:"; \
		docker service logs --tail 50 $(STACK_NAME)_$$service 2>/dev/null | grep . || echo "no logs available for $$service"; \
    done

logs-live:
	@for service in $(SERVICES); do \
		docker service logs --follow $(STACK_NAME)_$$service & \
	done; \
	wait

clean: down
	@docker system prune -af

fclean: clean
	@sudo rm -rf /home/jyriarte/data
	@docker volume ls -q --filter name=inception_ | xargs -r docker volume rm
	@docker swarm leave --force 2>/dev/null || true

re: fclean all

.PHONY: all init-swarm build deploy down status ps logs logs-live clean fclean re
