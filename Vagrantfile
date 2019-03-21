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
          echo 'hello'
        SHELL
    end
    config.vm.define "node1" do |node1|
      node1.vm.network :private_network, ip: "192.168.0.11"
      node1.vm.hostname = "node1"
      node1.vm.provision "shell",
        inline: <<-SHELL
          echo 'hello'
        SHELL
    end
    config.vm.provision "shell",
      inline: <<-SHELL
        echo 'hello'
      SHELL
  end