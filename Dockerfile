FROM ubuntu:25.10
LABEL org.opencontainers.image.authors="Kok How, Teh <funcoolgeeek@gmail.com>"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y --fix-missing
RUN apt upgrade -y
RUN apt install -y software-properties-common apt-transport-https curl sudo gnupg unzip ca-certificates mysql-client postgresql-client dnsutils wget git nodejs npm python3 python3-pip python3-tk docker-buildx
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN wget -q https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.deb
RUN dpkg -i ./jdk-25_linux-x64_bin.deb
RUN rm -f jdk-25_linux-x64_bin.deb
RUN ls -l /usr/lib/jvm
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-25.0.2-oracle-x64/bin/java 2525
RUN curl -sL -o /tmp/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN unzip /tmp/awscliv2.zip -d /tmp
RUN /tmp/aws/install
RUN curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# https://www.rabbitmq.com/release-information to find out the latest version
ENV RABBITMQ_VER="4.2.2"
RUN wget -q https://raw.githubusercontent.com/rabbitmq/rabbitmq-server/v$RABBITMQ_VER/deps/rabbitmq_management/bin/rabbitmqadmin -O /usr/local/bin/rabbitmqadmin
RUN chmod +x /usr/local/bin/rabbitmqadmin
RUN apt install -y golang-go redis-tools
ENV DOCKER_CLIENT_VER=29.1.3
RUN curl -sL -o /tmp/docker-$VER.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLIENT_VER.tgz
RUN tar -xz -C /tmp -f /tmp/docker-$VER.tgz
RUN mv /tmp/docker/* /usr/local/bin
RUN curl -sL -o /tmp/gcloud.tgz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
RUN tar -xf /tmp/gcloud.tgz
RUN ./google-cloud-sdk/install.sh -q
RUN rm -f /tmp/gcloud.tgz
# https://github.com/fullstorydev/grpcurl/releases
ENV GRPCURL_VER="1.9.3"
RUN wget -q https://github.com/fullstorydev/grpcurl/releases/download/v$GRPCURL_VER/grpcurl_${GRPCURL_VER}_linux_x86_64.tar.gz
RUN tar -xvf grpcurl_${GRPCURL_VER}_linux_x86_64.tar.gz -C /usr/local/bin
RUN rm -f grpcurl_${GRPCURL_VER}_linux_x86_64.tar.gz
RUN npm install -g n yarn
RUN n latest
#ENTRYPOINT ["bash"]
CMD ["/bin/bash"]
