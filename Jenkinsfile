def repo = 'http://localhost:8081/nexus/content/repositories/snapshots/task7a'
def version = '0.0.0'
def builddir = './build/libs'
def filename = 'greeter.war'
def appname = 'greeter'
def hostip = InetAddress.localHost.canonicalHostName

node {

    stage('Clone sources') {
        git branch: 'task7a', url: 'https://github.com/astepchenko/DevOps2019.git'
    }

    stage('Gradle build') {
        sh script: '''
            chmod +x gradlew
            ./gradlew increment
            ./gradlew build
        '''
    }

    stage('Get version') {
        Properties properties = new Properties()
        File propertiesFile = new File("${env.WORKSPACE}/gradle.properties")
        properties.load(propertiesFile.newDataInputStream())
        version = properties.version
    }

    stage('Upload to repo') {
        withCredentials([usernamePassword(credentialsId: 'nexusCreds', passwordVariable: 'nPASS', usernameVariable: 'nUSER')]) {
            sh "curl -XPUT -u ${nUSER}:${nPASS} -T ${builddir}/${filename} ${repo}/${version}/${filename}"
        }
    }

    stage('Build docker image') {
        sh "docker build -t ${appname}:${version} --build-arg VERSION=${version} ."
        sh "docker image tag ${appname}:${version} localhost:5000/${appname}:${version}"
        sh "docker push localhost:5000/${appname}:${version}"
        sh "docker service ls | grep -q ${appname} && docker service update --image ${appname}:${version} ${appname} || docker service create --name ${appname} --publish 9090:8080 ${appname}:${version}"
        sh "curl -s 'http://${hostip}:9090/${appname}/' | grep -q ${version} && echo 'Deploy successfull' || echo 'Deploy failed'"
    }

    stage('Commit and push to github') {
        withCredentials([usernamePassword(credentialsId: 'githubCreds', passwordVariable: 'gPASS', usernameVariable: 'gUSER')]) {
            sh "git config --global user.email 'alexander.stepchenko@gmail.com'"
            sh "git config --global user.name 'Aleksandr Stepchenko'"
            sh "git add ."
            sh "git commit -m '${version}'"
            sh "git push https://${gUSER}:${gPASS}@github.com/astepchenko/DevOps2019.git task7a"
            sh "git checkout master"
            sh "git merge task7a"
            sh "git tag ${version}"
            sh "git push https://${gUSER}:${gPASS}@github.com/astepchenko/DevOps2019.git master --tags"
        }
    }
}
