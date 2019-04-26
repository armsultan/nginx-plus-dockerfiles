pipeline {
    agent {
        label 'build' // Use build node
        }
    triggers {
        pollSCM('') // Enabling being build on Push
    }
    stages {
        stage('run-parallel-branches') {
            steps {
                parallel(
                alpine3_9: {
                        script {
                            env.DISTRO = "alpine3.9"
                            env.port80 = 80
                            env.port443 = 443
                            env.port8080 = 8080
                        }
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                        sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                        sh 'docker images'
                        sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                },
                centos_7: {
                        script {
                            env.DISTRO = "centos7"
                            env.port80 = 802
                            env.port443 = 4432
                            env.port8080 = 80802
                        }
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                        sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                        sh 'docker images'
                        sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                },
                debian9: {
                        script {
                            env.DISTRO = "debian9"
                            env.port80 = 803
                            env.port443 = 4433
                            env.port8080 = 80803
                        }
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                        sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                        sh 'docker images'
                        sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                },
                ubuntu16_04: {
                        script {
                            env.DISTRO = "deubuntu16.04"
                            env.port80 = 804
                            env.port443 = 4434
                            env.port8080 = 80804
                        }
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                        sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                        sh 'docker images'
                        sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                },
                ubuntu18_04: {
                        script {
                            env.DISTRO = "ubuntu18.04"
                            env.port80 = 805
                            env.port443 = 4435
                            env.port8080 = 80805
                        }
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                        sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                        sh 'docker images'
                        sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                }
                )
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
