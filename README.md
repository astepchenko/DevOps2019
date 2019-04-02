## Blue-green deployment

### Useful commands

Folder **chef-repo**

`cd ~/chef-repo/cookbooks`
`cd ~/chef-repo/cookbooks/blue_green`
`cd ~/chef-repo/environments`
`cd ~/chef-repo/roles`

Cookbook **blue_green**

`chef generate cookbook blue_green`

`nano ~/chef-repo/cookbooks/blue_green/metadata.rb`
`nano ~/chef-repo/cookbooks/blue_green/recipes/default.rb`
`nano ~/chef-repo/cookbooks/blue_green/test/integration/default/default_test.rb`

Environment **deploy**

`knife environment create deploy -d --description "The blue-green deploy environment"`
`knife environment list -w`
`knife environment show deploy`
`knife node environment set node deploy`

After every changes in `./recipes/default.rb` increase version in **metadata.rb** and upload the updated cookbook to Chef server:

`berks install && berks upload`

Use this command to deploy environment:

`knife ssh 'name:*' 'sudo chef-client' -x root -P vagrant`
`knife ssh 'role:deploy' 'sudo chef-client' -x root -P vagrant`

Check port
`true &>/dev/null </dev/tcp/localhost/8080 && echo open || echo closed`
`curl -s http://localhost:8081/greeter && echo open || echo closed`