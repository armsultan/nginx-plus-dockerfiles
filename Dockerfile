FROM ubuntu:16.04

LABEL maintainer="armand@nginx.com"

# Install prerequisite packages:
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends apt-transport-https lsb-release ca-certificates wget dnsutils gnupg && rm -rf /var/lib/apt/lists/*
#RUN DEBIAN_FRONTEND=noninteractive apt-get -qq -y && rm -rf /var/lib/apt/lists/* install vim-tiny # vi for config file editing

## Install Nginx Plus
# Download certificate and key from the customer portal https://cs.nginx.com
# and copy to the build context
RUN mkdir -p /etc/ssl/nginx
COPY etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.crt
COPY etc/ssl/nginx/nginx-repo.key /etc/ssl/nginx/nginx-repo.key
RUN chmod 644 /etc/ssl/nginx/*

# Install NGINX Plus from repo (https://cs.nginx.com/repo_setup)
# Get other files required for installation
RUN wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key \
&& printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list \
&& wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90nginx \
&& apt-get update \
&& apt-get -y install --no-install-recommends nginx-plus \
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

## Install NGINX Controller Agent ##
COPY install/agent/install.sh /tmp
COPY install/agent/agent_install.sh /tmp
RUN add-apt-repository universe \
&& apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y python2.7 && rm -rf /var/lib/apt/lists/* \
&& sh /tmp/agent_install.sh \
&& rm /tmp/install.sh /tmp/agent_install.sh

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80 443 8080
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]