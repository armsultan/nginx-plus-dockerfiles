# Instructions
 1. Place the following files in the directories
    * Download your Keys and Certificates from the [customer portal](https://cs.nginx.com/) or from
    an activated evaluation, `nginx-repo.crt` and `nginx-repo.crt` into `etc/ssl/nginx/`
    * Place your Nginx congurations into `etc/nginx/` (and sub directories like `etc/nginx/conf.d` and `etc/nginx/stream.conf.d`)
 2. Copy the `Dockerfile` for your preferred linux distro found in the `Dockerfiles` folder into the root folder
 3. Edit (add or uncomment) the `Dockerfile` to include any necessary commands to install addtional modules
 4. Make sure the `nginx.conf` (`/etc/nginx/nginx.conf`) includes the necessary `load_modules` directives to load addtional modules installed
 5. Build an image from your Dockerfile:
    ```bash
    # Run command from the folder containing the `Dockerfile`
    # Where "nginx-plus-name" is a descriptive tag
    $ docker build -t nginx-plus-name .
    ```
 6. Start the Nginx Plus container, e.g.:
    ```bash
    # Start a new container and publish container ports 80, 443 and 8080 to the host
    # Where "nginx-plus-name" is a descriptive name
    $ docker --name nginx-plus-name run -d -p 80:80 -p 443:443 -p 8080:8080 nginx-plus-name
    ```
 7. If no custom Nginx confiugrations are provided, the default nginx webpage will be published on `http://localhost` (port `:80`)
 8. If the provided file, `status_api.conf` is loaded then the NGINX Plus live activity monitoring dashboard can be
    accessed from [`http://localhost:8080`](http://localhost:8080)
 9. For troubleshooting or quick nginx configuration edits, you can ssh into container: `docker exec -it <container name> /bin/bash`
