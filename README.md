# NGINX Plus Dockerfiles

A Bunch of Dockerfiles for [NGINX Plus](https://www.nginx.com/products/nginx/).
**Just add licenses**

# Instructions
 1. Place the following files in the directories
    * Retrieve your NGINX Plus Key and Certificate from the NGINX [customer portal](https://cs.nginx.com/) or from an activated evaluation, and copy the `nginx-repo.crt` and `nginx-repo.crt` files into `etc/ssl/nginx/`
    * Place your NGINX Plus configurations into `etc/nginx/`, including files in sub directories i.e. `etc/nginx/conf.d` and `etc/nginx/stream.conf.d`
 2. Copy the `Dockerfile` for your preferred Linux distro found in the `Dockerfiles/` folder   into the root folder
 3. Modify the `Dockerfile` as necessary, e.g. uncomment optional install commands to install addtional NGINX Plus [Dynamic modules](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/dynamic-modules/)
 4. If you are installing NGINX Plus Dynamic modules, make sure your `nginx.conf` (`/etc/nginx/nginx.conf`) includes the necessary `load_modules` directives to load the Dynamic modules installed
 5. Build an image from the Dockerfile:
    ```bash
    # Run command from the folder containing the `Dockerfile`
    # (Replace "nginx-plus-name" is a descriptive tag)
    $ docker build -t nginx-plus-name .
    ```
 6. Start the Nginx Plus container:
    ```bash
    # Start a new container and publish container ports 80, 443 and 8080 to the docker host
    # (Replace "--name nginx-plus-name" is a descriptive name)
    $ docker run -d -p 80:80 -p 443:443 -p 8080:8080 \
                 --name nginx-plus-name nginx-plus-name 
    ```
    **OR**
    ```bash
    # mount local a directory (or directories) using -v flag
    docker run -d -p 80:80 -p 443:443 -p 8080:8080 \
               -v "$(pwd)/etc/nginx/conf.d:/etc/nginx/conf.d" \
               --name nginx-plus-name nginx-plus-name
    ```
 7. For troubleshooting or quick nginx configuration edits, you `exec` into the container:
    ```bash
    docker exec -it <container name> /bin/bash
    ```