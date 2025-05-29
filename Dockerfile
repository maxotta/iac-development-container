FROM ubuntu:24.04
LABEL maintainer="maxmilio@kiv.zcu.cz" \
      org.opencontainers.image.source="https://github.com/maxotta/iac-dev-docker"

ARG WORKSPACE_DIR=/workspace
# Volume for preserving the private & public SSH keys for accessing remote VMs
ARG PERSISTENT_DATA_DIR=/var/iac-dev-container-data

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'LANG=C.UTF-8' > /etc/default/locale
ENV LC_ALL C.UTF-8

# Prepare for the installation of external repositories
RUN set -uex; \
    apt-get upgrade ; \
    apt-get update ; \
    apt-get -y install gnupg software-properties-common ca-certificates curl apt-transport-https ; \
    mkdir -p /etc/apt/keyrings

# Add HashiCorp repos and install Terraform
RUN set -uex; \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg ; \
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint ; \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list ; \
    apt-get update ;\
    apt-get -y install terraform

# Add NodeJS repos and install NodeJS
RUN set -uex; \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
    NODE_MAJOR=22; \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" > /etc/apt/sources.list.d/nodesource.list; \
    apt-get update; \
    apt-get install nodejs -y;

# Install Terrafrom CDK
RUN npm install --global cdktf-cli@latest

# Install Python toolset, Ansible and Docker libraries
RUN apt-get -y install git python3 python3-pip pipenv python3-venv
RUN apt-get -y install ansible
RUN apt-get -y install python3-docker

COPY init-iac-dev.sh /etc

RUN echo '. /etc/init-iac-dev.sh' >> /root/.bashrc ; \
    echo 'export TF_VAR_vm_ssh_pubkey="`cat ${PERSISTENT_DATA_DIR}/id_ecdsa.pub`"' >> /root/.bashrc

WORKDIR ${WORKSPACE_DIR}

VOLUME ${WORKSPACE_DIR} ${PERSISTENT_DATA_DIR}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PERSISTENT_DATA_DIR ${PERSISTENT_DATA_DIR}
ENV SHELL /bin/bash
ENV ANSIBLE_HOST_KEY_CHECKING False

# Prevent the container to exit
CMD [ "sleep", "infinity" ]
