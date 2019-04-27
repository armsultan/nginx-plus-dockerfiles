FROM ubuntu:16.04

LABEL maintainer="armand@nginx.com"

# Set Nginx Plus version
ENV NGINX_PLUS_VERSION 18

## Install Nginx Plus
# Download certificate and key from the customer portal https://cs.nginx.com
# and copy to the build context and set correct permissions
RUN mkdir -p /etc/ssl/nginx
COPY etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.crt
COPY etc/ssl/nginx/nginx-repo.key /etc/ssl/nginx/nginx-repo.key
RUN  chmod 644 /etc/ssl/nginx/* \
    # Install prerequisite packages and vim for editing:
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends apt-transport-https lsb-release ca-certificates wget dnsutils gnupg vim-tiny \
    # Install NGINX Plus from repo (https://cs.nginx.com/repo_setup)
    && wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key \
    && printf "deb https://plus-pkgs.nginx.com/R${NGINX_PLUS_VERSION}/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90nginx \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-plus \
    ## Optional: Install NGINX Plus Modules from repo
    # See https://www.nginx.com/products/nginx/modules
    # &&  DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-plus-module-modsecurity \
    # &&  DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-plus-module-geoip \
    # && DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-plus-module-njs \
    && rm -rf /var/lib/apt/lists/* \
    # Remove default nginx config
    && rm /etc/nginx/conf.d/default.conf \
    # Optional: Create cache folder and set permissions for proxy caching
    && mkdir -p /var/cache/nginx \
    && chown -R nginx /var/cache/nginx

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
 # Raise the limits to successfully run benchmarks
 && ulimit -c -m -s -t unlimited \
 # Remove the cert/keys from the image
 && rm /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80 443 8080
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]