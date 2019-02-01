Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.5"
  config.vm.provider :virtualbox do |vb|
  vb.memory = "1024"
  end
  config.vm.define "tomcat1" do |tomcat1|
    tomcat1.vm.network :private_network, ip: "192.168.0.11"
    # for testing purposes only
    # tomcat1.vm.network :forwarded_port, guest: 8080, host: 18081
    tomcat1.vm.hostname = "tomcat1"
    tomcat1.vm.provision "shell",
      inline: <<-SHELL
        yum install -y java-1.8.0-openjdk tomcat tomcat-webapps tomcat-admin-webapps
        systemctl enable tomcat
        systemctl restart tomcat
        mkdir -p /usr/share/tomcat/webapps/test
        echo "tomcat1" | tee /usr/share/tomcat/webapps/test/index.html > /dev/null
      SHELL
  end
  config.vm.define "tomcat2" do |tomcat2|
    tomcat2.vm.network :private_network, ip: "192.168.0.12"
    # for testing purposes only
    # tomcat2.vm.network :forwarded_port, guest: 8080, host: 18082
    tomcat2.vm.hostname = "tomcat2"
    tomcat2.vm.provision "shell",
      inline: <<-SHELL
        yum install -y java-1.8.0-openjdk tomcat tomcat-webapps tomcat-admin-webapps
        systemctl enable tomcat
        systemctl restart tomcat
        mkdir -p /usr/share/tomcat/webapps/test
        echo "tomcat2" | tee /usr/share/tomcat/webapps/test/index.html > /dev/null
      SHELL
  end
  config.vm.define "master" do |master|
    master.vm.network :private_network, ip: "192.168.0.10"
    master.vm.network :forwarded_port, guest: 80, host: 8080
    master.vm.hostname = "master"
    master.vm.provision "shell",
      inline: <<-SHELL
        yum install -y httpd
        systemctl enable httpd
        systemctl restart httpd
        cp /vagrant/mod_jk.so /etc/httpd/modules/
        echo "worker.list=lb" > /etc/httpd/conf/workers.properties
        echo "worker.lb.type=lb" >> /etc/httpd/conf/workers.properties
        echo "worker.lb.balance_workers=worker1, worker2" >> /etc/httpd/conf/workers.properties
        echo "worker.worker1.host=tomcat1" >> /etc/httpd/conf/workers.properties
	      echo "worker.worker1.port=8009" >> /etc/httpd/conf/workers.properties
	      echo "worker.worker1.type=ajp13" >> /etc/httpd/conf/workers.properties
        echo "worker.worker2.host=tomcat2" >> /etc/httpd/conf/workers.properties
	      echo "worker.worker2.port=8009" >> /etc/httpd/conf/workers.properties
	      echo "worker.worker2.type=ajp13" >> /etc/httpd/conf/workers.properties
        grep -q "LoadModule jk_module modules/mod_jk.so" /etc/httpd/conf/httpd.conf || echo "LoadModule jk_module modules/mod_jk.so" | tee -a /etc/httpd/conf/httpd.conf
        grep -q "JkWorkersFile conf/workers.properties" /etc/httpd/conf/httpd.conf || echo "JkWorkersFile conf/workers.properties" | tee -a /etc/httpd/conf/httpd.conf
        grep -q "JkShmFile /tmp/shm" /etc/httpd/conf/httpd.conf || echo "JkShmFile /tmp/shm" | tee -a /etc/httpd/conf/httpd.conf
        grep -q "JkLogFile logs/mod_jk.log" /etc/httpd/conf/httpd.conf || echo "JkLogFile logs/mod_jk.log" | tee -a /etc/httpd/conf/httpd.conf
        grep -q "JkLogLevel info" /etc/httpd/conf/httpd.conf || echo "JkLogLevel info" | tee -a /etc/httpd/conf/httpd.conf
        grep -q "JkMount /test* lb" /etc/httpd/conf/httpd.conf || echo "JkMount /test* lb" | tee -a /etc/httpd/conf/httpd.conf
        systemctl restart httpd
      SHELL
  end
  config.vm.provision "shell",
    inline: <<-SHELL
      grep -q "192.168.0.10 master" /etc/hosts || echo "192.168.0.10 master" | tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.11 tomcat1" /etc/hosts || echo "192.168.0.11 tomcat1" | tee -a /etc/hosts > /dev/null
      grep -q "192.168.0.12 tomcat2" /etc/hosts || echo "192.168.0.12 tomcat2" | tee -a /etc/hosts > /dev/null
      echo "$(hostname) /etc/hosts"
      echo "====="; cat /etc/hosts; echo "====="
    SHELL
end
