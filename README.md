## Cookbook **docker_insecure_registry**
First create role **registry** and add recipe **docker_insecure_registry** to run list and add role to nodes you need.

After every changes in the recipe increase version in **metadata.rb** and upload the updated recipe to your Chef server via:

`berks install && berks upload`

Then run Chef client to deploy:

`knife ssh 'role:registry' 'sudo chef-client' -x root -P *******`