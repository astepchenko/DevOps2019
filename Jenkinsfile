def oldVersion = '0.0.0'
def newVersion = '0.0.0'
def repo = '/home/vagrant/chef-repo'

node {

    stage('Clone sources') {
        git branch: 'task10', url: 'https://github.com/astepchenko/DevOps2019.git'
    }

    stage('Update attributes') {

        // attributes/default.rb
        File defaultRb = new File("${env.WORKSPACE}/blue_green/attributes/default.rb")
        defaultRb.write "default['ver'] = '${VER}'"
        sh "cat ${env.WORKSPACE}/blue_green/attributes/default.rb"

        // metadata.rb
        Properties properties = new Properties()
        File propertiesFile = new File("${env.WORKSPACE}/blue_green/metadata.rb")
        properties.load(propertiesFile.newDataInputStream())
        oldVersion = properties.version.replaceAll(/'/, "")
        def patch = oldVersion.substring(oldVersion.lastIndexOf('.') + 1)
        def p = patch.toInteger() + 1
        def major = oldVersion.substring(0, oldVersion.length() - p.toString().length())
        newVersion = major + p.toString()
        println "Incrementing version in metadata.rb"
        println "Previous ${oldVersion}"
        println "Next ${newVersion}"
        sh "sed -i 's/${oldVersion}/${newVersion}/g' ${env.WORKSPACE}/blue_green/metadata.rb"

        // deploy.json
        sh "sed -i 's/${oldVersion}/${newVersion}/g' ${env.WORKSPACE}/${ENV}.json"
    }

    stage('Upload to chef server') {
        sh "sudo cp -fr ${env.WORKSPACE}/blue_green ${repo}/cookbooks"
        sh "sudo cp -fr ${env.WORKSPACE}/${ENV}.json ${repo}/environments"
        dir('/home/vagrant/chef-repo') {
            sh "sudo knife environment from file environments/${ENV}.json -c ${repo}/.chef/knife.rb"
        }
        dir('/home/vagrant/chef-repo/cookbooks/blue_green') {
            sh "sudo berks install && sudo berks upload"
        }
    }

    stage('Push changes to github') {
        withCredentials([usernamePassword(credentialsId: 'githubCreds', passwordVariable: 'gPASS', usernameVariable: 'gUSER')]) {
            sh "git config --global user.email 'alexander.stepchenko@gmail.com'"
            sh "git config --global user.name 'Aleksandr Stepchenko'"
            sh "git add ."
            sh "git commit -m 'version: ${VER}, environment: ${ENV}'"
            sh "git push https://${gUSER}:${gPASS}@github.com/astepchenko/DevOps2019.git task10"
        }
    }

    stage('Start chef-client') {
        withCredentials([usernamePassword(credentialsId: 'chefCreds', passwordVariable: 'cPASS', usernameVariable: 'cUSER')]) {
            sh "knife ssh 'name:*' 'sudo chef-client' -x ${cUSER} -P ${cPASS} -c ${repo}/.chef/knife.rb"
        }
        sh "curl -s http://node:8080/greeter && echo 'blue is up' || echo 'blue is down'"
        sh "curl -s http://node:8081/greeter && echo 'green is up' || echo 'green is down'"
    }

}