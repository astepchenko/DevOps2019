Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.5"
  config.vm.provider :virtualbox do |vb|
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
  config.vm.provision "shell", privileged: false,
    inline: <<-SHELL
      grep -q "192.168.0.11 srv1" /etc/hosts || echo "192.168.0.11 srv1" | sudo tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.12 srv2" /etc/hosts || echo "192.168.0.12 srv2" | sudo tee -a /etc/hosts > /dev/null
      echo "=== $(hostname) /etc/hosts ==="
      cat /etc/hosts
      [ -f /vagrant/id_rsa ] || ssh-keygen -t rsa -f /vagrant/id_rsa -C vagrant@vagrant -q -N ''
      echo "=== Copying public SSH keys to the VM ==="
      mkdir -p /home/vagrant/.ssh
      chmod 700 /home/vagrant/.ssh
      cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
      chmod 600 /home/vagrant/.ssh/id_rsa
      grep -q "vagrant@vagrant" /home/vagrant/.ssh/authorized_keys || cat /vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      chmod 600 /home/vagrant/.ssh/authorized_keys
      echo "Host *" > /home/vagrant/.ssh/config
      echo "StrictHostKeyChecking no" >> /home/vagrant/.ssh/config
      echo "UserKnownHostsFile /dev/null" >> /home/vagrant/.ssh/config
      chmod 600 /home/vagrant/.ssh/config
      echo "=== SSH config ==="
      cat /home/vagrant/.ssh/config
      echo "=== SSH authorized_keys ==="
      cat /home/vagrant/.ssh/authorized_keys
    SHELL
end
