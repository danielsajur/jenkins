sudo mkdir /srv/backup
sudo docker stop hitss-jenkins
sudo docker rm hitss-jenkins
sudo docker rmi danielsajur/jenkins:1.0.0
sudo docker rmi danielsajur/jenkins:latest
sudo docker build . --force-rm --tag danielsajur/jenkins:1.0.0 --tag danielsajur/jenkins:latest
sudo docker run -d --name hitss-jenkins -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker -v /home/daniel/.m2/repository:/root/.m2/repository -p 50001:8080 -p 50000:50000 danielsajur/jenkins

