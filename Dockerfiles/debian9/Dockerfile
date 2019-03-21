#For Debian 9
FROM debian:stretch-slim

LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"

# Download optional tools:
#RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends vim-tiny && rm -rf /var/lib/apt/lists/* # vi for config file editing

## Install Nginx Plus
# Download certificate and key from the customer portal https://cs.nginx.com
# and copy to the build context
RUN mkdir -p /etc/ssl/nginx
COPY etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.crt
COPY etc/ssl/nginx/nginx-repo.key /etc/ssl/nginx/nginx-repo.key
RUN chmod 644 /etc/ssl/nginx/*

# Install NGINX Plus
RUN set -x \
  && apt-get update && apt-get upgrade -y \
  && apt-get install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates gnupg1 curl python2.7 procps net-tools vim-tiny joe jq less \
  && \
  NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
  found=''; \
  for server in \
    ha.pool.sks-keyservers.net \
    hkp://keyserver.ubuntu.com:80 \
    hkp://p80.pool.sks-keyservers.net:80 \
    pgp.mit.edu \
  ; do \
    echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
    apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
  done; \
  test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
  echo "Acquire::https::plus-pkgs.nginx.com::Verify-Peer \"true\";" >> /etc/apt/apt.conf.d/90nginx \
  && echo "Acquire::https::plus-pkgs.nginx.com::Verify-Host \"true\";" >> /etc/apt/apt.conf.d/90nginx \
  && echo "Acquire::https::plus-pkgs.nginx.com::SslCert     \"/etc/ssl/nginx/nginx-repo.crt\";" >> /etc/apt/apt.conf.d/90nginx \
  && echo "Acquire::https::plus-pkgs.nginx.com::SslKey      \"/etc/ssl/nginx/nginx-repo.key\";" >> /etc/apt/apt.conf.d/90nginx \
  && printf "deb https://plus-pkgs.nginx.com/debian stretch nginx-plus\n" > /etc/apt/sources.list.d/nginx-plus.list \
  && apt-get update && apt-get install -y nginx-plus \
  && rm -rf /var/lib/apt/lists/*

## Optional: Install NGINX Plus Modules from repo
# See https://www.nginx.com/products/nginx/modules
# RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-plus-module-modsecurity && rm -rf /var/lib/apt/lists/*
# RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-plus-module-geoip && rm -rf /var/lib/apt/lists/*
# RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-plus-module-njs && rm -rf /var/lib/apt/lists/*

# Optional: COPY over any of your SSL certs for HTTPS servers
# e.g.
#COPY etc/ssl/www.example.com.crt /etc/ssl/www.example.com.crt
#COPY etc/ssl/www.example.com.key /etc/ssl/www.example.com.key

# Optional: Create cache folder and set permissions for proxy caching
#CMD mkdir -p /var/cache/nginx \
#&& chown -R nginx /var/cache/nginx

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf
# COPY /etc/nginx (Nginx configuration) directory
COPY etc/nginx /etc/nginx
RUN chown -R nginx:nginx /etc/nginx

# Forward request logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log

# Raise the limits to successfully run benchmarks
RUN ulimit -c -m -s -t unlimited

# Remove the cert/keys from the image
RUN rm /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80 443 8080
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]