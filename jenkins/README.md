# Automatic generate Jenkins configuration from Dockerfile.

---

I try to learning how to automate the installation and configuration of Jenkins using Docker and the Jenkins Configuration as Code (JCasC) method.

## Requirements Parameters

| Parameters | Description | Defaults Value |
| -- | -- | -- |
| JENKINS_USER | Create a Jenkins administrtor account | admin |
| JENKINS_PASS | Create a Jenkins administrtor password | admin |

## Pre-installed Tools

* Docker
* Ansible
* jq

## Usage

I use `Makefile` to generate a Jenkins image. You can use the `make` command to check how to use it.

```shell
Usage:
  make <target>

Docker
  show             Show current running container
  build            Build Jenkins Image, defaults ANSIBLE_VERSION=7.2.0, JAVA_USE_MEMORY=2048m
  run              Start container, when exiting the container will be gone.
```

Before you run `make build`, you must to setup **JENKINS_USER** and **JENKINS_PASS** in your environment.

```shell
export JENKINS_USER=admin
export JENKINS_PASS=admin

make build
```

After building Jenkins image is finished

```shell
make run
```

## Reference

* [Mandarin: 客製化Jenkins docker image](https://www.tpisoftware.com/tpu/articleDetails/2849)
* [Mandarin: Jenkins on Windows 心得分享 (06)：如何指定 Mirror 鏡像網站下載外掛](https://blog.miniasp.com/post/2021/05/02/Jenkins-on-Windows-06-Specify-Mirror-Site-to-Download-Plugins)
* [DigitalOcean: how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code](https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code)
* [eficode: start-jenkins-config-as-code](https://www.eficode.com/blog/start-jenkins-config-as-code)
* [Medium: Automating Jenkins Setup using Docker and Jenkins Configuration as Code](https://abrahamntd.medium.com/automating-jenkins-setup-using-docker-and-jenkins-configuration-as-code-897e6640af9d)
* [Medium: Custom Jenkins Dockerfile : Jenkins Docker Image with Pre-Installed Plugins , Default admin user creation and Pre-Installed Docker Binaries](https://medium.com/the-devops-ship/custom-jenkins-dockerfile-jenkins-docker-image-with-pre-installed-plugins-default-admin-user-d0107b582577)
* [Github: abrahamNtd/jcasc-poc](https://github.com/abrahamNtd/jcasc-poc.git)
* [Github: jenkinsci/configuration-as-code-plugin](https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos/jenkins)
* [Github: foxylion/docker-jenkins](https://github.com/foxylion/docker-jenkins)
