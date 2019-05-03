FROM jenkins/jenkins:2.164.2
USER root
RUN apt-get update && apt-get install -y make git openjdk-8-jdk vim sudo

# MAVEN INSTALL
RUN mkdir /usr/lib/mvn && cd /usr/lib/mvn/
RUN wget https://www-us.apache.org/dist/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
RUN tar -xf apache-maven-3.6.1-bin.tar.gz && rm -rf apache-maven-3.6.1-bin.tar.gz
RUN mv apache-maven-3.6.1 /usr/lib/mvn/apache-maven-3.6.1

# DEFINE BACKUP FOLDER IN DOCKER VOLUME
RUN mkdir /srv/backup && chown jenkins:jenkins /srv/backup
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins
RUN echo 2.164.2 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
RUN echo 2.164.2 > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# INSTALL DOCKER DEAMON
USER root
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install docker-ce -y
RUN usermod -aG docker jenkins
RUN echo "docker ALL=NOPASSWD: ALL" >> /etc/sudoers


ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV M2_HOME /usr/lib/mvn/apache-maven-3.6.1
ENV MAVEN_HOME ${M2_HOME}
ENV PATH ${MAVEN_HOME}/bin:${JAVA_HOME}/bin:${PATH}

COPY --chown=jenkins:jenkins config_jenkins /var/jenkins_home
