# Dockerized IMAP/SMTP Test Server

Mail server for testing and debugging.

**IMPORTANT**: This image is **ONLY** for developing/debugging proposes

This docker image is based on https://github.com/tomav/docker-mailserver
If you look for a docker image for production environment, then go here:
https://hub.docker.com/r/tvial/docker-mailserver/

This image is even simpler than `tvial` docker image. It includes only 
Postfix (SMTP) and Dovecot (IMAP) servers with one catchall mailbox 
`catchall@MAIL_DOMAIN` for all emails.

Additional mail users can be created by setting `MAIL_USER_N` and `MAIL_PASSWORD_N`
environment variables, for N between 1 and 9.

Any email received via SMTP for any address other than a configured mail user will
be sent to the catchall address, so it's safe for testing a web application sending
emails with a production list of emails.

Using your favorite email client you can connect via IMAP protocol to see emails
like the original recipient would receive them.

## Run container with docker compose

```sh
cp docker-compose.example.yaml docker-compose.yaml
```

Edit ```docker-compose.yml``` to set these environment variables:

- MAIL_DOMAIN: Mail domain (default `local.test`)
- MAIL_USER_1: First user, creates mailbox $MAIL_USER_1@MAIL_DOMAIN (optional)
- MAIL_PASSWORD_1: Password for first user (optional)
- MAIL_USER_2..9: Additional mail users (optional)
- MAIL_PASSWORD_2..9: Password for additional user (optional)

Start the service:

```sh
docker-compose up
```

Configure your email client with these parameters and test it sending 
an email to any email address.

### Catch-all Debug Mailbox
- **IMAP server:** `localhost`
- **IMAP encryption:** `SSL`
- **IMAP port:** `993`
- **IMAP username:** `catchall@local.test` (change to match `MAIL_DOMAIN`)
- **IMAP password:** `catchall`

- **SMTP server:** `localhost`
- **SMTP encryption:** `No`
- **SMTP port:** `25`
- **SMTP authentication:** `none`

### Additional User Mailboxes (Optional)
- **IMAP server:** `localhost`
- **IMAP encryption:** `SSL`
- **IMAP port:** `993`
- **IMAP username:** `alice@local.test` (change to match `MAIL_USER_N@MAIL_DOMAIN`)
- **IMAP password:** `password123` (change to match `MAIL_PASSWORD_N`)

- **SMTP server:** `localhost`
- **SMTP encryption:** `No`
- **SMTP port:** `25`
- **SMTP authentication:** `none`
