FROM jenkins/jenkins:2.392-jdk11

USER root

# Setup locale
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get -y update && apt-get install --fix-missing && apt-get upgrade -y && apt-get install -y locales && \
    sed 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' -i /etc/locale.gen && \
    DEBIAN_FRONTEND=noninteractive locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Setup timezone
ENV TZ=Asia/Taipei
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install docker
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce

# Install docker-compose
ARG buildtime_DOCKER_COMPOSE_VERSION
ENV DOCKER_COMPOSE_VERSION=${buildtime_DOCKER_COMPOSE_VERSION:-2.16.0}
RUN \
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Package 'python-pip' has no installation candidate on Ubuntu 20.04, use 'python3-pip' to replace it.
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    curl \
    dnsutils \
    git \
    gettext-base \
    jq \
    lsof \
    net-tools \
    python3-pip \
    rsync \
    software-properties-common \
    tig \
    telnet \
    tar \
    tree \
    unzip \
    vim \
    wget \
    xz-utils \
    zip

# Upgrade pip
RUN pip install --upgrade pip

# Prerequisite install of ansible packages
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get install -y sshpass openssh-client

# Install ansible
ARG buildtime_ANSIBLE_VERSION
ENV ANSIBLE_VERSION=${buildtime_ANSIBLE_VERSION:-7.2.0}
RUN \
    pip install ansible==${ANSIBLE_VERSION} && \
    pip install ansible-lint

# Create ansible work directory
RUN \
    mkdir -p /work/ansible && \
    chown -R jenkins:jenkins /work

# Create jenkins log path and grant permission
RUN \
    mkdir -p /var/log/jenkins && \
    chown -R jenkins:jenkins /var/log/jenkins

USER jenkins

# Setup Jenkins home
ENV JENKINS_HOME /var/jenkins_home

# Setup jenkins log path
ENV JENKINS_OPTS="--logfile=/var/log/jenkins/jenkins.log"

# Setup jenkins mirro site
ENV JENKINS_UC_DOWNLOAD http://ftp-chi.osuosl.org/pub/jenkins/

# Skip setup jenkins process
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Setup casc
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

# Setup default user and password
ARG buidtime_JENKINS_USER
ARG buidtime_JENKINS_PASS
ENV JENKINS_USER=${buidtime_JENKINS_USER:-admin}
ENV JENKINS_PASS=${buidtime_JENKINS_PASS:-admin}

# Install jenkins default plugins and extra-plugins
COPY casc.yaml ${JENKINS_HOME}/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/
COPY extra-plugins.txt plugins.txt /usr/share/jenkins/ref/
RUN \
    jenkins-plugin-cli --verbose --plugins $(cat /usr/share/jenkins/ref/plugins.txt) && \
    jenkins-plugin-cli --verbose --plugins $(cat /usr/share/jenkins/ref/extra-plugins.txt)

# Create jenkins defaults user and password
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

EXPOSE 22
VOLUME [ "/work", "/var/jenkins_home", "/var/log/jenkins" ]

WORKDIR /work
