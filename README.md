## Docker container custom
* openssh-client
* git
* curl
* nmap
* Openshift CLI - 4 stable
* kubectl
* kubens
* kubectx


**WORK IN PROGRESS**

How to build:
- git clone git@github.com:gar0t0/ssh-bastion-custom.git
- cd ssh-bastion-custom
- docker built -t ssh-bastion-custom .

Connect to the pod:
- docker run -it ssh-bastion-custom /bin/bash
