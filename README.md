docker run -d -e MYSQL_ROOT_PASSWORD=password --name mysql --expose 3306 -v /var/lib/mysql mysql:5.6.20
docker run -d --link mysql:mysql -e MYSQL_USERNAME=root --name phpmyadmin -p 80 corbinu/docker-phpmyadmin 