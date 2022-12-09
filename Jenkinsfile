pipeline {
    agent any
     tools{
      gradle 'gradle'    
    }
  
    stages {
        stage('Build') { 
            steps {
                withEnv(["PATH+FLUTTER=FLUTTER_PATH"]) {
                    echo "PATH is: C:\flutter\bin"
                    sh 'flutter'
                }
            }
            steps {
                sh "flutter"
                
              
//                 sh "flutter clean"
//                 sh "flutter pub get"
//                 bat "flutter clean"
//                bat "flutter pub get"
                
           
                sh "flutter build apk --debug"
                echo "successfully build"
                
            }
              post{
                 success{
                     echo "Archiving the Artifacts"
                     archiveArtifacts artifacts: '**/debug/*.apk'
                    
                 }
            }            
        }
    }
}
