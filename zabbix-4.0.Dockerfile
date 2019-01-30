FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y wget

RUN \
	wget https://repo.zabbix.com/zabbix/4.0/debian/pool/main/z/zabbix-release/zabbix-release_4.0-2+stretch_all.deb \
	&& dpkg -i zabbix-release_4.0-2+stretch_all.deb \
	&& apt-get update -y \
	&& apt-get install -y \
		zabbix-server-mysql \
		zabbix-frontend-php \
		zabbix-agent \
		zabbix-get \
		zabbix-sender \
	&& rm -rf /var/lib/apt/lists/*

RUN \
	mkdir -p /var/run/zabbix \
	&& chown zabbix.zabbix /var/run/zabbix

# configure php
RUN sed -i \
	-e 's/;date\.timezone.*/date.timezone = UTC/' \
	/etc/php/7.0/apache2/php.ini

# configure zabbix web server
COPY zabbix.conf.php /etc/zabbix/web/zabbix.conf.php

COPY entrypoint.sh /entrypoint.sh

EXPOSE 80 10050

ENTRYPOINT ["/entrypoint.sh"]
