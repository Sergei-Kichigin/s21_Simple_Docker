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