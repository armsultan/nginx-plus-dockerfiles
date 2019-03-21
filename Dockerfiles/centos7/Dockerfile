FROM centos:centos7

LABEL maintainer="armand@nginx.com"

# Install prerequisite packages:
RUN yum install -y --setopt=tsflags=nodocs wget ca-certificates bind-utils wget bind-utils && yum clean all
# RUN yum install -y vim && yum clean all # vi for config file editing

## Install Nginx Plus
# Download certificate and key from the customer portal https://cs.nginx.com
# and copy to the build context
RUN mkdir -p /etc/ssl/nginx
COPY etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.crt
COPY etc/ssl/nginx/nginx-repo.key /etc/ssl/nginx/nginx-repo.key
RUN chmod 644 /etc/ssl/nginx/*

# Install NGINX Plus from repo (https://cs.nginx.com/repo_setup)
# Get other files required for installation
RUN wget -q -O /etc/yum.repos.d/nginx-plus-7.repo https://cs.nginx.com/static/files/nginx-plus-7.repo \
&& yum install -y --setopt=tsflags=nodocs nginx-plus && yum clean all

## Optional: Install NGINX Plus Modules from repo
# See https://www.nginx.com/products/nginx/modules
#RUN yum install -y --setopt=tsflags=nodocs nginx-plus-module-modsecurity && yum clean all
#RUN yum install -y --setopt=tsflags=nodocs nginx-plus-module-geoip && yum clean all
#RUN yum install -y --setopt=tsflags=nodocs nginx-plus-module-njs && yum clean all

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