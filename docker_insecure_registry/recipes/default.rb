#
# Cookbook:: docker_insecure_registry
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Install, configure and start docker
docker_service 'default' do
  insecure_registry 'localhost:5000'
  action [:create, :start]
end

# Append vagrant user to docker group
group 'docker' do
  action :modify
  members 'vagrant'
  append true
end  

# Create directory for registry volume
directory '/home/vagrant/registry' do
  owner 'root'
  group 'root'
  mode 00777
  action :create
end

# Pull registry:2 image
docker_image 'registry' do
  tag '2'
  action :pull
end

# Start insecure registry
docker_container 'registry' do
  repo 'registry'
  tag '2'
  port '5000:5000'
  restart_policy 'always'
  volumes '/home/vagrant/registry:/var/lib/registry'
  action :run
end
