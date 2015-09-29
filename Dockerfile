FROM debian:jessie

RUN echo version 0.3

RUN apt-get update

RUN apt-get -y install git curl gcc pkg-config vim mlocate

RUN apt-get -y install php5 php5-dev phpunit php-pear unzip
RUN git clone https://github.com/grpc/grpc.git /grpc
RUN cd /grpc && git checkout release-0_11
RUN cd /grpc && git pull --recurse-submodules && git submodule update --init --recursive
RUN cd /grpc/third_party/protobuf && ./autogen.sh
RUN cd /grpc/third_party/protobuf && ./configure
RUN cd /grpc/third_party/protobuf && make -j 8
RUN cd /grpc/third_party/protobuf && make check
RUN cd /grpc/third_party/protobuf && make install

RUN cd /grpc && make  -j 8
RUN cd /grpc && sed -i 's/-e//g' cache.mk
RUN cd /grpc && make install

RUN cd /grpc/src/php/ext/grpc && phpize
RUN cd /grpc/src/php/ext/grpc && ./configure
RUN cd /grpc/src/php/ext/grpc && make -j 8
RUN cd /grpc/src/php/ext/grpc && make install

RUN echo "extension=grpc.so" > /etc/php5/cli/conf.d/30-grpc.ini
RUN echo "extension=grpc.so" > /etc/php5/apache2/conf.d/30-grpc.ini

RUN git clone https://github.com/grpc/grpc.git /var/www/grpc
RUN cd /var/www/grpc && git checkout release-0_11

RUN cd /usr/local/bin && curl -sS https://getcomposer.org/installer | php
RUN cd /var/www/grpc/examples/php && composer.phar install
RUN cd /var/www/grpc/examples/php/vendor/datto/protobuf-php && composer.phar install
RUN pear install Console_CommandLine

RUN echo "8.8.8.8" >  /etc/resolv.conf
RUN echo "8.8.4.4" >>  /etc/resolv.conf

RUN apt-get -y install apache2 nodejs npm net-tools nmap
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN cd /var/www/grpc/examples/node && npm install

ADD helloworld.proto /var/www/helloworld.proto
RUN cd /var/www && protoc --plugin=protoc-gen-php='/var/www/grpc/examples/php/vendor/datto/protobuf-php/protoc-gen-php.php' --php_out=':.' helloworld.proto
ADD greet.php /var/www/html/greet.php

RUN updatedb

#RUN echo "cd /var/www/grpc-common/php && ./run_greeter_client.sh"
RUN php -i | grep -i grpc

ADD start.sh /var/www/html/start.sh
CMD /var/www/html/start.sh
