FROM amazonlinux:2

LABEL maintainer="armand@f5.com"

# Define NGINX versions for NGINX Plus and NGINX Plus modules
# Uncomment this block and the versioned nginxPackages in the main RUN
# instruction to install a specific release
# ENV NGINX_VERSION 22      
# https://nginx.org/en/docs/njs/changes.html
# ENV NJS_VERSION   0.4.3   
# https://plus-pkgs.nginx.com
# ENV PKG_RELEASE   r1    

# e.g '1234567890'
ARG API_KEY 
ENV ENV_API_KEY=$API_KEY

# e.g https://<fqdn>:8443/1.4
ARG CONTROLLER_URL
ENV ENV_CONTROLLER_URL=$CONTROLLER_URL

# e.g True or False
ARG STORE_UUID=False
ENV ENV_STORE_UUID=$STORE_UUID

# e.g Instance location already defined in Controller
ARG LOCATION
ENV ENV_LOCATION=$LOCATION

# Download certificate (nginx-repo.crt) and key (nginx-repo.key) from the customer portal (https://cs.nginx.com)
# and copy to the build context
COPY nginx-repo.* /etc/ssl/nginx/
COPY nginx-plus-api.conf /etc/nginx/conf.d/
COPY ./entrypoint.sh /

## Install Nginx Plus
# Download certificate and key from the customer portal https://cs.nginx.com
# and copy to the build context and set correct permissions
RUN mkdir -p /etc/ssl/nginx
COPY etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.crt
COPY etc/ssl/nginx/nginx-repo.key /etc/ssl/nginx/nginx-repo.key
RUN chmod 644 /etc/ssl/nginx/* \
    # Install prerequisite packages and vim for editing:
    && yum install -y --setopt=tsflags=nodocs wget ca-certificates bind-utils wget bind-utils vim-minimal \
    # Prepare repo config and install NGINX Plus https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/
    && wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-amazon2.repo \
    #
    ## Install the latest release of NGINX Plus and/or NGINX Plus modules
    ## Optionally use versioned packages over defaults to specify a release
    ## Uncomment one:
    && yum install -y --setopt=tsflags=nodocs nginx-plus \
    #
    # NGINX Javascript module needed for APIM
    nginx-plus-module-njs  \
    #
    #
    # Install Controller Agent
    && curl -k -sS -L ${CONTROLLER_URL}/install/controller/ > install.sh \
    && sed -i 's/^assume_yes=""/assume_yes="-y"/' install.sh \
    && sh ./install.sh -y
    # Set Permissions
    && chown -R nginx:nginx /etc/nginx \
    # Forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx-controller/agent.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    # Raise the limits to successfully run benchmarks
    && ulimit -c -m -s -t unlimited \
    # Cleanup
    && yum clean all \
    && rm -rf /etc/yum.repos.d/* \
    # Remove the cert/keys from the image
    && rm /etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.key

# COPY /etc/nginx (Nginx configuration) directory
COPY etc/nginx /etc/nginx

# EXPOSE common ports, HTTP 80 and HTTPS 443
EXPOSE 80 443
STOPSIGNAL SIGTERM
ENTRYPOINT ["sh", "/entrypoint.sh"]