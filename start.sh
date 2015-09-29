#!/bin/bash
apache2ctl start
node /var/www/grpc/examples/node/greeter_server.js &
tail -f /var/log/apache2/error.log
