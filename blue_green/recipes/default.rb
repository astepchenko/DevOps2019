#
# Cookbook:: blue_green
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Install, configure and start docker
docker_service 'default' do
  insecure_registry 'mate:5000'
  action [:create, :start]
end

# Append vagrant user to docker group
group 'docker' do
  action :modify
  members 'vagrant'
  append true
end  

# Pull greeter image
docker_image 'greeter' do
  repo 'mate:5000/greeter'
  tag node['ver']
  action :pull_if_missing
end

bash 'blue_vs_green' do
  code <<-EOH
    if ! (true &>/dev/null </dev/tcp/localhost/8080);
    then
      docker run -d -p 8080:8080 --name greeter-blue "mate:5000/greeter:#{node['ver']}" && sleep 5
      (true &>/dev/null </dev/tcp/localhost/8080) && (echo 'blue ok' && docker rm greeter-green --force > /dev/null || true) || echo 'blue fail'
    else
      docker run -d -p 8081:8080 --name greeter-green "mate:5000/greeter:#{node['ver']}" && sleep 5
      (true &>/dev/null </dev/tcp/localhost/8081) && (echo 'green ok' && docker rm greeter-blue --force > /dev/null || true) || echo 'green fail'
    fi
  EOH
  action :run
end