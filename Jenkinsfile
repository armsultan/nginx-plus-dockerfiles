pipeline {
    agent {
        label 'build' // Use build node
        }
    triggers {
        pollSCM('') // Enabling being build on Push
    }
    stages {
        stage('run-parallel-builds') {
            steps {
                parallel(
                        alpine3_9: {
                            withEnv(['DISTRO=alpine3.9',
                            'port80=80',
                            'port443=443',
                            'port8080=8080'
                            ]){
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker images'
                                sh 'docker run -d -p $port80:80 -p $port443:443 -p $port8080:8080 nginx-plus-$DISTRO'
                        }
                    },
                        centos7: {
                             withEnv(['DISTRO=centos7',
                            'port80=81',
                            'port443=444',
                            'port8080=8081'
                            ]){
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker images'
                                sh 'docker run -d -p $port80:80 -p $port443:443 -p $port8080:8080 nginx-plus-$DISTRO'
                        }
                    },
                        centos7_6: {
                             withEnv(['DISTRO=centos7.6',
                            'port80=82',
                            'port443=445',
                            'port8080=8082'
                            ]){
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker images'
                                sh 'docker run -d -p $port80:80 -p $port443:443 -p $port8080:8080 nginx-plus-$DISTRO'
                        }
                    },
                        debian9: {
                             withEnv(['DISTRO=debian9',
                            'port80=83',
                            'port443=446',
                            'port8080=8083'
                            ]){
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker images'
                                sh 'docker run -d -p $port80:80 -p $port443:443 -p $port8080:8080 nginx-plus-$DISTRO'
                        }
                    },
                        ubuntu16_04: {
                            withEnv(['DISTRO=ubuntu16.04',
                            'port80=84',
                            'port443=447',
                            'port8080=8084'
                            ]){
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker images'
                                sh 'docker run -d -p $port80:80 -p $port443:443 -p $port8080:8080 nginx-plus-$DISTRO'
                        }
                    },
                        ubuntu18_04: {
                            withEnv(['DISTRO=ubuntu18.04',
                            'port80=85',
                            'port443=448',
                            'port8080=8085'
                            ]){
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker images'
                                sh 'docker run -d -p $port80:80 -p $port443:443 -p $port8080:8080 nginx-plus-$DISTRO'
                        }
                    },
                        alpine3_9_tools: {
                            withEnv(['DISTRO=alpine3.9_tools',
                            'port80=86',
                            'port443=449',
                            'port8080=8086'
                            ]){
                                sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                                sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                                sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                                sh 'docker images'
                                sh 'docker run -d -p $port80:80 -p $port443:443 -p $port8080:8080 nginx-plus-$DISTRO'
                        }
                    }
                )
            }
        }
    }
    post {
        cleanup {
            echo 'Cleanup'
            //clean up any resources — images, containers, volumes, and networks — that are dangling (not associated with a container) and any stopped containers and all unused images (not just dangling images)
            sh 'docker system prune -a -f'
            sh 'docker stop $(docker ps -q)'
            sh 'docker rm $(docker ps -a -q)'
            sh 'docker images'
            deleteDir()
        }
    }
}
