sudo docker kill $(docker ps -q)
sudo docker rm -vf $(docker ps -a -q)
sudo docker rmi -f $(docker images -q)
