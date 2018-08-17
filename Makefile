haproxy=$(shell docker ps -a | grep haproxy | cut -d' ' -f 1) 
branch_name:=$(shell git branch | grep \* | cut -d' ' -f 2 | sed 's/\//_/g')
image_name:=earthquakesan/rabbitmq:${branch_name}
build:
	docker build -t ${image_name} .

push:
	docker push ${image_name}

start:
	docker stack deploy -c docker-compose.yml rabbit

restart-haproxy:
	docker stop ${haproxy} && docker rm ${haproxy}
	docker-compose up -d

stop:
	docker stack rm rabbit

restart: stop start

update-swarm-label:
	docker node update $(shell docker node ls -q) --label-add org.hobbit.type=worker
