FROM centos:centos7

LABEL maintainer="armand@nginx.com"

# Install prerequisite packages:
RUN yum install -y wget ca-certificates bind-utils wget

## Install Nginx Plus

# Download certificate and key from the customer portal https://cs.nginx.com
# and copy to the build context
RUN mkdir -p /etc/ssl/nginx
COPY etc/ssl/nginx/nginx-repo.crt /etc/ssl/nginx/nginx-repo.crt
COPY etc/ssl/nginx/nginx-repo.key /etc/ssl/nginx/nginx-repo.key

# Install method A. Install NGINX Plus from repo
# Get other files required for installation
#RUN wget -q -O /etc/yum.repos.d/nginx-plus-7.repo https://cs.nginx.com/static/files/nginx-plus-7.repo
#RUN yum install -y nginx-plus

## Optional: Install NGINX Plus Modules from repo
#RUN yum install -y nginx-plus-module-modsecurity
#RUN yum install -y nginx-plus-module-geoip
# RUN yum install -y nginx-plus-module-njs

# Install method B. "Offine" Install NGINX Plus from .rpm
COPY install/nginx-plus-15-1.el7_4.ngx.x86_64.rpm /tmp/nginx-plus-15-1.el7_4.ngx.x86_64.rpm
RUN yum localinstall -y /tmp/nginx-plus-15-1.el7_4.ngx.x86_64.rpm

## Optional: Install NGINX Plus Modules from .rpm
# Example:
COPY install/nginx-plus-module-njs-15+0.2.0-1.el7_4.ngx.x86_64.rpm /tmp/nginx-plus-module-njs-15+0.2.0-1.el7_4.ngx.x86_64.rpm
RUN yum localinstall -y /tmp/nginx-plus-module-njs-15+0.2.0-1.el7_4.ngx.x86_64.rpm

# Optional: COPY over any of your SSL certs for HTTPS servers
# Example:
#COPY etc/ssl/nginx/www.example.com.crt /etc/ssl/nginx/www.example.com.crt
#COPY etc/ssl/nginx/www.example.com.key /etc/ssl/nginx/www.example.com.key

# Optional: Create cache folder and set permissions for proxy caching
#CMD mkdir -p /var/cache/nginx
#CMD chown -R nginx /var/cache/nginx

# Forward request logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# COPY /etc/nginx (Nginx configuration) directory and other directories as
# necessary, for example, /usr/share/nginx/html for static files
COPY etc/nginx /etc/nginx
#COPY usr/share/nginx/html /usr/share/nginx/html # Optional

# EXPOSE ports, HTTP 80, HTTPS 443 and, Nginx status page 8080
EXPOSE 80 8080 443
CMD ["nginx", "-g", "daemon off;"]