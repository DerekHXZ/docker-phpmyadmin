FROM corbinu/docker-nginx-php
MAINTAINER Corbin Uselton corbin@openswimsoftware.com

ENV PMA_SECRET          blowfish_secret
ENV PMA_USERNAME        pma
ENV PMA_PASSWORD        password
ENV MYSQL_USERNAME      mysql
ENV MYSQL_PASSWORD      password

RUN apt-get update
RUN apt-get install -y mysql-client git

ENV PHPMYADMIN_VERSION 4.5.0.2
ENV MAX_UPLOAD "50M"

RUN git clone git@github.com:phpmyadmin/phpmyadmin.git \
 && rm -r /www \
 && mv phpmyadmin /www

ADD sources/config.inc.php /
ADD sources/create_user.sql /
ADD sources/phpmyadmin-start /usr/local/bin/
ADD sources/phpmyadmin-firstrun /usr/local/bin/

RUN chmod +x /usr/local/bin/phpmyadmin-start
RUN chmod +x /usr/local/bin/phpmyadmin-firstrun

RUN sed -i "s/http {/http {\n        client_max_body_size $MAX_UPLOAD;/" /etc/nginx/nginx.conf
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = $MAX_UPLOAD/" /etc/php5/fpm/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = $MAX_UPLOAD/" /etc/php5/fpm/php.ini

EXPOSE 80

CMD phpmyadmin-start
