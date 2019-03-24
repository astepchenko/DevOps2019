Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.provider :virtualbox do |vb|
    vb.memory = "1024"
  end
  
  config.vm.define "node1" do |node1|
    node1.vm.network :private_network, ip: "192.168.0.11"
    node1.vm.hostname = "node1"
  end

  config.vm.define "chef" do |chef|
    chef.vm.network :private_network, ip: "192.168.0.10"
    chef.vm.hostname = "chef"
    chef.vm.provision "shell",
      inline: <<-SHELL
        yum install -y git
      
        # install Chef Server Standalone
        rpm -Uvh /vagrant/chef-server-core-12.19.31-1.el7.x86_64.rpm
        chef-server-ctl reconfigure 
        
        # install Chef Server Standalone WebGUI
        # chef-server-ctl install chef-manage 
        # chef-server-ctl reconfigure
        # chef-manage-ctl reconfigure 
        
        # install and configure ChefDK
        rpm -Uvh /vagrant/chefdk-3.8.14-1.el7.x86_64.rpm
        echo 'eval "$(chef shell-init bash)"' >> /home/vagrant/.bashrc
        echo 'export PATH="/opt/chefdk/embedded/bin:$PATH"' >> /home/vagrant/.bashrc && source /home/vagrant/.bashrc
        chef generate repo chef-repo
        mkdir -p /home/vagrant/chef-repo/.chef
        echo '.chef' >> /home/vagrant/chef-repo/.gitignore
        chef-server-ctl user-create vagrant Chef Admin vagrant@vagrant 'vagrant' --filename /home/vagrant/chef-repo/.chef/vagrant.pem
        chef-server-ctl org-create chef 'Chef' --association_user vagrant --filename /home/vagrant/chef-repo/.chef/chef-validator.pem
        cp /vagrant/knife.rb /home/vagrant/chef-repo/.chef/
        cd /home/vagrant/chef-repo
        knife ssl fetch
        knife ssl check
        knife client list
        knife bootstrap 192.168.0.11 -N node1 -x vagrant -P vagrant --sudo
      SHELL
  end

  config.vm.provision "shell",
    inline: <<-SHELL
      grep -q "192.168.0.10 chef" /etc/hosts || echo "192.168.0.10 chef" | tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.11 node1" /etc/hosts || echo "192.168.0.11 node1" | tee -a /etc/hosts > /dev/null
      echo "=== $(hostname) /etc/hosts ==="
      cat /etc/hosts
      sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
      systemctl restart sshd
    SHELL

  end