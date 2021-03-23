FROM centos:centos7.6.1810

LABEL maintainer="armand@f5.com"

# Define NGINX versions for NGINX Plus and NGINX Plus modules
# Uncomment this block and the versioned nginxPackages in the main RUN
# instruction to install a specific release
ENV NGINX_VERSION 23      
# https://plus-pkgs.nginx.com
ENV PKG_RELEASE   1.el7.ngx  
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
    && groupadd --system --gid 101 nginx \
    && adduser -g nginx --system --no-create-home --home /nonexistent --shell /bin/false --uid 101 nginx \
    && usermod -s /sbin/nologin nginx \
    && usermod -L nginx \
    # Install prerequisite packages (ca-certificates epel-release) and tools for editing/troubleshooting:
    && yum install -y --setopt=tsflags=nodocs wget ca-certificates bind-utils wget bind-utils vim-minimal \
    # WORKAROUND START (Public key error 3/23/2021) ############################
    # Signing key for all NGINX things 
    && curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key \
    && rpmkeys --import /tmp/nginx_signing.key \
    # WORKAROUND END ###########################################################
    # Prepare repo config and install NGINX Plus https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/
    && wget -q -O /etc/yum.repos.d/nginx-plus-7.repo https://cs.nginx.com/static/files/nginx-plus-7.4.repo \
    ## Install the latest release of NGINX Plus
    ## Optionally use versioned packages over defaults to specify a release
    # List available versions: 
    && yum --showduplicates list nginx-plus \
    ## Uncomment one:
    # && yum install -y --setopt=tsflags=nodocs nginx-plus \
    && yum install -y --setopt=tsflags=nodocs nginx-plus-${NGINX_VERSION}-${PKG_RELEASE} \
    # Install NIM
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/instance-manager.repo \
    ## Install the latest release of NGINX Instance Manager
    ## Optionally use versioned packages over defaults to specify a release
    # List available versions: 
    && yum --showduplicates list nginx-manager \
    ## Uncomment one:
    # && yum install -y --setopt=tsflags=nodocs nginx-manager \
    && yum install -y --setopt=tsflags=nodocs nginx-manager-${NIM_VERSION} \
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
    # Raise the limits to successfully run benchmarks
    && ulimit -c -m -s -t unlimited \
    # Cleanup
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /etc/yum.repos.d/* \
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