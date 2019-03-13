# Attention!

The `vm.max_map_count` kernel setting needs to be set to at least **262144** before you run `docker-compose up -d`

Execute the following command in terminal:

`sudo sysctl -w vm.max_map_count=262144`

To set this value permanently, update the `vm.max_map_count` setting in `/etc/sysctl.conf`

To verify after rebooting, run `sysctl vm.max_map_count`