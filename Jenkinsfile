def oldVersion = '0.0.0'
def newVersion = '0.0.0'

node {

    stage('Clone sources') {
        git branch: 'task10', url: 'https://github.com/astepchenko/DevOps2019.git'
    }

    stage('Update attributes') {

        // Debug output
        println env.WORKSPACE

        // attributes/default.rb
        File defaultRb = new File("${env.WORKSPACE}/blue_green/attributes/default.rb")
        defaultRb.write "default['ver'] = '${VER}'"
        sh "cat ${env.WORKSPACE}/blue_green/attributes/default.rb"

        // metadata.rb
        Properties properties = new Properties()
        File propertiesFile = new File("${env.WORKSPACE}/blue_green/metadata.rb")
        properties.load(propertiesFile.newDataInputStream())
        oldVersion = properties.version.replaceAll(/'/, "")
        println "Incrementing version in metadata.rb"
        def patch = oldVersion.substring(oldVersion.lastIndexOf('.') + 1)
        def p = patch.toInteger() + 1
        def major = oldVersion.substring(0, oldVersion.length() - p.toString().length())
        newVersion = major + p.toString()
        println "Previous ${oldVersion}"
        println "Next ${newVersion}"
        sh "sed -i 's/${oldVersion}/${newVersion}/g' ${env.WORKSPACE}/blue_green/metadata.rb"
        sh "cat ${env.WORKSPACE}/blue_green/metadata.rb"

        // import_env_deploy.json
        sh "sed -i 's/${oldVersion}/${newVersion}/g' ${env.WORKSPACE}/import_env_deploy.json"
        sh "cat ${env.WORKSPACE}/import_env_deploy.json"

    }

//    stage('Upload to chef server') {
//        sh "sudo cp -f ./blue-green /home/vagrant/chef-repo/cookbooks/"
//        sh "cd /home/vagrant/chef-repo/cookbooks/blue_green"
//        sh "berks install && berks upload"
//    }
//
//    stage('Push changes to github') {
//        withCredentials([usernamePassword(credentialsId: 'githubCreds', passwordVariable: 'gPASS', usernameVariable: 'gUSER')]) {
//            sh "git config --global user.email 'alexander.stepchenko@gmail.com'"
//            sh "git config --global user.name 'Aleksandr Stepchenko'"
//            sh "git add ."
//            sh "git commit -m '${VER}'"
//            sh "git push https://${gUSER}:${gPASS}@github.com/astepchenko/DevOps2019.git task10"
//        }
//    }
//
//    stage('Start chef-client') {
//        sh "knife ssh 'name:*' 'sudo chef-client' -x root -P vagrant"
//    }

}