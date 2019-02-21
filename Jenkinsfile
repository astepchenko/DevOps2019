def repo = 'http://192.168.0.10:8081/nexus/content/repositories/snapshots/task6'
def version = '1.0.0'
def builddir = './build/libs'
def appname = 'greeter.war'

node {

    stage('Clone sources') {
        git branch: 'task6', url: 'https://github.com/astepchenko/DevOps2019.git'
        pwd()
    }

    stage('Gradle build') {
        sh script: '''
            chmod +x gradlew
            ./gradlew increment
            ./gradlew build
        '''
    }

    stage('Upload to repo') {
        Properties properties = new Properties()
        File propertiesFile = new File("${env.WORKSPACE}/gradle.properties")
        properties.load(propertiesFile.newDataInputStream())
        version = properties.version
        sh "curl -XPUT -u admin:admin123 -T ${builddir}/${appname} ${repo}/${version}/${appname}"
    }

}

