Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"
    config.vm.provider :virtualbox do |vb|
    vb.memory = "1024"
    end
    config.vm.define "chef" do |chef|
      chef.vm.network :private_network, ip: "192.168.0.10"
      #chef.vm.network :forwarded_port, guest: 80, host: 8080
      chef.vm.hostname = "chef"
      chef.vm.provision "shell",
        inline: <<-SHELL
          rpm -Uvh /vagrant/chef-server-core-12.19.31-1.el7.x86_64.rpm
          chef-server-ctl reconfigure
        SHELL
    end
    config.vm.define "node1" do |node1|
      node1.vm.network :private_network, ip: "192.168.0.11"
      node1.vm.hostname = "node1"
      node1.vm.provision "shell",
        inline: <<-SHELL
          yum install -y java-1.8.0-openjdk
        SHELL
    end
    config.vm.provision "shell",
      inline: <<-SHELL
        grep -q "192.168.0.10 chef" /etc/hosts || echo "192.168.0.10 chef" | tee -a /etc/hosts > /dev/null
        grep -q "192.168.0.11 node1" /etc/hosts || echo "192.168.0.11 node1" | tee -a /etc/hosts > /dev/null
        echo "=== $(hostname) /etc/hosts ==="
        cat /etc/hosts
      SHELL
  end