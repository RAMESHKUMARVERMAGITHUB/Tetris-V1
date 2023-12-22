pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
        // GIT_REPO_NAME = "Tetris-manifest"
        // GIT_USER_NAME = "rameshkumarvermagithub"      # change your Github Username here
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/rameshkumarvermagithub/Tetris-V1.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=TetrisVersion1.0 \
                    -Dsonar.projectKey=TetrisVersion1.0 '''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar' 
                }
            } 
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){   
                       sh "docker build -t rameshkumarverma/tetrisv2 ."
                       // sh "docker tag tetrisv2 sevenajay/tetrisv2:latest "
                       sh "docker push rameshkumarverma/tetrisv2:latest "
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image rameshkumarverma/tetrisv2:latest > trivyimage.txt" 
            }
        }
    //     stage('Checkout Code') {
    //         steps {
    //             git branch: 'main', url: 'https://github.com/Aj7Ay/Tetris-manifest.git'
    //         }
    //     }
    //     stage('Update Deployment File') {
    //         steps {
    //             script {
    //                 withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
    //                    NEW_IMAGE_NAME = "sevenajay/tetrisv1:latest"   #update your image here
    //                    sh "sed -i 's|image: .*|image: $NEW_IMAGE_NAME|' deployment.yml"
    //                    sh 'git add deployment.yml'
    //                    sh "git commit -m 'Update deployment image to $NEW_IMAGE_NAME'"
    //                    sh "git push @github.com/${GIT_USER_NAME}/${GIT_REPO_NAME">https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main"
    //                 }
    //             }
    //         }
    //     }
    // }
}
