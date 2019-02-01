Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.5"
  config.vm.provider :virtualbox do |vb|
    # vb.gui = true
    vb.memory = "1024"
  end
  config.vm.define "srv1" do |srv1|
    srv1.vm.network :private_network, ip: "192.168.0.11"
    srv1.vm.hostname = "srv1"
    srv1.vm.provision "shell",
      inline: <<-SHELL
        rpm -qa | grep -qw git && echo "git has already installed" || (yum install -y git && git config --global user.email "aleksandr_stepchenko@epam.com" && git config --global user.name "Aleksandr Stepchenko")
        [ ! -d "DevOps2019" ] && git clone -b task2 https://github.com/astepchenko/DevOps2019.git
        cd DevOps2019
        git pull
        cat test.txt
      SHELL
  end
  config.vm.define "srv2" do |srv2|
    srv2.vm.network :private_network, ip: "192.168.0.12"
    srv2.vm.hostname = "srv2"
  end
  config.vm.provision "shell",
    inline: <<-SHELL
      grep -q "192.168.0.11 srv1" /etc/hosts || echo "192.168.0.11 srv1" | tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.12 srv2" /etc/hosts || echo "192.168.0.12 srv2" | tee -a /etc/hosts > /dev/null
      echo "$(hostname) /etc/hosts"
      echo "====="; cat /etc/hosts; echo "====="
    SHELL
end
