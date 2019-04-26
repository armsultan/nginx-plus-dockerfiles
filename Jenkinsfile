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
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp $WORKSPACE/Dockerfiles/alpine3.9/Dockerfile $WORKSPACE'
                        sh 'docker build -t nginx-plus-alpine3.9 $WORKSPACE --no-cache'
                        sh 'docker images'
                        sh "docker run -d -p 80:80 -p 443:443 -p 8080:8080 nginx-plus-alpine3.9"
                },
                centos_7: {
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp $WORKSPACE/Dockerfiles/centos7/Dockerfile $WORKSPACE'
                        sh 'docker build -t nginx-plus-centos7 $WORKSPACE --no-cache'
                        sh 'docker images'
                        sh "docker run -d -p 80:801 -p 443:4431 -p 8080:$80801 nginx-plus-centos7"
                },
                debian9: {
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp $WORKSPACE/Dockerfiles/debian9/Dockerfile $WORKSPACE'
                        sh 'docker build -t nginx-plus-debian9 $WORKSPACE --no-cache'
                        sh 'docker images'
                        sh "docker run -d -p 80:802 -p 443:4432 -p 8080:$80802 nginx-plus-debian9"
                },
                ubuntu16_04: {
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp $WORKSPACE/Dockerfiles/ubuntu16.04/Dockerfile $WORKSPACE'
                        sh 'docker build -t nginx-plus-ubuntu16.04 $WORKSPACE --no-cache'
                        sh 'docker images'
                        sh "docker run -d -p 80:803 -p 443:4433 -p 8080:$80803 nginx-plus-ubuntu16.04"
                },
                ubuntu18_04: {
                        sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                        sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                        sh 'cp $WORKSPACE/Dockerfiles/ubuntu18.04/Dockerfile $WORKSPACE'
                        sh 'docker build -t nginx-plus-ubuntu18.04 $WORKSPACE --no-cache'
                        sh 'docker images'
                        sh "docker run -d -p 80:804 -p 443:4434 -p 8080:$80804 nginx-plus-ubuntu18.04"
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
