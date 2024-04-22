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

