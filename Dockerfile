FROM ubuntu:focal

ENV TERRAGRUNT_VERSION="0.38.9"
ENV TERRAFORM_VERSION="1.2.8"
ENV GOVC_VERSION="0.29.0"

LABEL "Author"="LookinBehind"

# Install necessary packages
RUN apt-get update \
&& apt-get install -y --no-install-recommends zip unzip wget ca-certificates git \
&& apt-get purge -y --auto-remove \
&& rm -rf /var/lib/apt/lists/*

# Configure terraform certificates
COPY certs/*.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Install terragrunt
RUN wget --no-check-certificate https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
&& mv terragrunt_linux_amd64 terragrunt \
&& chmod u+x terragrunt \
&& mv terragrunt /usr/bin/ \
&& terragrunt --version

# Install terraform
RUN wget --no-check-certificate https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& mv terraform /usr/bin/terraform \
&& chmod u+x /usr/bin/terraform \
&& terraform --version

# Install govc
RUN wget https://github.com/vmware/govmomi/releases/download/v${GOVC_VERSION}/govc_Linux_x86_64.tar.gz \
&& tar -xzvf govc_Linux_x86_64.tar.gz \
&& mv govc /usr/bin/govc \
&& chmod u+x /usr/bin/govc \
&& govc version

# Install kubectl
RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.6.4/bin/linux/amd64/kubectl \
&& mv kubectl /usr/bin/kubectl \
&& chmod u+x /usr/bin/kubectl \
&& kubectl version --client