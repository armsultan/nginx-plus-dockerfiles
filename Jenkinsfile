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
                    withEnv(['DISTRO = alpine3.9',
                            'port80 = 80',
                            'port443 = 443',
                            'port8080 = 8080'
                    ]){
                        alpine3_9: {
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                                sh 'docker images'
                                sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                        }
                    },
                    withEnv(['DISTRO = centos7',
                            'port80 = 802',
                            'port443 = 4432',
                            'port8080 = 80802'
                    ]){
                        centos7: {
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                                sh 'docker images'
                                sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                        }
                    },
                    withEnv(['DISTRO = debian9',
                            'port80 = 803',
                            'port443 = 4433',
                            'port8080 = 80803'
                    ]){
                        debian9: {
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                                sh 'docker images'
                                sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                        }
                    },
                    withEnv(['DISTRO = ubuntu16.04',
                            'port80 = 804',
                            'port443 = 4434',
                            'port8080 = 80804'
                    ]){
                        ubuntu16_04: {
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                                sh 'docker images'
                                sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                        }
                    },
                    withEnv(['DISTRO = ubuntu18.04',
                            'port80 = 805',
                            'port443 = 4435',
                            'port8080 = 80805'
                    ]){
                        ubuntu18_04: {
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -r $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO --no-cache'
                                sh 'docker images'
                                sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                        }
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
