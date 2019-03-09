The vm.max_map_count kernel setting needs to be set to at least 262144 before you run 'docker-compose up -d'.

Run the following command in terminal:

sudo sysctl -w vm.max_map_count=262144