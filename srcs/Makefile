NAME=inception
COMPOSE=docker compose
YML=docker-compose.yml

all: up

up:
	$(COMPOSE) -f $(YML) up -d --build

down:
	$(COMPOSE) -f $(YML) down

clean:
	$(COMPOSE) -f $(YML) down --volumes

fclean: clean
	docker rmi -f $$(docker images -q)

re: fclean all
