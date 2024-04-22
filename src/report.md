# Simple Docker

## Оглавление
[Part 1. Готовый докер](#part-1-готовый-докер) \
[Part 2. Операции с контейнером](#part-2-операции-с-контейнером) \
[Part 3. Мини веб-сервер](#part-3-мини-веб-сервер) \
[Part 4. Свой докер](#part-4-свой-докер) \
[Part 5. Dockle](#part-5-dockle) \
[Part 6. Базовый Docker Compose](#part-6-базовый-docker-compose)

## Part 1. Готовый докер

##### Возьми официальный докер-образ с **nginx** и выкачай его при помощи `docker pull`.

- Скачиваю официальный докер-образ **nginx**: \
![docker pull](img/part1_docker_pull_nginx.png)

##### Проверь наличие докер-образа через `docker images`.

- Проверяю образ: \
![docker images](img/part1_docker_images.png)

##### Запусти докер-образ через `docker run -d [image_id|repository]`.

- Запускаю образ: \
![docker run](img/part1_docker_image_run.png)

##### Проверь, что образ запустился через `docker ps`.

- Проверяю статус образа: \
![docker run](img/part1_docker_image_check_status.png)

##### Посмотри информацию о контейнере через `docker inspect [container_id|container_name]`.
##### По выводу команды определи и помести в отчёт размер контейнера, список замапленных портов и ip контейнера.

- Проверяю информацию о контейнере:
	-	Размер: \
		![container size](img/part1_docker_image_size.png)

	- Порты: \
		![container ports](img/part1_docker_image_ports.png)

	- IP: \
		![container ip address](img/part1_docker_image_ip.png)

##### Останови докер образ через `docker stop [container_id|container_name]`.
##### Проверь, что образ остановился через `docker ps`.

- Останавливаю образ и проверяю статус: \
![docker stop](img/part1_docker_image_after_stop.png)

##### Запусти докер с портами 80 и 443 в контейнере, замапленными на такие же порты на локальной машине, через команду *run*.

- Запускаю образ с портами 80 и 443: \
![docker run](img/part1_docker_image_run_8080_443443.png)

##### Проверь, что в браузере по адресу *localhost:80* доступна стартовая страница **nginx**.

- Проверяю статус **nginx**: \
![nginx status](img/part1_nginx_check.png)

##### Перезапусти докер контейнер через `docker restart [container_id|container_name]`.
##### Проверь любым способом, что контейнер запустился.

- Перезапускаю контейнер: \
![docker restart](img/part1_docker_image_restart.png)

## Part 2. Операции с контейнером

##### Прочитай конфигурационный файл *nginx.conf* внутри докер контейнера через команду *exec*.

- Читаю файл из контейнера: \
![container nginx conf](img/part2_nginx_read.png)

##### Создай на локальной машине файл *nginx.conf*.
##### Настрой в нем по пути */status* отдачу страницы статуса сервера **nginx**.

- Создаю файл *nginx.conf* и настраиваю /status: \
![nginx conf /status](img/part2_nginx_conf.png)

##### Скопируй созданный файл *nginx.conf* внутрь докер-образа через команду `docker cp`.
##### Перезапусти **nginx** внутри докер-образа через команду *exec*.

- Копирую конфиг на контейнер и перезапускаю nginx: \
![copy conf and restart nginx](img/part2_nginx_restart.png)

##### Проверь, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**.

- Проверяю адрес *localhost:80/status*: \
![check nginx status](img/part2_nginx_status_check.png)

##### Экспортируй контейнер в файл *container.tar* через команду *export*.

- Экспортирую контейнер: \
![container export](img/part2_container_export.png)

##### Останови контейнер.

- Останавливаю контейнер: \
![container stop](img/part2_container_stop.png)

##### Удали образ через `docker rmi [image_id|repository]`, не удаляя перед этим контейнеры.

- Удаляю образ: \
![image delete](img/part2_nginx_rmi.png)

##### Удали остановленный контейнер.

- Удаляю контейнер: \
![container delete](img/part2_container_rm.png)

##### Импортируй контейнер обратно через команду *import*.

- Импортирую контейнер: \
![container import](img/part2_container_import.png)

##### Запусти импортированный контейнер.

- Запускаю импортированный контейнер: \
![container start](img/part2_imported_container_start.png)

##### Проверь, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**.

- Проверяю статус сервера nginx: \
![nginx status](img/part2_check_status_after_import.png)


## Part 3. Мини веб-сервер

##### Напиши мини-сервер на **C** и **FastCgi**, который будет возвращать простейшую страничку с надписью `Hello World!`.

- Написал мини-сервер:
	``` c
	#include <fcgi_stdio.h>
	#include <stdio.h>

	int main(void) {
		while(FCGI_Accept() >= 0) {
			printf("Content-type: text/html\r\n\r\nHello World!\r\n\r\n");
		}
		return 0;
	}
	```

- Написал *Makefile* для сборки:
	``` makefile
	CC = gcc
	CFLAGS = -Wall -Werror -Wextra
	LIBS = -lfcgi

	TARGET = miniserver
	SRC_FILES = $(TARGET).c
	OBJ_FILES = $(SRC_FILES:.c=.o)

	all: build

	build: $(OBJ_FILES)
		$(CC) $(CFLAGS) $< -o $(TARGET) $(LIBS)

	$(OBJ_FILES): $(SRC_FILES)
		$(CC) $(CFLAGS) -c $< -o $@ $(LIBS)

	clean:
		rm $(TARGET) *.o

	rebuild: clean build

	.PHONY: all build clean rebuild
	```

- Nginx conf: 
	``` conf
	user nginx;
	worker_processes auto;

	error_log  /var/log/nginx/error.log notice;
	pid        /var/run/nginx.pid;


	events {
			worker_connections 1024;
	}


	http {
			include      /etc/nginx/mime.types;
			default_type application/octet-stream;

			log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
												'$status $body_bytes_sent "$http_referer" '
												'"$http_user_agent" "$http_x_forwarded_for"';

			access_log  /var/log/nginx/access.log  main;
			sendfile on;
			keepalive_timeout 65;

			server {
					listen 81;
					server_name localhost;

					location / {
							fastcgi_pass 127.0.0.1:8080;
					}

			}
	}

	```


##### Запусти написанный мини-сервер через *spawn-fcgi* на порту 8080.
##### Напиши свой *nginx.conf*, который будет проксировать все запросы с 81 порта на *127.0.0.1:8080*.
##### Проверь, что в браузере по *localhost:81* отдается написанная тобой страничка.

- Скачал *nginx* командой: \
`docker pull nginx`

- Запустил контейнер: \
`sudo docker run -d -p 81:81 --name part3 nginx` \
![container start](img/part3_container_start.png)

- Скопировал мини-сервер и конфиг nginx на контейнер: 
	- `sudo docker cp nginx.conf part3:/etc/nginx/`
	- `sudo docker cp miniserver/ part3:/home/` \
![copy to container](img/part3_copy_to_container.png)

- Запускаю интерактивную оболочку внутри контейнера: \
`sudo docker exec -it part3 bash`

- Устанавливаю на контейнер пакеты для сборки сервера:
	- `apt update`
	- `apt install gcc make spawn-fcgi libfcgi-dev`

- Собираю сервер: \
`make` \
![server build](img/part3_build_server.png)

- Запускаю мини сервер через *spawn-fcgi*: \
`spawn-fcgi -p 8080 ./miniserver` \
![server start](img/part3_miniserver_start.png)

- Перезапускаю *nginx* на контейнере: \
`nginx -s reload`

- Проверяю статус сервера, через браузер: \
![server start](img/part3_miniserver_check_status.png)

##### Положи файл *nginx.conf* по пути *./nginx/nginx.conf* (это понадобится позже).

## Part 4. Свой докер

#### Напиши свой докер-образ, который:
##### 1) собирает исходники мини сервера на FastCgi из [Части 3](#part-3-мини-веб-сервер);
##### 2) запускает его на 8080 порту;
##### 3) копирует внутрь образа написанный *./nginx/nginx.conf*;
##### 4) запускает **nginx**.
_**nginx** можно установить внутрь докера самостоятельно, а можно воспользоваться готовым образом с **nginx**'ом, как базовым._

- Пишу докер-образ:
	``` Dockerfile

	FROM nginx:latest

	# Установка необходимых пакетов
	RUN apt-get update && \
			apt-get install -y gcc make spawn-fcgi libfcgi-dev nginx

	# Копирование исходников мини сервера
	COPY ./miniserver /home/miniserver

	# Копирование конфигурационного файла nginx
	COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

	# Сборка мини сервера
	RUN cd /home/miniserver && \
			make all

	# Запуск мини сервера и nginx
	CMD spawn-fcgi -p 8080 /home/miniserver/miniserver && nginx -g "daemon off;"
	```

##### Собери написанный докер-образ через `docker build` при этом указав имя и тег.

- `sudo docker build -t part4:1.0 .`

- Написал скрипт для автоматической сборки образа:
	``` bash
	#!/bin/bash
	sudo docker rmi -f simple_docker/part4:1.0 && sudo docker build . -t simple_docker/part4:1.0
	```

##### Проверь через `docker images`, что все собралось корректно.

- Проверяю сборку: \
![image check](img/part4_image_check.png)

##### Запусти собранный докер-образ с маппингом 81 порта на 80 на локальной машине и маппингом папки *./nginx* внутрь контейнера по адресу, где лежат конфигурационные файлы **nginx**'а (см. [Часть 2](#part-2-операции-с-контейнером)).

- `sudo docker run -d -p 80:81 -v ./nginx/nginx.conf:/etc/nginx/nginx.conf simple_docker/part4:1.0`
- Запускаю контейнер: \
![container run](img/part4_container_run.png)

##### Проверь, что по localhost:80 доступна страничка написанного мини сервера.

- Проверяю доступность сервера: \
![fcgi check](img/part4_fcgi_check.png)

##### Допиши в *./nginx/nginx.conf* проксирование странички */status*, по которой надо отдавать статус сервера **nginx**.

- Дописал конфиг nginx:
	``` conf
	location /status {
			stub_status;
	}
	```

##### Перезапусти докер-образ.
*Если всё сделано верно, то, после сохранения файла и перезапуска контейнера, конфигурационный файл внутри докер-образа должен обновиться самостоятельно без лишних действий*
##### Проверь, что теперь по *localhost:80/status* отдается страничка со статусом **nginx**

- Перезапускаю образ и проверяю, что теперь есть доступ к *localhost:80/status*: \
![container restart](img/part4_container_restart.png)

## Part 5. **Dockle**

##### Просканируй образ из предыдущего задания через `dockle [image_id|repository]`.
##### Исправь образ так, чтобы при проверке через **dockle** не было ошибок и предупреждений.

- Для начала нужно установить dockle.
- Перехожу по адресу:
[Github dockle releases](https://github.com/goodwithtech/dockle/releases)
- Скачиваю последню версию dockle в формате *.deb*
- Устанавливаю командой:
`sudo dpkg -i [version_dockle].deb`

- Проверил образ: \
![dockle errors](img/part5_dockle_errors.png)

- Исправил докер-файл и скрипт, запускающий его: 

	``` dockerfile
	FROM ubuntu:20.04

	# Установка необходимых пакетов и очистка кэша apt
	RUN apt-get update && \
			apt-get install -y gcc make spawn-fcgi libfcgi-dev nginx curl && \
			rm -rf /var/lib/apt/lists/*

	# Копирование исходников мини сервера
	COPY ./miniserver /home/miniserver

	# Копирование конфигурационного файла nginx
	COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

	# Сборка мини сервера
	RUN cd /home/miniserver && \
			make all

	RUN chmod 755 \
			/usr/bin/passwd \
			/usr/bin/mount \
			/usr/bin/umount \
			/usr/sbin/unix_chkpwd \
			/usr/bin/gpasswd \
			/usr/sbin/pam_extrausers_chkpwd \
			/usr/bin/chfn \
			/usr/bin/chsh \
			/usr/bin/newgrp \
			/usr/bin/su \
			/usr/bin/chage \
			usr/bin/expiry

	RUN useradd -ms /bin/bash carlsonh \
			&& chown -R carlsonh:carlsonh /usr/bin \
			&& chown -R carlsonh:carlsonh /usr/sbin \
			&& chown -R carlsonh:carlsonh /var \
			&& chown -R carlsonh:carlsonh /run

	# Смена пользователя на nginx
	USER carlsonh

	# Запуск мини сервера и nginx
	CMD spawn-fcgi -p 8080 /home/miniserver/miniserver && nginx -g "daemon off;"

	HEALTHCHECK --interval=5m --timeout=3s \
		CMD curl -f http://localhost:80 || exit 1
	```

- Скрипт: 
	``` bash
	#!/bin/bash
	export DOCKER_CONTENT_TRUST=1

	echo "Start building containers..."
	sudo docker rmi simple_docker/part5:1.0 -f && sudo docker build . -t simple_docker/part5:1.0
	sleep 1
	echo "Dockle check..."
	dockle simple_docker/part5:1.0
	```

- Написал скрипт для запуска сервера fcgi;

- Проверяю dockle после внесенных изменений: \
![Dockle](img/part5_dockle_without_errors.png)

- Запускаю сервер и проверяю его работу: \
![check server](img/part5_check_server.png)

## Part 6. Базовый **Docker Compose**

##### Напиши файл *docker-compose.yml*, с помощью которого:
##### 1) Подними докер-контейнер из [Части 5](#part-5-инструмент-dockle) _(он должен работать в локальной сети, т.е. не нужно использовать инструкцию **EXPOSE** и мапить порты на локальную машину)_.
##### 2) Подними докер-контейнер с **nginx**, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера.
##### Замапь 8080 порт второго контейнера на 80 порт локальной машины.

- Перенес файлы с сервером в папку part_6 с мелкими изменениями;
- Создал для *miniserver* и *nginx_proxy* индивидуальные *nginx.conf*;
- Расположил в каталогах:
	``` markdown
		.part_6
		├── docker-compose.yml
		└── nginx
				├── miniserver
				│   └── nginx.conf
				└── nginx_proxy
						└── nginx.conf
	```

- Написал *docker-compose.yml*:
	``` yml
	services:
		miniserver:
			build:
				context: .
				dockerfile: Dockerfile
			volumes:
				- ./nginx/miniserver/nginx.conf:/etc/nginx/nginx.conf

		nginx_proxy:
			image: nginx
			ports:
				- 80:8080
			volumes:
				- ./nginx/nginx_proxy/nginx.conf:/etc/nginx/nginx.conf
	```

##### Останови все запущенные контейнеры.
##### Собери и запусти проект с помощью команд `docker-compose build` и `docker-compose up`.
##### Проверь, что в браузере по *localhost:80* отдается написанная тобой страничка, как и ранее.

- Написал скрипт для автоматического перезапуска контейнеров:
	``` bash
	#!/bin/bash
	echo "Start building containers..."
	sudo docker-compose down && sudo docker-compose build && sudo docker-compose up -d
	echo "Check server response..."
	sleep 1 && curl localhost:80 && curl localhost:80/status
	```

- Запуск скрипта: \
![script run](img/part6_script_run.png)