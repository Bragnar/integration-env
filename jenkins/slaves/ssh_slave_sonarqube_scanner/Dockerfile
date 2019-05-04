FROM jenkins/ssh-slave

#builder additional tools
RUN wget -q --no-check-certificate https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-linux.zip \
 && unzip sonar-scanner-cli-3.3.0.1492-linux.zip \
 && mv sonar-scanner-3.3.0.1492-linux /opt/sonar-scanner \
 && rm -r sonar-scanner-cli-3.3.0.1492-linux*
RUN  echo "export PATH=$PATH:/opt/sonar-scanner/bin" >> /home/jenkins/.bashrc

