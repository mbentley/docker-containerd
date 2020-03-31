FROM ubuntu:18.04
MAINTAINER Matt Bentley <mbentley@mbentley.net>

# install containerd packaged by Docker, Inc.
RUN apt-get update &&\
  apt-get install -y apt-transport-https ca-certificates curl gnupg iproute2 module-init-tools net-tools socat &&\
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - &&\
  echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list &&\
  apt-get update &&\
  apt-get install -y containerd.io &&\
  rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/docker.list

# install containerd plugins
RUN mkdir -p /opt/containerd/bin &&\
  cd /opt/containerd/bin &&\
  curl -sL "https://github.com/containernetworking/plugins/releases/download/v0.8.5/cni-plugins-linux-amd64-v0.8.5.tgz" -o cni-plugins-linux-amd64-v0.8.5.tgz &&\
  tar xvf cni-plugins-linux-amd64-v0.8.5.tgz &&\
  rm cni-plugins-linux-amd64-v0.8.5.tgz

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/var/lib/containerd"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/containerd"]
