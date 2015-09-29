run: build
	docker run --name grpctest-instance --rm --dns 8.8.8.8 -i -p 8880:80 -t grpctest

build:
	docker build -t=grpctest .

attach:
	docker exec -it grpctest-instance bash
