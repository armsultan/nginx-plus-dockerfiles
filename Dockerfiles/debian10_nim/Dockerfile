FROM debian:buster-slim

LABEL maintainer="armand@f5.com"

# Define NGINX versions for NGINX Manager and NGINX Plus
# Uncomment this block and the versioned NGINX Packages in the main RUN
# instruction to install a specific release
# https://docs.nginx.com/nginx/releases/
ENV NGINX_VERSION 23         
# https://plus-pkgs.nginx.com
ENV PKG_RELEASE   1~focal   
# https://docs.nginx.com/nginx-instance-manager/releases/
ENV NIM_VERSION 0.9.1-3047962     

## Install NIM and Nginx Plus
# Download certificate and key from the customer portal https://account.f5.com/myf5
# and copy to the build context and set correct permissions
# NIM:
# * nginx-manager.lic
# * nginx-manager.crt (optional)
# * nginx-manager.key (optional)
# Nginx Plus:
# * nginx-repo.crt
# * nginx-repo.key
RUN mkdir -p /etc/ssl/nginx && \
    mkdir -p /etc/nginx-manager
COPY etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.crt
COPY etc/ssl/nginx/nginx-repo.key /etc/ssl/nginx/nginx-repo.key
COPY etc/nginx-manager/nginx-manager.lic /etc/nginx-manager/nginx-manager.lic
# Add Optional .crt and .key (make sure they exist first) and uncomment below
# COPY etc/nginx-manager/nginx-manager.crt /etc/nginx-manager/nginx-manager.crt
# COPY etc/nginx-manager/nginx-manager.key /etc/nginx-manager/nginx-manager.key

# Copy Entrypoint
COPY entrypoint.sh /

RUN set -x \
    # Set correct permissions on entrypoint and NGINX cert directory
    && chmod +x /entrypoint.sh \
    && chmod 644 /etc/ssl/nginx/* \
    # Create nginx user/group first, to be consistent throughout Docker variants
    && addgroup --system --gid 1001 nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 1001 nginx \
    # Install prerequisite packages, vim for editing, then Install NGINX Plus
    && apt-get update && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends apt-transport-https lsb-release ca-certificates wget dnsutils gnupg vim-tiny apt-utils jq \
    # Signing key for all NGINX things
    && wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key \
    # Install NGINX Plus from repo (https://cs.nginx.com/repo_setup)
    && printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list \
    && wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90nginx \
    && apt-get update \
    ## Install the latest release of NGINX Plus and/or NGINX Plus modules
    ## Optionally use versioned packages over defaults to specify a release
    # List available versions: 
    && apt-cache policy nginx-plus \
    ## Uncomment one:
    # && DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-plus \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-plus=${NGINX_VERSION}-${PKG_RELEASE} \
    # Install NIM
    && printf "deb https://pkgs.nginx.com/instance-manager/debian stable nginx-plus\n" | tee /etc/apt/sources.list.d/instance-manager.list \
    && wget -q -O /etc/apt/apt.conf.d/90pkgs-nginx https://cs.nginx.com/static/files/90pkgs-nginx \
    && apt-get update \
    ## Install the latest release of NGINX Instance Manager
    ## Optionally use versioned packages over defaults to specify a release
    # List available versions: 
    && apt-cache policy nginx-manager \
    ## Uncomment one:
    #&& DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-manager \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends nginx-manager=${NIM_VERSION} \
    #    
    # Remove default nginx config
    && rm /etc/nginx/conf.d/default.conf \
    # Optional: Create cache folder and set permissions for proxy caching
    && mkdir -p /var/cache/nginx \
    && chown -R nginx /var/cache/nginx \
    # Optional: Create State file folder and set permissions
    && mkdir -p /var/lib/nginx/state \
    && chown -R nginx /var/lib/nginx/state \
    # Set permissions
    && chown -R nginx:nginx /etc/nginx \
    # Forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    #DO SOMETHING FOR /var/log/nginx-manager/
    # Raise the limits to successfully run benchmarks
    && ulimit -c -m -s -t unlimited \
    # Cleanup
    && apt-get remove --purge --auto-remove -y gnupg lsb-release apt-utils \  
    && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx-plus.list \
    && rm -rf /etc/apt/apt.conf.d/90nginx \
    && rm -rf nginx_signing.key \
    # Remove the cert/keys from the image
    && rm /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key

## Configs
# Copy NGINX Plus (for reverse proxy)
COPY etc/nginx/conf.d  /etc/nginx/conf.d
# NIM config files
COPY etc/nginx-manager/nginx-manager.conf /etc/nginx-manager/nginx-manager.conf

# EXPOSE NGINX Plus ports, HTTP 80, HTTPS 443, Nginx status page 8080 and GRPC 10002 
# Note: NIM ports GRPC 10000 and UI/API 11000 are proxied via NGINX Plus)
EXPOSE 80 443 8080 10002
STOPSIGNAL SIGQUIT
ENTRYPOINT ["/entrypoint.sh"]