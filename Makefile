NAME=inception
COMPOSE=docker compose
YML=srcs/docker-compose.yml

PC_USER := yulia
MARIADB_VOLUME_PATH := /home/$(PC_USER)/data/mariadb
WORDPRESS_VOLUME_PATH := /home/$(PC_USER)/data/wordpress

makedirs:
	mkdir -p $(MARIADB_VOLUME_PATH)
	mkdir -p $(WORDPRESS_VOLUME_PATH)

all: up

up: makedirs
	$(COMPOSE) -f $(YML) up -d --build

down:
	$(COMPOSE) -f $(YML) down

clean:
	$(COMPOSE) -f $(YML) down --volumes

fclean: clean
	docker rmi -f $$(docker images -q)

fullclean:
	$(COMPOSE) -f $(YML) down --volumes --rmi all
	sudo rm -rf $(MARIADB_VOLUME_PATH) $(WORDPRESS_VOLUME_PATH)
	docker volume prune -f
	docker image prune -a -f

re: fclean all

logs:
	$(COMPOSE) -f $(YML) logs -f

uplogs: up
	$(COMPOSE) -f $(YML) logs -f

.PHONY: up down clean fclean re logs uplogs fullclean makedirs
