Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  
  config.vm.define "node" do |node|
    node.vm.network :private_network, ip: "192.168.0.11"
    node.vm.hostname = "node"
    node.vm.provider :virtualbox do |vb|
      vb.memory = "512"
    end
    node.vm.provision "shell",
      inline: <<-SHELL
        yum install -y yum-utils
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        yum -y install docker-ce
        systemctl enable docker
        systemctl restart docker
        usermod -aG docker vagrant
        cp /vagrant/daemon.json /etc/docker/daemon.json
        systemctl restart docker
        docker pull mate:5000/greeter:1.0.21
        docker pull mate:5000/greeter:1.0.22
      SHELL
  end

  config.vm.define "chef" do |chef|
    chef.vm.network :private_network, ip: "192.168.0.10"
    chef.vm.hostname = "chef"
    chef.vm.provider :virtualbox do |vb|
      vb.memory = "1024"
    end
    chef.vm.provision "shell",
      inline: <<-SHELL
        # install Java
        yum install -y git java-1.8.0-openjdk-devel

        # install Jenkins
        curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | tee /etc/yum.repos.d/jenkins.repo
        rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
        yum install -y jenkins
        chkconfig jenkins on
        echo 'Starting Jenkins...' && systemctl start jenkins
      
        # install Chef Server Standalone
        rpm -Uvh https://packages.chef.io/files/stable/chef-server/12.19.31/el/7/chef-server-core-12.19.31-1.el7.x86_64.rpm
        chef-server-ctl reconfigure
        
        # install Chef Manage UI
        chef-server-ctl install chef-manage
        chef-server-ctl reconfigure
        chef-manage-ctl reconfigure --accept-license
        
        # install and configure ChefDK
        rpm -Uvh https://packages.chef.io/files/stable/chefdk/3.8.14/el/7/chefdk-3.8.14-1.el7.x86_64.rpm
        echo 'eval "$(chef shell-init bash)"' >> /home/vagrant/.bashrc
        echo 'export PATH="/opt/chefdk/embedded/bin:$PATH"' >> /home/vagrant/.bashrc && source /home/vagrant/.bashrc
        chef generate repo chef-repo
        mkdir -p /home/vagrant/chef-repo/.chef
        echo '.chef' >> /home/vagrant/chef-repo/.gitignore
        chef-server-ctl user-create vagrant Chef Admin vagrant@chef.io 'vagrant' --filename /home/vagrant/chef-repo/.chef/vagrant.pem
        chef-server-ctl org-create chef 'Chef' --association_user vagrant --filename /home/vagrant/chef-repo/.chef/chef-validator.pem
        cp /vagrant/knife.rb /home/vagrant/chef-repo/.chef/
        cd /home/vagrant/chef-repo
        knife ssl fetch
        knife ssl check
        knife client list
        knife bootstrap 192.168.0.11 -N node -x vagrant -P vagrant --sudo

        # configure Jenkins
        mkdir /var/lib/jenkins/init.groovy.d
        cp /vagrant/security.groovy /var/lib/jenkins/init.groovy.d/
        sed -i 's/false/true/g' /var/lib/jenkins/jenkins.CLI.xml
        chown -R jenkins:jenkins /var/lib/jenkins
        echo 'Restarting Jenkins...' && systemctl restart jenkins && sleep 100
        cd /home/vagrant
        curl http://localhost:8080/jnlpJars/jenkins-cli.jar -o jenkins-cli.jar
        java -jar jenkins-cli.jar -s http://localhost:8080 -noKeyAuth -auth admin:admin install-plugin 'uno-choice' -restart
      SHELL
  end

  config.vm.provision "shell",
    inline: <<-SHELL
      grep -q "192.168.0.1 mate" /etc/hosts || echo "192.168.0.1 mate" | tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.10 chef" /etc/hosts || echo "192.168.0.10 chef" | tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.11 node" /etc/hosts || echo "192.168.0.11 node" | tee -a /etc/hosts > /dev/null
      echo "=== $(hostname) /etc/hosts ==="
      cat /etc/hosts
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd
    SHELL

end