#/bin/bash
#Written by Frazz stkd.io
#This "should" automate the update process for ibp monitor nodes.

#Update the git_ variables as needed.
git_path='/home/IBP/ibp-monitor'
git_branch='0.1.0'


docker_path=$git_path'/docker/docker-compose.yml'

docker compose -f $docker_path down

docker system prune -a

git -C $git_path pull 
git -C $git_path checkout $git_branch

#Sed commands to update the docker compose to not expose internal services externally.
sed -i "s/'6379:6379'/'127.0.0.1:6379:6379'/g" $docker_path
sed -i "s/'3306:3306'/'127.0.0.1:3306:3306'/g" $docker_path
sed -i "s/'3000:3000'/'127.0.0.1:3000:3000'/g" $docker_path

#Sed commands to update the docker compose to expose with nginix and SSL
sed -i "s/- '30002:30002'/- '127.0.0.1:30002:30002'/g" $docker_path
sed -i "s/- '30001:80'/- '127.0.0.1:30001:80'/g" $docker_path

docker compose -f $docker_path build
docker compose -f $docker_path up -d
