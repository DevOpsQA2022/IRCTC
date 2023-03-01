pipeline {
    agent any
     tools{
      gradle 'gradle'    
    }
  
    stages {
        stage('Build') {
            steps {
                //sh "flutter"
                bat "flutter clean"
                bat "git config --global --add safe.directory C:/Users/manjula.r/Desktop/flutter"
               bat "flutter pub get"
                
           
                bat "flutter build apk --debug"
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
