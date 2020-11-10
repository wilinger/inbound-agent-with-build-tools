FROM jenkins/inbound-agent
ARG DOCKER_VERSION=5:19.03.12~3-0~debian-buster
ARG DC_VERSION=1.27.2
ARG TERRAFORM_VERSION=0.13.5
ARG AWS_PROVIDER_VERSION=3.14.1
USER root

RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
    apt-transport-https ca-certificates curl zip gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://apt.releases.hashicorp.com buster main" && \
    apt-get update && \
    apt-get install -qq -y --no-install-recommends docker-ce=${DOCKER_VERSION} terraform=${TERRAFORM_VERSION} && \
    curl -L https://github.com/docker/compose/releases/download/${DC_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    usermod -a -G docker jenkins && \
    curl -L https://releases.hashicorp.com/terraform-provider-aws/${AWS_PROVIDER_VERSION}/terraform-provider-aws_${AWS_PROVIDER_VERSION}_linux_amd64.zip -o /tmp/aws-provider.zip && \
    mkdir -p /usr/lib/terraform-plugins/registry.terraform.io/hashicorp/aws/${AWS_PROVIDER_VERSION}/linux_amd64 && \
    unzip -d /usr/lib/terraform-plugins/registry.terraform.io/hashicorp/aws/${AWS_PROVIDER_VERSION}/linux_amd64 /tmp/aws-provider.zip && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["jenkins-agent"]
