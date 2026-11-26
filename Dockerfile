FROM ubuntu:24.04
LABEL maintainer="maxmilio@fav.zcu.cz" \
      org.opencontainers.image.source="https://github.com/maxotta/iac-development-container"

# Set the default workspace directory   
ARG WORKSPACE_DIR=/workspace
# Volume for preserving the private & public SSH keys for accessing remote VMs
ARG PERSISTENT_DATA_DIR=/var/iac-dev-container-data

ENV DEBIAN_FRONTEND noninteractive

# Set locale to UTF-8 (mainly for Ansible)
ENV LC_ALL C.UTF-8
RUN echo 'LANG=C.UTF-8' > /etc/default/locale

# Prepare for the installation of external repositories
RUN set -uex; \
    apt-get upgrade ; \
    apt-get update ; \
    apt-get -y install unzip gnupg software-properties-common ca-certificates curl apt-transport-https ; \
    mkdir -p /etc/apt/keyrings

# Install Python toolset, Ansible and Docker libraries
RUN apt-get -y install git python3 python3-pip pipenv python3-venv
RUN apt-get -y install ansible
RUN apt-get -y install python3-docker

# Install Terraform
# Add HashiCorp repos and install Terraform
RUN set -uex; \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg ; \
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint ; \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list ; \
    apt-get update ;\
    apt-get -y install terraform

# Install Kubernetes tools
RUN mkdir -p -m 755 /etc/apt/keyrings
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.37/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN chmod 644 /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get -y install kubectl
RUN apt-get -y install kubeadm

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash

# Install AWS CLI
RUN apt-get -y install groff
RUN curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash -s -- --system

# Install other fancy stuff
RUN apt-get -y install inetutils-ping
RUN apt-get -y install apt-utils
RUN apt-get -y install cowsay
RUN apt-get -y install lolcat

COPY help.txt /etc
COPY init-iac-dev.sh /etc

RUN echo '. /etc/init-iac-dev.sh' >> /root/.bashrc ; \
    echo 'export TF_VAR_vm_ssh_pubkey="`cat ${PERSISTENT_DATA_DIR}/id_rsa.pub`"' >> /root/.bashrc

COPY aws-config ${PERSISTENT_DATA_DIR}/
COPY aws-credentials ${PERSISTENT_DATA_DIR}/

WORKDIR ${WORKSPACE_DIR}

VOLUME ${WORKSPACE_DIR} ${PERSISTENT_DATA_DIR}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PERSISTENT_DATA_DIR ${PERSISTENT_DATA_DIR}
ENV SHELL /bin/bash

# Prevent the container to exit
CMD sleep infinity
