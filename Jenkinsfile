pipeline {
    agent any
     tools{
      gradle 'gradle'
    }
    stages {
        stage('Build') {              
            steps {
               sh '''
      #!/bin/sh
      flutter build apk 
    '''             
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
