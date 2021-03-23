# NGINX Plus Dockerfiles

A Bunch of Dockerfiles for [NGINX Plus, NGINX App Protect and NGINX Instance Manager](https://www.nginx.com/products/nginx/).

* Try NGINX Plus and NGINX App Protect: **Just add [licenses](https://www.nginx.com/free-trial-request/)**
* Try NGINX Instance Manager: **Just add [licenses](https://www.nginx.com/products/nginx/nginx-instance-manager/)**
## Build and run NGINX Plus Docker containers (Using Script)

Run `./build-nginx-plus.sh [build_name]`, where `[build_name]` one of:

| `[build_name]`            | Description           |
| ------------------------- |--------------------------------------------------| 
|`alpine3.10`               | Alpine Linux 3.10 with NGINX Plus                  |
|`alpine3.11`               | Alpine Linux 3.11 with NGINX Plus                  |
|`alpine3.12`               | Alpine Linux 3.11 with NGINX Plus                  |
|`alpine3.12_tools`          | Alpine Linux 3.12 with NGINX Plus and HTTP tools    |
|`amazonlinux`              | Amazon Linux with NGINX Plus                       |
|`amazonlinux2`             | Amazon Linux 2 with NGINX Plus                     |
|~~`amazonlinux2_controller`~~  | ~~Amazon Linux 2 with NGINX Plus and Controller agent~~ |
|`centos7`                  | Centos 7 with NGINX Plus                           |
|`centos7.6`                | Centos 7.6 with NGINX Plus                         |
|`centos7.6_nap`            | Centos 7.6 with NGINX App Protect                  |
|`centos7.6_nim`            | Centos 7.6 with NGINX Instance Manager with NGINX plus     |
|~~`centos7.6_controller`~~   | ~~Centos 7.6 with NGINX Plus and Controller agent~~    |
|`centos8`                  | Centos 8 with NGINX Plus                           |
|`rhel7`                    | Red Hat (Universal Base) 7 with NGINX Plus                           |
|`rhel8`                    | Red Hat (Universal Base) 8 with NGINX Plus                           |
|`rhel8_nim`                | Red Hat (Universal Base) 8 with NGINX Instance Manager with NGINX plus     |
|`debian9`                  | Debian 9 with NGINX Plus                           |
|~~`debian9_controller`~~   | ~~Debian 9 with NGINX Plus and Controller agent~~      |
|`debian10`                 | Debian 10 with NGINX Plus                          |
|`debian10_nim`                 | Debian 10 with NGINX Instance Manager with NGINX plus                          |
|`ubuntu18.04`              | Ubuntu 18.04 with NGINX Plus                       |
|~~`ubuntu18.04_controller`~~   | ~~Ubuntu 18.04 with NGINX Plus and Controller agent~~  |
|`ubuntu18.04_crossplane`    | Ubuntu 18.04 with NGINX Plus and Crossplane        |
|`ubuntu18.04_nap`          | Ubuntu 18.04 with NGINX App Protect                |
|`ubuntu20.04`              | Ubuntu 20.04 with NGINX Plus                       |
|`ubuntu20.04_nim`          | Ubuntu 20.04 with NGINX Instance Manager with NGINX plus     |

## Build NGINX Plus Docker container using script

 1. Prepare your NGINX license files in the correct build directories:
      * **For NGINX Plus and NGINX App Protect:** Copy your `nginx-repo.crt` and `nginx-repo.key` into [`etc/ssl/nginx`](./NGINX-PLUS/ssl/nginx) directory
      * **For NGINX Instance Manager and NGINX App Protect:** Copy your `nginx-repo.crt` and `nginx-repo.key` into [`etc/ssl/nginx`](./NGINX-PLUS/ssl/nginx) directory, **Additionally**, Copy your `NGINX-Instance-Manager.lic` (may be named differently) into the `/etc/nginx-manager/` directory. It is referenced by the `license:` option in the `/etc/nginx-manager/nginx-manager.conf` file, and has already been set in the [file](./NIM/etc/nginx-manager/nginx-manager.conf) provided in this repo 

 2. Build an image from your Dockerfile:
    ```bash
    # ./build-nginx-plus.sh [Build-name]
    $ ./build-nginx-plus.sh ubuntu18.04_nap
    ```

 3. See the Docker images available
    ```bash
    # NGINX PLUS images are named nginx-plus-[build]
    $ docker images | grep nginx-plus
    # NGINX App Protect images are named nginx-app-protect-[build]
    $ docker images | grep nginx-app-protect
    # NGINX Instance Manager images are named nginx-nim-[build]
    $ docker images | grep nginx-nim
    # NGINX PLUS with Controller Agent images are named nginx-agent-[build]
    $ docker images | grep nginx-agent
    ```
## Build NGINX Plus Docker container Manually

 1. Prepare your NGINX license files in the correct build directories:
      * **For NGINX Plus and NGINX App Protect:** Copy your `nginx-repo.crt` and `nginx-repo.key` into [`etc/ssl/nginx`](./NGINX-PLUS/ssl/nginx) directory
      * **For NGINX Instance Manager and NGINX App Protect:** Copy your `nginx-repo.crt` and `nginx-repo.key` into [`etc/ssl/nginx`](./NGINX-PLUS/ssl/nginx) directory, **Additionally**, Copy your `NGINX-Instance-Manager.lic` (may be named differently) into the `/etc/nginx-manager/` directory. It is referenced by the `license:` option in the `/etc/nginx-manager/nginx-manager.conf` file, and has already been set in the [file](./NIM/etc/nginx-manager/nginx-manager.conf) provided in this repo 
 2. Copy the desired [`Dockerfile`](./Dockerfiles) into the correct build folder:
      * [`NGINX-PLUS`](./NGINX-Plus) - NGINX Plus only
      * [`NAP`](./NAP) - NGINX App Protect
      * [`NIM`](./NIM) - NGINX Instance Manager with NGINX Plus
 2. Build an image from your Dockerfile:
    ```bash
    # Run command from the folder containing the `Dockerfile`
    # docker build -t [docker_image_name] .
    $ docker build -t nginx-plus .
    ```

## Run the Container

 1. Start the container, e.g.:
    ```bash
    # e.g. NGINX Plus, NGINX App Protect
    # Start a new container and publish container ports 80, 443 and 8080 to the host
    # Where [docker_image_name] is found on the last step
    $ docker run -d -p 80:80 -p 443:443 -p 8080:8080 [docker_image_name]

    # e.g. NGINX Instance Manager
    # Start a new container and publish container ports 80, 443, 8080 and 10002 to the host
    # Where [docker_image_name] is found on the last step
    $ docker run -d -p 80:80 -p 443:443 -p 8080:8080 -p 10002:10002 [docker_image_name]
    ```

 2. **Optional**: Mount local volume:

    ```bash
    docker run -d \
      -p 80:80 -p 443:443 \
      -p 8080:8080 \
      -v $PWD/etc/nginx:/etc/nginx [docker_image_name]
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

## TODO

* See [todo](todo.md)
