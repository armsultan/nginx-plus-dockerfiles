FROM amazonlinux:1

LABEL maintainer="armand@f5.com"

# Define NGINX versions for NGINX Plus and NGINX Plus modules
# Uncomment this block and the versioned nginxPackages in the main RUN
# instruction to install a specific release
ENV NGINX_VERSION 23      
# https://nginx.org/en/docs/njs/changes.html
ENV NJS_VERSION   0.5.2   
# https://plus-pkgs.nginx.com
ENV PKG_RELEASE   1.amzn1.ngx 

## Install Nginx Plus
# Download certificate and key from the customer portal https://account.f5.com/myf5
# and copy to the build context and set correct permissions
RUN mkdir -p /etc/ssl/nginx
COPY etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.crt
COPY etc/ssl/nginx/nginx-repo.key /etc/ssl/nginx/nginx-repo.key
RUN set -x \
    && chmod 644 /etc/ssl/nginx/* \
    # Install prerequisite packages and vim for editing:
    && yum install -y --setopt=tsflags=nodocs wget ca-certificates bind-utils wget bind-utils vim-minimal shadow-utils \
    # Create nginx user/group first, to be consistent throughout Docker variants
    && groupadd --system --gid 101 nginx \
    && adduser -g nginx --system --no-create-home --home /nonexistent --shell /bin/false --uid 101 nginx \
    && usermod -s /sbin/nologin nginx \
    && usermod -L nginx \
    # Prepare repo config and install NGINX Plus https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-amazon.repo \
    #
    ## Install the latest release of NGINX App Protect and/or NGINX Plus modules
    ## Optionally use versioned packages over defaults to specify a release
    # List available versions: 
    && yum --showduplicates list nginx-plus \
    ## Uncomment one:
    # && yum install -y --setopt=tsflags=nodocs nginx-plus \
    && yum install -y --setopt=tsflags=nodocs nginx-plus-${NGINX_VERSION}-${PKG_RELEASE} \
    #
    ## Optional: Install NGINX Plus Dynamic Modules (3rd-party) from repo
    ## See https://www.nginx.com/products/nginx/modules
    ## Some modules include debug binaries, install module ending with "-dbg"
    ## Uncomment one:
    ## njs dynamic modules
    #nginx-plus-module-njs \
    #nginx-plus-module-dbg \
    #nginx-plus-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-njs-dbg=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE} \
    ## NGINX high Availablity keepalived
    #nginx-ha-keepalived \
    ## NGINX agent for New Relic \
    #nginx-nr-agent \
    ## SPNEGO for Kerberos authentication
    #nginx-plus-module-auth-spnego
    #nginx-plus-module-auth-spnego-dbg
    #nginx-plus-module-auth-spnego=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}
    #nginx-plus-module-auth-spnego-dbg=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}
    ## brotli compression dynamic modules
    #nginx-plus-module-brotli \
    #nginx-plus-module-brotli-dbg \
    #nginx-plus-module-brotli=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-brotli-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## cookie flag dynamic module
    #nginx-plus-module-cookie-flag \
    #nginx-plus-module-cookie-flag-dbg
    #nginx-plus-module-cookie-flag=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-cookie-flag-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## Encrypted-Session dynamic module
    #nginx-plus-module-encrypted-session \
    #nginx-plus-module-encrypted-session=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-encrypted-session-dbg \
    #nginx-plus-module-encrypted-session-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## FIPS Check 
    #nginx-plus-module-fips-check \
    #nginx-plus-module-fips-check-dbg \
    #nginx-plus-module-fips-check=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-fips-check-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## GeoIP dynamic modules
    #nginx-plus-module-geoip \
    #nginx-plus-module-geoip-dbg \
    #nginx-plus-module-geoip=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-geoip-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## GeoIP2 dynamic modules
    #nginx-plus-module-geoip2 \
    #nginx-plus-module-geoip2-dbg \
    #nginx-plus-module-geoip2=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-geoip2-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## headers-more dynamic module
    #nginx-plus-module-headers-more \
    #nginx-plus-module-headers-more-dbg \
    #nginx-plus-module-headers-more=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-headers-more-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## image filter dynamic module
    #nginx-plus-module-image-filter \
    #nginx-plus-module-image-filter-dbg \
    #nginx-plus-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-image-filter-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## Lua dynamic module
    #nginx-plus-module-lua \
    #nginx-plus-module-lua-dbg \
    #nginx-plus-module-lua=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-lua-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## ModSecurity dynamic module
    #nginx-plus-module-modsecurity \
    #nginx-plus-module-modsecurity-dbg \
    #nginx-plus-module-modsecurity=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-modsecurity-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## Nginx Development Kit dynamic module
    #nginx-plus-module-ndk \
    #nginx-plus-module-ndk-dbg \
    #nginx-plus-module-ndk=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-ndk-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## OpenTracing dynamic module
    #nginx-plus-module-opentracing \
    #nginx-plus-module-opentracing-dbg \
    #nginx-plus-module-opentracing=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-opentracing-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## Phusion Passenger Open Source dynamic module
    #nginx-plus-module-passenger \
    #nginx-plus-module-passenger-dbg \
    #nginx-plus-module-passenger=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-passenger-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## Perl dynamic module
    #nginx-plus-module-perl \
    #nginx-plus-module-perl-dbg \
    #nginx-plus-module-perl=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-perl-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## Prometheus exporter NJS module
    #nginx-plus-module-prometheus \
    #nginx-plus-module-prometheus=${NGINX_VERSION}-${PKG_RELEASE} \
    ## RTMP dynamic module
    #nginx-plus-module-rtmp \
    #nginx-plus-module-rtmp-dbg \
    #nginx-plus-module-rtmp=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-rtmp-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## set-misc dynamic module
    #nginx-plus-module-set-misc \
    #nginx-plus-module-set-misc-dbg \
    #nginx-plus-module-set-misc=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-set-misc-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## HTTP Substitutions Filter dynamic module
    #nginx-plus-module-subs-filter \
    #nginx-plus-module-subs-filter-dbg \
    #nginx-plus-module-subs-filter=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-subs-filter-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## xslt dynamic module
    #nginx-plus-module-xslt \
    #nginx-plus-module-xslt-dbg \
    #nginx-plus-module-xslt=${NGINX_VERSION}-${PKG_RELEASE} \
    #nginx-plus-module-xslt-dbg=${NGINX_VERSION}-${PKG_RELEASE} \
    ## NGINX Sync Script nginx-sync.sh 
    #nginx-sync \
    # Cleanup
    # Remove default nginx config
    && rm /etc/nginx/conf.d/default.conf \
    # Optional: Create cache folder and set permissions for proxy caching
    && mkdir -p /var/cache/nginx \
    # Optional: Create State file folder and set permissions
    && mkdir -p /var/lib/nginx/state \
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

# Optional: COPY over any of your SSL certs for HTTPS servers
# e.g.
#COPY etc/ssl/www.example.com.crt /etc/ssl/www.example.com.crt
#COPY etc/ssl/www.example.com.key /etc/ssl/www.example.com.key

# COPY /etc/nginx (Nginx configuration) directory
COPY etc/nginx /etc/nginx

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80 443 8080
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]