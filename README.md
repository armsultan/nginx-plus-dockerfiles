# Instructions
 1. Place the following files in the directories
    * Download your Keys and Certificates from the [customer portal](https://cs.nginx.com/) or from
    an activated evaluation, `nginx-repo.crt` and `nginx-repo.crt` into `etc/ssl/nginx/`
    * Your Nginx nginx conigurations in `etc/nginx/` (and sub directories like `etc/nginx/conf.d` and `etc/nginx/stream.conf.d`)
    * If you are doing an "offline" install of Nginx Plus, place the Nginx Plus binaries, `.rpm` or `.deb` files, in the `install` folder
 2. Copy a `Dockerfile` for your preferred linux distro from the `Dockerfiles` folder into the root folder
 3. Build an image from your Dockerfile:
    ```bash
    # Run command from the folder containing the `Dockerfile`
    $ docker build -t nginx-plus-name .
    ```
 3. Start the Nginx Plus container, e.g.:
    ```bash
    # Start a new container and publish container ports 80, 443 and 8080 to the host
    $ docker run -d -p 80:80 -p 443:443 -p 8080:8080 nginx-plus-name
    ```
 4. If no custom Nginx confiugrations are provided, the default nginx webpage will be publishe `http://localhost` (port `:80`)
 5. If the provided file, `status_api.conf` is loaded then the NGINX Plus live activity monitoring dashboard can be
    accessed from [`http://localhost:`](http://localhost:8080)