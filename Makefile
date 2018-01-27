.PHONY: *

all: init 

build-base:
	docker build -t build-env -f Dockerfile.build .

init:
	chown -R www-data:www-data /project/catalog	

reset:
	sed -i 's/db_server = ""/db_server = "mariadb" /' catalog/includes/OSC/Conf/global.php
	sed -i 's/db_server_username = ""/db_server_username = "root" /' catalog/includes/OSC/Conf/global.php
	sed -i 's/db_server_password = ""/db_server_password = "mariaSql" /' catalog/includes/OSC/Conf/global.php
	sed -i 's/db_database = ""/db_database = "oscom" /' catalog/includes/OSC/Conf/global.php
	sed -i 's/db_table_prefix = ""/db_table_prefix = "osc_" /' catalog/includes/OSC/Conf/global.php
	sed -i 's/time_zone = "Europe\/Berlin"/time_zone = "UTC" /' catalog/includes/OSC/Conf/global.php
	sed -i 's/dir_root = ""/dir_root = "\/var\/www\/html\/admin\/" /' catalog/includes/OSC/Sites/Admin/site_conf.php
	sed -i 's/http_path = ""/http_path = "\/admin\/" /' catalog/includes/OSC/Sites/Admin/site_conf.php
	sed -i 's/http_cookie_path = ""/http_cookie_path = "\/admin\/" /' catalog/includes/OSC/Sites/Admin/site_conf.php
	sed -i 's/dir_root = ""/dir_root = "\/var\/www\/html\/" /' catalog/includes/OSC/Sites/Shop/site_conf.php
	sed -i 's/http_path = ""/http_path = "\/" /' catalog/includes/OSC/Sites/Shop/site_conf.php
	sed -i 's/http_cookie_path = ""/http_cookie_path = "\/" /' catalog/includes/OSC/Sites/Shop/site_conf.php
	sed -i 's/http_server = ""/http_server = "http:\/\/'"$$(curl checkip.amazonaws.com)"'\/" /' catalog/includes/OSC/Sites/Admin/site_conf.php
	sed -i 's/http_server = ""/http_server = "http:\/\/'"$$(curl checkip.amazonaws.com)"'\/" /' catalog/includes/OSC/Sites/Shop/site_conf.php
	docker exec mariadb sh -c 'exec mysql -uroot -pmariaSql < /opt/oscom.sql' 

up: 
	docker-compose up -d

down:
	docker-compose down
