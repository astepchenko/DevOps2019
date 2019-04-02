#
# Cookbook:: blue_green
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Pull greeter image
docker_image 'greeter' do
  repo 'mate:5000/greeter'
  tag node['ver']
  action :pull_if_missing
end

bash 'blue_vs_green' do
  code <<-EOH
    curl -s http://localhost:8080/greeter && \
    (docker run -d -p 8081:8080 --name greeter-green "mate:5000/greeter:#{node['ver']}" && docker rm greeter-blue --force || true) || \
    (docker run -d -p 8080:8080 --name greeter-blue "mate:5000/greeter:#{node['ver']}" && docker rm greeter-green --force || true)
  EOH
  action :run
end
