Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.5"
  config.vm.provider :virtualbox do |vb|
    # vb.gui = true
    vb.memory = "1024"
  end
  config.vm.define "srv1" do |srv1|
    srv1.vm.network :private_network, ip: "192.168.0.11"
    srv1.vm.hostname = "srv1"
  end
  config.vm.define "srv2" do |srv2|
    srv2.vm.network :private_network, ip: "192.168.0.12"
    srv2.vm.hostname = "srv2"
  end
  config.vm.provision "file", source: "id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  public_key = File.read("id_rsa.pub")
  config.vm.provision "shell", privileged: false,
    inline: <<-SHELL
      grep -q "192.168.0.11 srv1" /etc/hosts || echo "192.168.0.11 srv1" | sudo tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.12 srv2" /etc/hosts || echo "192.168.0.12 srv2" | sudo tee -a /etc/hosts > /dev/null
      echo "$(hostname) /etc/hosts"
      echo "====="; cat /etc/hosts; echo "====="
      echo "Copying public SSH keys to the VM"
      mkdir -p /home/vagrant/.ssh
      chmod 700 /home/vagrant/.ssh
      grep -q "vagrant@vagrant" /home/vagrant/.ssh/authorized_keys || echo "#{public_key}" >> /home/vagrant/.ssh/authorized_keys
      chmod -R 600 /home/vagrant/.ssh/authorized_keys
      echo "Host *" > /home/vagrant/.ssh/config
      echo "StrictHostKeyChecking no" >> /home/vagrant/.ssh/config
      echo "UserKnownHostsFile /dev/null" >> /home/vagrant/.ssh/config
      chmod -R 600 /home/vagrant/.ssh/config
      echo "SSH config"
      cat /home/vagrant/.ssh/config
      echo "SSH authorized_keys"
      cat /home/vagrant/.ssh/authorized_keys
    SHELL
end
