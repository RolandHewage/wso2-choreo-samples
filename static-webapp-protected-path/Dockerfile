FROM nginx:1.27-alpine

# Choreo requires the container to run as a non-root user with a UID in [10000, 20000].
ARG UID=10015
RUN adduser -D -H -u ${UID} choreouser

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY public/ /usr/share/nginx/html/

RUN chown -R ${UID}:${UID} /usr/share/nginx/html /var/cache/nginx

USER ${UID}
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
