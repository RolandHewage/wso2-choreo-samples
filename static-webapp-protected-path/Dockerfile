# Unprivileged nginx: listens on 8080 and runs as a non-root user by default,
# which matches Choreo's container requirements for web applications.
FROM nginxinc/nginx-unprivileged:1.27-alpine

COPY default.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/

EXPOSE 8080
