# REQUIREMENTS:
# 1. Existing NGINX Plus image (on Debian)
# 2. Network connectivity to Controller instance (may require VPN)
# 3. Hostname and API key for new agents

FROM nginx-plus

RUN apt-get update && apt install -y curl python gnupg2 procps && rm -rf /var/lib/apt/lists/*

# Obtain these values from your Controller UI, "New Instance" modal
ENV CTRL_HOST=10.149.43.182
ENV API_KEY=971e6c8b9240522ed7de08b3f18c65b0

# Install Controller Agent
WORKDIR /controller
RUN curl -skSL https://$CTRL_HOST:8443/1.4/install/controller/ | bash -s - -y
RUN ln -sf /dev/stdout /var/log/nginx-controller/agent.log
RUN sed -i -e "s/INFO/DEBUG/" /etc/controller-agent/agent.conf

EXPOSE 80 443 8080

STOPSIGNAL SIGTERM

RUN printf "service controller-agent start\nnginx -g 'daemon off;'" > start
CMD ["sh", "/controller/start"]