# runs as non-root, listens on 8080 by default
FROM nginxinc/nginx-unprivileged:alpine

# copy your static files
COPY --chown=101:101 build /usr/share/nginx/html

EXPOSE 8080
# no CMD needed; base image starts nginx
