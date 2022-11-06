FROM ubuntu:16.04

MAINTAINER me@jbchouinard.net

ENV MAIL_DOMAIN=local.test \
    MAIL_FS_USER=docker \
    MAIL_FS_HOME=/home/docker \
    MAIL_USER_1= \
    MAIL_PASSWORD_1= \
    MAIL_USER_2= \
    MAIL_PASSWORD_2= \
    MAIL_USER_3= \
    MAIL_PASSWORD_3= \
    MAIL_USER_4= \
    MAIL_PASSWORD_4= \
    MAIL_USER_5= \
    MAIL_PASSWORD_5= \
    MAIL_USER_6= \
    MAIL_PASSWORD_6= \
    MAIL_USER_7= \
    MAIL_PASSWORD_7= \
    MAIL_USER_8= \
    MAIL_PASSWORD_8= \
    MAIL_USER_9= \
    MAIL_PASSWORD_9=

RUN set -x; \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
    && echo "postfix postfix/mailname string $MAIL_DOMAIN" | debconf-set-selections \
    && echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        postfix \
        dovecot-core \
        dovecot-imapd \
        dovecot-lmtpd \
        rsyslog \
        iproute2 \
    && apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y \
    && rm -rf /var/cache/apt/archives/* /var/cache/apt/*.bin /var/lib/apt/lists/* \
    && rm -rf /usr/share/man/* && rm -rf /usr/share/doc/* \
    && touch /var/log/auth.log \

    # Create mail user
    && adduser $MAIL_FS_USER --home $MAIL_FS_HOME --shell /bin/false --disabled-password --gecos "" \
    && chown -R ${MAIL_FS_USER}: $MAIL_FS_HOME \
    && usermod -aG $MAIL_FS_USER postfix \
    && usermod -aG $MAIL_FS_USER dovecot \

    && echo "Installed: OK"

ADD postfix /etc/postfix

COPY dovecot/auth-passwdfile.inc /etc/dovecot/conf.d/
COPY dovecot/??-*.conf /etc/dovecot/conf.d/

ADD entrypoint /usr/local/bin/
RUN chmod a+rx /usr/local/bin/entrypoint

VOLUME ["/var/mail"]
EXPOSE 25 143 993

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["tail", "-fn", "0", "/var/log/mail.log"]
