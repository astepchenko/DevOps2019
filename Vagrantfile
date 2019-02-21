tomcat_count = 2
prefix = "tomcat"
baseip = "192.168.0"

$script_hosts = <<-SCRIPT
  grep -q '192.168.0.10' /etc/hosts || echo '192.168.0.10 master' | tee -a /etc/hosts > /dev/null
  for x in {11..#{10+tomcat_count}}; do
    grep -q #{baseip}.${x} /etc/hosts || {
      echo #{baseip}.${x} #{prefix}${x##?} | sudo tee -a /etc/hosts > /dev/null
    }
  done
  echo '=== $(hostname) /etc/hosts ==='
  cat /etc/hosts
SCRIPT

$script_tomcat = <<-SCRIPT
  yum install -y java-1.8.0-openjdk tomcat tomcat-webapps tomcat-admin-webapps
  systemctl enable tomcat
  systemctl restart tomcat
SCRIPT

$script_master = <<-SCRIPT
  yum install -y git java-1.8.0-openjdk-devel
 
  curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | tee /etc/yum.repos.d/jenkins.repo
  rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
  yum install -y jenkins
  systemctl enable jenkins
  systemctl restart jenkins
  echo 'Initial password is:'
  cat /var/lib/jenkins/secrets/initialAdminPassword
  # firewall-cmd --permanent --zone=public --add-port=8080/tcp
  # firewall-cmd --reload

  rm -r /opt/nexus*
  echo 'Installing nexus...'
  # wget https://download.sonatype.com/nexus/oss/nexus-latest-bundle.tar.gz
  tar xf /vagrant/nexus-latest-bundle.tar.gz -C /opt
  mv /opt/nexus-* /opt/nexus
  # adduser nexus
  # chown -R nexus:nexus /opt/nexus
  export NEXUS_HOME=/opt/nexus
  cp /vagrant/nexus /etc/init.d/
  chmod 755 /etc/init.d/nexus
  chown root /etc/init.d/nexus
  cd /etc/init.d
  chkconfig --add nexus
  chkconfig --levels 345 nexus on
  service nexus start

  yum install -y httpd
  systemctl enable httpd
  cp /vagrant/mod_jk.so /etc/httpd/modules/
  # generating httpd.conf
  grep -q 'LoadModule jk_module modules/mod_jk.so' /etc/httpd/conf/httpd.conf || echo 'LoadModule jk_module modules/mod_jk.so' | tee -a /etc/httpd/conf/httpd.conf
  grep -q 'JkWorkersFile conf/workers.properties' /etc/httpd/conf/httpd.conf || echo 'JkWorkersFile conf/workers.properties' | tee -a /etc/httpd/conf/httpd.conf
  grep -q 'JkShmFile /tmp/shm' /etc/httpd/conf/httpd.conf || echo 'JkShmFile /tmp/shm' | tee -a /etc/httpd/conf/httpd.conf
  grep -q 'JkLogFile logs/mod_jk.log' /etc/httpd/conf/httpd.conf || echo 'JkLogFile logs/mod_jk.log' | tee -a /etc/httpd/conf/httpd.conf
  grep -q 'JkLogLevel info' /etc/httpd/conf/httpd.conf || echo 'JkLogLevel info' | tee -a /etc/httpd/conf/httpd.conf
  grep -q 'JkMount /jkmanager* status' /etc/httpd/conf/httpd.conf || echo 'JkMount /jkmanager* status' | tee -a /etc/httpd/conf/httpd.conf
  # generating workers.properties
  echo 'worker.list=lb, status' > /etc/httpd/conf/workers.properties
  echo 'worker.lb.type=lb' >> /etc/httpd/conf/workers.properties
  echo 'worker.status.type=status' >> /etc/httpd/conf/workers.properties
  string='worker.lb.balance_workers=worker1'
  for x in {2..#{tomcat_count}}; do
    string=$string', worker'$x
  done
  echo $string  >> /etc/httpd/conf/workers.properties
  for x in {1..#{tomcat_count}}; do
    echo 'worker.worker${x}.host=#{prefix}${x-10}' >> /etc/httpd/conf/workers.properties
    echo 'worker.worker${x}.port=8009' >> /etc/httpd/conf/workers.properties
    echo 'worker.worker${x}.type=ajp13' >> /etc/httpd/conf/workers.properties
  done
  echo '=== $(hostname) /etc/httpd/conf/workers.properties ==='
  cat /etc/httpd/conf/workers.properties
  systemctl restart httpd
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.5"
  config.vm.provider :virtualbox do |vb|
  vb.memory = "1024"
  end
  (1..tomcat_count).each do |i|
    vm_name = "#{prefix}#{i}"
    config.vm.define vm_name do |tomcat|
      tomcat.vm.hostname = vm_name
      ip="#{baseip}.#{10+i}"
      tomcat.vm.network :private_network, ip: ip
      tomcat.vm.provision "shell", inline: $script_tomcat
    end
  end
  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network :private_network, ip: "192.168.0.10"
    master.vm.network :forwarded_port, guest: 80, host: 8080
    master.vm.provision "shell", inline: $script_master
  end
  config.vm.provision "shell", inline: $script_hosts
end
