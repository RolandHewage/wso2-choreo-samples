# Uses Choreo's registry mirror for the unprivileged nginx image (the build plane
# cannot pull arbitrary Docker Hub images). The image listens on 8080 and, with the
# permission settings below, runs as a non-root user with UID/GID 10015 - inside
# Choreo's required range of [10000, 20000] for Web Application containers.
ARG NGINX_IMAGE=choreoanonymouspullable.azurecr.io/nginxinc/nginx-unprivileged:stable-alpine-slim
FROM $NGINX_IMAGE

ENV ENABLE_PERMISSIONS=TRUE
ENV DEBUG_PERMISSIONS=TRUE
ENV USER_NGINX=10015
ENV GROUP_NGINX=10015

COPY default.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/

USER 10015
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
