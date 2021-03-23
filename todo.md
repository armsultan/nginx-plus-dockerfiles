# TODO

Build and run NGINX Plus Docker container with NGINX Controller Agent

The Controller Agent can be deployed in a Docker environment to monitor and / or
configure NGINX processes inside Docker containers. The agent can collect most
of the metrics.

The "agent-inside-the-container" is currently the only mode of operation. In
other words, the agent should be running in the same container as the NGINX
process being managed / monitored.

1. Copy and paste your `nginx-repo.crt` and `nginx-repo.key` into `etc/ssl/nginx` directory

 2. Build an image from your Dockerfile:
    ```bash
    # Run command from the folder containing the `Dockerfile`
    $ docker build --build-arg CONTROLLER_URL=https://<fqdn>:8443/1.4 --build-arg API_KEY='abcdefxxxxxx' -t nginx-agent .
    ```
 3. Start the Nginx Plus container, e.g.:
    ```bash
    # Start a new container and publish container ports 80, 443 and 8080 to the host
    $ docker run -d -p 80:80 -p 443:443 -p 8080:8080 nginx-agent
    ```

**For more information, please refer to our [Controller Dockerfile repository](https://github.com/nginxinc/docker-nginx-controller).**


## Gitlab CICD builds

We can use Gitlab CI Pipelines to automate our docker builds and store in the Gitlab
private container registry:

### Requirements

1. A build server ([Gitlab Runner](https://docs.gitlab.com/ee/ci/runners/README.html)) with docker and [Crossplane](https://github.com/nginxinc/crossplane) installed 
2. [Gitlab repository mirroring](https://docs.gitlab.com/ee/user/project/repository/repository_mirroring.html) to [this repo](https://github.com/armsultan/nginx-plus-dockerfiles) with the [Gitlab Container Registry](https://docs.gitlab.com/ee/user/packages/container_registry/) for your project enabled
3. [Gitlab CICD]((https://docs.gitlab.com/ee/ci/quick_start/)) continuous integration service

### Instructions
 1. Place the following files in the directories of your build server
    * Retrieve your NGINX Plus Key and Certificate from the NGINX [customer portal](https://cs.nginx.com/) or from an activated evaluation, and copy the `nginx-repo.crt` and `nginx-repo.crt` files into `etc/ssl/nginx/`
 2. Automate a [CICD pipeline using gitlab](https://docs.gitlab.com/ee/ci/pipelines.html). A example gitlab CI/CD pipeline file (`.gitlab-ci.yml`) is provided.
 3. Modify the `Dockerfile` as necessary, e.g. To install addtional NGINX Plus [Dynamic modules](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/dynamic-modules/). Place your own NGINX Plus configurations into `etc/nginx/`, including files in sub directories: i.e. `etc/nginx/conf.d` and `etc/nginx/stream.conf.d`
