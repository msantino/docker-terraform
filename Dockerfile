FROM ubuntu:16.04

# Update system
RUN apt-get update --fix-missing \
    && apt-get -y install \
        ca-certificates \
        jq \
        libffi-dev \
        musl-dev \
        make \
        python3-pip \
        unzip \
        zip \
        curl \
        git \
        docker.io \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y \
    && apt-get auto-remove -y \
    && apt-get autoclean -y

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install --upgrade pip pipenv
RUN pip3 install google-cloud-bigquery==1.11.2

ENV TERRAFORM_VER 0.12.12
ENV TERRAFORM_ZIP terraform_${TERRAFORM_VER}_linux_amd64.zip

RUN curl -o /tmp/${TERRAFORM_ZIP} https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/${TERRAFORM_ZIP} \
    && unzip /tmp/${TERRAFORM_ZIP} -d /usr/local/bin \
    && rm /tmp/${TERRAFORM_ZIP}

ENV GCLOUD_SDK_VER 283.0.0
ENV GCLOUD_SDK_TAR google-cloud-sdk-${GCLOUD_SDK_VER}-linux-x86_64.tar.gz
ENV PATH /google-cloud-sdk/bin:$PATH

RUN curl -o /tmp/${GCLOUD_SDK_TAR} https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_SDK_TAR} \
    && tar xzf /tmp/${GCLOUD_SDK_TAR} -C / \
    && /google-cloud-sdk/install.sh \
    && rm /tmp/${GCLOUD_SDK_TAR} \
    && gcloud components install beta

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN pip3 install awscli

RUN unlink /bin/sh && ln -s /bin/bash /bin/sh
RUN ln -s /google-cloud-sdk/bin/gcloud /bin/

RUN mkdir -p /project

WORKDIR /project
