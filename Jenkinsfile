pipeline {
    agent any
     tools{
      gradle 'gradle'    
    }
    stages {
        stage('Build') {              
            steps {
                sh "flutter clean"
                sh "flutter pub get"
//                sh '''
//       #!/bin/sh
//       flutter build apk 
//     '''             
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
