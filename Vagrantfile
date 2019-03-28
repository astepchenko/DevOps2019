Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  
  config.vm.define "blue" do |blue|
    blue.vm.network :private_network, ip: "192.168.0.11"
    blue.vm.hostname = "blue"
    blue.vm.provider :virtualbox do |vb|
      vb.memory = "512"
    end
  end

  config.vm.define "green" do |green|
    green.vm.network :private_network, ip: "192.168.0.12"
    green.vm.hostname = "green"
    green.vm.provider :virtualbox do |vb|
      vb.memory = "512"
    end
  end

  config.vm.define "chef" do |chef|
    chef.vm.network :private_network, ip: "192.168.0.10"
    chef.vm.hostname = "chef"
    chef.vm.provider :virtualbox do |vb|
      vb.memory = "1024"
    end
    chef.vm.provision "shell",
      inline: <<-SHELL
        yum install -y git
      
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
        knife bootstrap 192.168.0.11 -N blue -x vagrant -P vagrant --sudo
        knife bootstrap 192.168.0.12 -N green -x vagrant -P vagrant --sudo
      SHELL
  end

  config.vm.provision "shell",
    inline: <<-SHELL
      grep -q "192.168.0.10 chef" /etc/hosts || echo "192.168.0.10 chef" | tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.11 blue" /etc/hosts || echo "192.168.0.11 blue" | tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.12 green" /etc/hosts || echo "192.168.0.12 green" | tee -a /etc/hosts > /dev/null
      echo "=== $(hostname) /etc/hosts ==="
      cat /etc/hosts
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd
    SHELL

  end