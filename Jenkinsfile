def port80 = 80
def port443 = 443
def port8080 = 8080
def mocksport = 0 as Integer
def port = 1000 as Integer

pipeline {
    agent {
        label 'build' // Use build node
        }
    triggers {
        pollSCM('') // Enabling being build on Push
    }
    // environment {
    // }
    // stage('run-parallel-branches') {
    // steps {
    //     parallel(
    //     a: {
    //         echo "This is branch a"
    //     },
    //     b: {
    //         echo "This is branch b"
    //     }
    //     )
    // }
    // }
    stages {
            stage('Build') {
                steps {
                    script {
                        env.DISTRO = "alpine3.9"
                    }
                    sh 'cp /etc/ssl/nginx/nginx-repo.key $WORKSPACE/etc/ssl/nginx'
                    sh 'cp /etc/ssl/nginx/nginx-repo.crt $WORKSPACE/etc/ssl/nginx'
                    sh 'cp $WORKSPACE/Dockerfiles/$DISTRO/Dockerfile $WORKSPACE'
                    sh 'docker build -t nginx-plus-$DISTRO $WORKSPACE --no-cache'
                    // script {
                    //     DOCKER_IMAGE = docker.build DISTRO + ":$BUILD_NUMBER"
                    // }
                    port = (port as Integer) % 99 + 9000;
                    mocksport = (port as Integer) + 1;
                    echo "Application will be deployed on port ${port}"
                    echo "Mocks will be deployed on port ${mocksport}"​​​​​​​​​​​​​
                    sh 'docker images'
                    echo "${port80} -p 443:${port443} -p 8080:${port8080}"
                    sh 'docker run -d -p 80:"${port80}" -p 443:${port443} -p 8080:${port8080} nginx-plus-$DISTRO'
                    script {
                        port80 = port80 + 1;
                        port443 = port443 + 1;
                        port8080 = port8080 + 1;
                    }
                }
            }
    }
    post {
        cleanup {
            echo 'Cleanup'
            // Remove the image built in this build
            sh 'docker rmi $DOCKER_IMAGE_TAG'
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
