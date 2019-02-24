def repo = 'http://192.168.0.10:8081/nexus/content/repositories/snapshots/task6'
def version = '1.0.0'
def builddir = './build/libs'
def filename = 'greeter.war'
def appname = 'greeter'

def tomcat1 = [:]
tomcat1.name = 'tomcat1'
tomcat1.host = '192.168.0.11'
tomcat1.allowAnyHosts = true
tomcat1.user = 'vagrant'
tomcat1.password = 'vagrant'

def tomcat2 = [:]
tomcat2.name = 'tomcat2'
tomcat2.host = '192.168.0.12'
tomcat2.allowAnyHosts = true
tomcat2.user = 'vagrant'
tomcat2.password = 'vagrant'

node {

    stage('Clone sources') {
        git branch: 'task6', url: 'https://github.com/astepchenko/DevOps2019.git'
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
        sh "curl -XPUT -u admin:admin123 -T ${builddir}/${filename} ${repo}/${version}/${filename}"
    }

    stage('Upload to tomcat1') {
        sshCommand remote: tomcat1, command: "curl -s ${repo}/${version}/${filename} -o /home/vagrant/${filename}"
        sshCommand remote: tomcat1, command: "curl 'http://192.168.0.10/jkmanager/?cmd=update&from=list&w=lb&sw=worker1&vwa=1'"
        sshCommand remote: tomcat1, sudo: true, command: "mv -f /home/vagrant/${filename} /usr/share/tomcat/webapps/ && sleep 10"
        sshCommand remote: tomcat1, command: "curl -s 'http://localhost:8080/${appname}/' | grep -q ${version} && echo 'tomcat1 deploy successfull' || echo 'tomcat1 deploy failed'"
        sshCommand remote: tomcat1, command: "curl 'http://192.168.0.10/jkmanager/?cmd=update&from=list&w=lb&sw=worker1&vwa=0'"
    }

    stage('Upload to tomcat2') {
        sshCommand remote: tomcat2, command: "curl -s ${repo}/${version}/${filename} -o /home/vagrant/${filename}"
        sshCommand remote: tomcat2, command: "curl 'http://192.168.0.10/jkmanager/?cmd=update&from=list&w=lb&sw=worker2&vwa=1'"
        sshCommand remote: tomcat2, sudo: true, command: "mv -f /home/vagrant/${filename} /usr/share/tomcat/webapps/ && sleep 10"
        sshCommand remote: tomcat2, command: "curl -s 'http://localhost:8080/${appname}/' | grep -q ${version} && echo 'tomcat2 deploy successfull' || echo 'tomcat2 deploy failed'"
        sshCommand remote: tomcat2, command: "curl 'http://192.168.0.10/jkmanager/?cmd=update&from=list&w=lb&sw=worker2&vwa=0'"
    }

    stage('Commit and push to github') {
        withCredentials([usernamePassword(credentialsId: 'githubCreds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
            sh "git config --global user.email 'alexander.stepchenko@gmail.com'"
            sh "git config --global user.name 'Aleksandr Stepchenko'"
            sh "git add ."
            sh "git commit -m '${version}'"
            sh "git push https://${USER}:${PASS}@github.com/astepchenko/DevOps2019.git task6"
            sh "git checkout master"
            sh "git merge task6"
            sh "git tag ${version}"
            sh "git push https://${USER}:${PASS}@github.com/astepchenko/DevOps2019.git master --tags"
        }
    }

}
