# NGINX Plus Dockerfiles

A Bunch of Dockerfiles for [NGINX Plus](https://www.nginx.com/products/nginx/).
**Just add [licenses](https://www.nginx.com/free-trial-request/)**

## Build and run NGINX Plus Docker containers (Using Script)

Run `./build-nginx-plus.sh [build_name]`, where `[build_name]` one of:

| `[build_name]`            | Description           |
| ------------------------- |--------------------------------------------------| 
|`alpine3.9`                | Alpine Linux 3.9 with NGINX Plus                   |
|`alpine3.9_tools`          | Alpine Linux 3.9 with NGINX Plus and HTTP tools    |
|`alpine3.10`               | Alpine Linux 3.10 with NGINX Plus                  |
|`alpine3.11`               | Alpine Linux 3.11 with NGINX Plus                  |
|`amazonlinux`              | Amazon Linux with NGINX Plus                       |
|`amazonlinux2`             | Amazon Linux 2 with NGINX Plus                     |
|~~`amazonlinux2_controller`~~  | ~~Amazon Linux 2 with NGINX Plus and Controller agent~~ |
|`centos7`                  | Centos 7 with NGINX Plus                           |
|`centos7.6`                | Centos 7.6 with NGINX Plus                         |
|`centos7.6_nap`            | Centos 7.6 with NGINX App Protect                  |
|~~`centos7.6_controller`~~     | ~~Centos 7.6 with NGINX Plus and Controller agent~~    |
|`centos8`                  | Centos 8 with NGINX Plus                           |
|`debian9`                  | Debian 9 with NGINX Plus                           |
|~~`debian9_controller`~~       | ~~Debian 9 with NGINX Plus and Controller agent~~      |
|`debian10`                 | Debian 10 with NGINX Plus                          |
|`ubuntu18.04`              | Ubuntu 18.04 with NGINX Plus                       |
|~~`ubuntu18.04_controller`~~   | ~~Ubuntu 18.04 with NGINX Plus and Controller agent~~  |
|`ubuntu18.04_crosplane`    | Ubuntu 18.04 with NGINX Plus and Crossplane        |
|`ubuntu18.04_nap`          | Ubuntu 18.04 with NGINX App Protect                |
|`ubuntu20.04`              | Ubuntu 20.04 with NGINX Plus                       |

## Build NGINX Plus Docker container using script

 1. Copy and paste your `nginx-repo.crt` and `nginx-repo.key` into `etc/ssl/nginx` 
    directory, inside the `NAP` folder for [NGINX App Protect](https://www.nginx.com/products/nginx-app-protect/) or
    in the `NGINX-Plus` folder for [NGINX Plus](https://www.nginx.com/products/nginx/)

 2. Build an image from your Dockerfile:
    ```bash
    # ./build-nginx-plus.sh [Build-name]
    $ ./build-nginx-plus.sh ubuntu18.04_nap
    ```

 3. See the Docker images available
    ```bash
    # NGINX PLUS images are named nginx-plus-[build]
    $ docker images | grep nginx-plus
    # App Protect images are named nginx-app-protect-[build]
    $ docker images | grep nginx-app-protect
    # NGINX PLUS with Controller Agent images are named nginx-app-protect-[build]
    $ docker images | grep nginx-agent
    ```

 4. Start the container, e.g.:
    ```bash
    # Start a new container and publish container ports 80, 443 and 8080 to the host
    # Where [docker_image_name] is found on the last step
    $ docker run -d -p 80:80 -p 443:443 -p 8080:8080 [docker_image_name]
    ```

    **To mount local volume:**

    ```bash
    docker run -d \
      -p 80:80 -p 443:443 \
      -p 8080:8080 \
      -v $PWD/etc/nginx:/etc/nginx [docker_image_name]
    ```

## Build NGINX Plus Docker container Manually

 1. Copy and paste your `nginx-repo.crt` and `nginx-repo.key` into `etc/ssl/nginx` 
    directory, inside the `NAP` folder for [NGINX App Protect](https://www.nginx.com/products/nginx-app-protect/) or
    in the `NGINX-Plus` folder for [NGINX Plus](https://www.nginx.com/products/nginx/)

 2. Build an image from your Dockerfile:
    ```bash
    # Run command from the folder containing the `Dockerfile`
    $ docker build -t nginx-plus .
    ```

 3. Start the Nginx Plus container, e.g.:
    ```bash
    # Start a new container and publish container ports 80, 443 and 8080 to the host
    $ docker run -d -p 80:80 -p 443:443 -p 8080:8080 nginx-plus
    ```

    **To mount local volume:**

    ```bash
   docker run -d \
      -p 80:80 -p 443:443 \
      -p 8080:8080 \
      -v $PWD/etc/nginx:/etc/nginx nginx-plus
    ```

## Useful Docker commands


 1. To run commands in the docker container you first need to start a bash session inside the nginx container
    ```bash
    # get Docker IDs of running containers
    docker ps
    # Enter a Alpine Linux BusyBox shell
    sudo docker exec -i -t [CONTAINER ID] /bin/sh
    # OR
    # Enter a Linux Bash shell
    sudo docker exec -i -t [CONTAINER ID] /bin/bash
    ```

 2. To open logs
    ```bash
    # get Docker IDs of running containers
    docker ps
    # View and follow container logs
    sudo docker logs -f [CONTAINER ID]
    ```

# TODO: Build and run NGINX Plus Docker container with NGINX Controller Agent

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
