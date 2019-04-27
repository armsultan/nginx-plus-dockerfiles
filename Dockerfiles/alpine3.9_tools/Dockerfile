FROM alpine:3.9

LABEL maintainer="armand@nginx.com"

ENV VEGETA_VERSION 12.3.0

## Install Nginx Plus
# Download certificate and key from the customer portal https://cs.nginx.com
# and copy to the build context and set correct permissions
COPY etc/ssl/nginx/nginx-repo.crt /etc/apk/cert.pem
COPY etc/ssl/nginx/nginx-repo.key /etc/apk/cert.key
RUN chmod 644 /etc/apk/cert* \
 # Prepare repo config and install NGINX Plus (https://cs.nginx.com/repo_setup)
 && wget -O /etc/apk/keys/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
 && printf "https://plus-pkgs.nginx.com/alpine/v`egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release`/main\n" | tee -a /etc/apk/repositories \
 && apk add nginx-plus \
 ## Optional: Install NGINX Plus Modules from repo
 # See https://www.nginx.com/products/nginx/modules
 #&& apk add nginx-plus-module-modsecurity \
 #&& apk add nginx-plus-module-geoip \
 #&& apk add nginx-plus-module-njs \
 # Remove default nginx config
 && rm /etc/nginx/conf.d/default.conf \
 # Optional: Create cache folder and set permissions for proxy caching
 && mkdir -p /var/cache/nginx \
 && chown -R nginx /var/cache/nginx \
 ## Optional: Install Tools
 # curl
 && apk add curl \
 # jq
 && apk add jq \
 # httpie
 && apk add --no-cache python3 \
 && pip3 install --upgrade pip setuptools httpie \
 && rm -r /root/.cache \
 # Vegeta load generator
 && set -ex \
 && apk add --no-cache ca-certificates \
 && apk add --no-cache --virtual .build-deps openssl \
 && wget -q "https://github.com/tsenart/vegeta/releases/download/cli/v$VEGETA_VERSION/vegeta-$VEGETA_VERSION-linux-amd64.tar.gz" -O /tmp/vegeta.tar.gz \
 && cd bin \
 && tar xzf /tmp/vegeta.tar.gz \
 && rm /tmp/vegeta.tar.gz \
 && apk del .build-deps \
 # wrk
 && apk add wrk \
 # Clear apk cache
 && rm -rf /var/cache/apk/*

# Optional: COPY over any of your SSL certs for HTTPS servers
# e.g.
#COPY etc/ssl/www.example.com.crt /etc/ssl/www.example.com.crt
#COPY etc/ssl/www.example.com.key /etc/ssl/www.example.com.key

# COPY /etc/nginx (Nginx configuration) directory
COPY etc/nginx /etc/nginx
RUN chown -R nginx:nginx /etc/nginx \
 # Forward request logs to docker log collector
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 # **Remove the Nginx Plus cert/keys from the image**
 && rm /etc/apk/cert.pem /etc/apk/cert.key

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80 443 8080
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]