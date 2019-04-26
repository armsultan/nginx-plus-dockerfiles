pipeline {
    agent {
        label 'build' // Use build node
        }
    triggers {
        pollSCM('') // Enabling being build on Push
    }
    // environment {
    // }
    stages {
            stage('alpine3.9') {
                steps {
                    script {
                        env.DISTRO = "alpine3.9"
                        env.port80 = 80
                        env.port443 = 443
                        env.port8080 = 8080
                    }
                    sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    sh 'cp $WORKSPACE/Dockerfiles/$DISTRO/Dockerfile $WORKSPACE'
                    sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE --no-cache'
                    sh 'docker images'
                    sh "docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO"
                    //kill all running containers
                    sh 'docker kill $(docker ps -q)'
                }
            }
            stage('centos7') {
                steps {
                    script {
                        env.DISTRO = "centos7"
                        env.port80 = 80
                        env.port443 = 443
                        env.port8080 = 8080
                    }
                    sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    sh 'cp $WORKSPACE/Dockerfiles/$DISTRO/Dockerfile $WORKSPACE'
                    sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE --no-cache'
                    sh 'docker images'
                    sh "docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO"
                    //kill all running containers
                    sh 'docker kill $(docker ps -q)'
                }
            }
            stage('debian9') {
                steps {
                    script {
                        env.DISTRO = "debian9"
                        env.port80 = 80
                        env.port443 = 443
                        env.port8080 = 8080
                    }
                    sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    sh 'cp $WORKSPACE/Dockerfiles/$DISTRO/Dockerfile $WORKSPACE'
                    sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE --no-cache'
                    sh 'docker images'
                    sh "docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO"
                    //kill all running containers
                    sh 'docker kill $(docker ps -q)'
                }
            }
            stage('ubuntu16.04') {
                steps {
                    script {
                        env.DISTRO = "ubuntu16.04"
                        env.port80 = 80
                        env.port443 = 443
                        env.port8080 = 8080
                    }
                    sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    sh 'cp $WORKSPACE/Dockerfiles/$DISTRO/Dockerfile $WORKSPACE'
                    sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE --no-cache'
                    sh 'docker images'
                    sh "docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO"
                    //kill all running containers
                    sh 'docker kill $(docker ps -q)'
                }
            }
            stage('ubuntu18.04') {
                steps {
                    script {
                        env.DISTRO = "ubuntu18.04"
                        env.port80 = 80
                        env.port443 = 443
                        env.port8080 = 8080
                    }
                    sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    sh 'cp $WORKSPACE/Dockerfiles/$DISTRO/Dockerfile $WORKSPACE'
                    sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE --no-cache'
                    sh 'docker images'
                    sh "docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO"
                    //kill all running containers
                    sh 'docker kill $(docker ps -q)'
                }
            }
    }
    post {
        cleanup {
            echo 'Cleanup'
            //kill all running containers
            sh 'docker kill $(docker ps -q)'
            // delete all stopped containers
            sh 'docker rm $(docker ps -a -q)'
            // delete all images
            sh 'docker rmi $(docker images -q)'
            //clean up any resources — images, containers, volumes, and networks — that are dangling (not associated with a container) and any stopped containers and all unused images (not just dangling images)
            sh 'docker system prune -a -f'
            // Delete all others:
            //clean up any resources — images, containers, volumes, and networks — that are dangling (not associated with a container) and any stopped containers and all unused images (not just dangling images)
            //sh 'docker system prune -a -f'
            // docker stop $(docker ps -q)
            // docker rm $(docker ps -a -q)
            // docker rmi $(docker images -q -f dangling=true)
            sh 'docker images'
            deleteDir()
        }
    }
}
