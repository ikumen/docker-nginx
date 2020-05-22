FROM nginx:alpine

# We will replace the default configs, add dir for certs
RUN rm /etc/nginx/nginx.conf && rm /etc/nginx/conf.d/* && mkdir /etc/nginx/certs

COPY config/nginx.conf /etc/nginx/
COPY config/conf.d/* /etc/nginx/conf.d/
COPY config/certs/* /etc/nginx/certs/
