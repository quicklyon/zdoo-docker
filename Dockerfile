FROM debian:11.6-slim

LABEL maintainer "zhouyueqiu <zhouyueqiu@easycorp.ltd>"

ENV OS_ARCH="amd64" \
    OS_NAME="debian-11" \
    HOME_PAGE="www.zdoo.com"

COPY debian/prebuildfs /

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive

ARG IS_CHINA="true"
ENV MIRROR=${IS_CHINA}

RUN install_packages curl wget zip unzip s6 pwgen cron netcat ca-certificates

# Install internal php
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "php" "7.4.28" -c 934dd0320ee217465f6a8496b0858d120c3fd45b413f1c9ff833731a848cefa7

# Install php-ext-ioncube
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "php-ext-ioncube" "11.0.1" -c 9a6ee08aa864f2b937b9a108d3ec8679ae3a5f08f92a36caf5280520432315ad

# Install apache
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "apache" "2.4.53-fix" -c 46142923f1e74406b6d2a2eb8ed6f61289f30607eaac3c3b9b1cb83c156fdb33

# Install su-exec
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "su-exec" "0.2" --checksum 687d29fd97482f493efec73a9103da232ef093b2936a341d85969bc9b9498910

# Install render-template
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 5e410e55497aa79a6a0c5408b69ad4247d31098bdb0853449f96197180ed65a4

# Install mysql-client
RUN . /opt/easysoft/scripts/libcomponent.sh && component_unpack "mysql-client" "10.5.15-20220817" -c c4f82cb5b66724dd608f0bafaac400fc0d15528599e8b42be5afe8cedfd16488

# Install zdoo
ARG VERSION
ENV ZDOO_VER=${VERSION}
ENV EASYSOFT_APP_NAME="ZDoo $ZDOO_VER"

RUN . /opt/easysoft/scripts/libcomponent.sh && z_download "zdoo" "${ZDOO_VER}"

# Clear apahce vhost config
RUN rm -rf /etc/apache2/sites-available/* /etc/apache2/sites-enabled/*

# Copy apache,php and gogs config files
COPY debian/rootfs /

WORKDIR /apps/zdoo
RUN chown www-data.www-data . -R \
    && a2dismod authz_svn dav_svn

EXPOSE 80

# Persistence directory
VOLUME [ "/data"]

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
