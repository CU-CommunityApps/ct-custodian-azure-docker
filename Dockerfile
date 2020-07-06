FROM python:3.7-slim-stretch

# run some updates and set the timezone to eastern
# also install jq json viewer (https://stedolan.github.io/jq/)
# example jq usage: aws ec2 describe-instances | jq
RUN apt-get clean && apt-get update && apt-get -qy upgrade \
    && apt-get -qy install locales tzdata apt-utils software-properties-common build-essential python3 nano graphviz \
    && locale-gen en_US.UTF-8 \
    && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get -qy install jq curl
    
# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# install custodian dependencies and custodian mailer tool (c7n-mailer)
RUN pip3 install c7n_azure c7n-org --upgrade pip\
    && pip3 install pylint
    
RUN az extension add --name azure-devops

# clean up after ourselves, keep image as lean as possible
RUN apt-get remove -qy --purge software-properties-common \
    && apt-get autoclean -qy \
    && apt-get autoremove -qy --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD [ "/bin/bash" ]
