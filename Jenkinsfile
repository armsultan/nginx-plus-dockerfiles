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
                                sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                        }
                    // },
                    //     centos7: {
                    //          withEnv(['DISTRO=centos7',
                    //         'port80=802',
                    //         'port443=4432',
                    //         'port8080=80802'
                    //         ]){
                    //             sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    //             sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    //             sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                    //             sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                    //             sh 'docker images'
                    //             sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                    //     }
                    // },
                    //     debian9: {
                    //          withEnv(['DISTRO=debian9',
                    //         'port80=803',
                    //         'port443=4433',
                    //         'port8080=80803'
                    //         ]){
                    //             sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    //             sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    //             sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                    //             sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                    //             sh 'docker images'
                    //             sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                    //     }
                    // },
                    //     ubuntu16_04: {
                    //         withEnv(['DISTRO=ubuntu16.04',
                    //         'port80=804',
                    //         'port443=4434',
                    //         'port8080=80804'
                    //         ]){
                    //             sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    //             sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    //             sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                    //             sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                    //             sh 'docker images'
                    //             sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                    //     }
                    // },
                    //     ubuntu18_04: {
                    //         withEnv(['DISTRO=ubuntu18.04',
                    //         'port80=805',
                    //         'port443=4435',
                    //         'port8080=80805'
                    //         ]){
                    //             sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    //             sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    //             sh 'cp -R $WORKSPACE/etc $WORKSPACE/Dockerfiles/$DISTRO'
                    //             sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE/Dockerfiles/$DISTRO'
                    //             sh 'docker images'
                    //             sh 'docker run -d -p 80:$port80 -p 443:$port443 -p 8080:$port8080 nginx-plus-$DISTRO'
                    //     }
                    // }
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
