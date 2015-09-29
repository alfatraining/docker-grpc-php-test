# Demonstrating gRPC PHP extension randomly failing behind Apache

## Prerequisites

You can run `docker ps` in your current terminal window.

## Run

1. run `make`

When it's finished you may go to `http://#{insert-your-docker-host-ip-here}:8880/greet.php` in your browser. It might work for the first time and could also work a second time. After that, it will display a white page. Take a look into your terminal and the log output. To attach to the running container in another terminal, open another one and run `make attach`.
