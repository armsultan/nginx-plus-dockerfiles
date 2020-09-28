#!/bin/bash
# Usage EXAMPLE: ./build-nginx-plus.sh ubuntu18.04
distro="$(tr [A-Z] [a-z] <<< "$1")" # set to lowercase

# Check Dockerfile type
is_controller='_controller'
is_nap='_nap'

# Set build directory
build_dir=''

# Optional: Pull Git changes
# git pull --no-edit

#
# Build Controller Agent Docker container
#
if grep -q "$is_controller" <<< "$distro"; then
    # Set build directory
    build_dir='./CONTROLLER-AGENT'
    
    # remove Dockerfile here (if exists)
    rm $build_dir/Dockerfile || true

    # copy desired Dockerfile
    cp Dockerfiles/$distro/Dockerfile $build_dir
    
    # Build and tag it as "nginx-agent-[distro]"
    docker build -t nginx-agent-$distro $build_dir --pull --no-cache # No caching

    # Show all docker containers build with names containing "nginx-plus-"
    printf "\n"
    printf "Nginx Plus with Controller Agent containers built:"
    printf "\n"
    docker images | grep nginx-agent
#
# Build NGINX App Protect Docker container
#
elif grep -q "$is_nap" <<< "$distro"; then
    # Set build directory
    build_dir='./NAP'
    
    # remove Dockerfile here (if exists)
    rm $build_dir/Dockerfile || true

    # copy desired Dockerfile
    cp Dockerfiles/$distro/Dockerfile $build_dir
    
    # Build and tag it as "nginx-app-protect-[distro]"
    docker build -t nginx-app-protect-$distro $build_dir --pull --no-cache # No caching

    # Show all docker containers build with names containing "nginx-plus-"
    printf "\n"
    printf "Nginx App Protect containers built:"
    printf "\n"
    docker images | grep nginx-app-protect
#
# Build NGINX Plus Docker container
#
else
    # Set build directory
    build_dir='./NGINX-PLUS'
    
    # remove Dockerfile here (if exists)
    rm $build_dir/Dockerfile || true

    # copy desired Dockerfile
    cp Dockerfiles/$distro/Dockerfile $build_dir
    
    # Build and tag it as "nginx-plus-[distro]"
    docker build -t nginx-plus-$distro $build_dir --pull --no-cache # No caching

    # Show all docker containers build with names containing "nginx-plus-"
    printf "\n"
    printf "Nginx Plus containers built:"
    printf "\n"
    docker images | grep nginx-plus
fi

# remove Dockerfile from the build directory (if exists)
rm $build_dir/Dockerfile || true