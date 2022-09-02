# rebased/repackaged base image that only updates existing packages
FROM mbentley/ubuntu:20.04
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

ARG DEBIAN_FRONTEND=noninteractive

# install containerd packaged by Docker, Inc.
RUN apt-get update &&\
  apt-get install -y apt-transport-https ca-certificates curl gnupg iproute2 iptables kmod net-tools socat &&\
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - &&\
  echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" > /etc/apt/sources.list.d/docker.list &&\
  apt-get update &&\
  apt-get install -y containerd.io &&\
  rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/docker.list

# install containerd plugins
RUN apt-get update &&\
  apt-get install -y jq &&\
  PLUGINS_VER="$(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest | jq -r .tag_name)" &&\
  mkdir -p /opt/cni/bin /opt/containerd &&\
  cd /opt/cni/bin &&\
  ln -s /opt/cni/bin /opt/containerd/bin &&\
  cd /opt/cni/bin &&\
  curl -sL "https://github.com/containernetworking/plugins/releases/download/${PLUGINS_VER}/cni-plugins-linux-amd64-${PLUGINS_VER}.tgz" -o "cni-plugins-linux-amd64-${PLUGINS_VER}.tgz" &&\
  tar xvf "cni-plugins-linux-amd64-${PLUGINS_VER}.tgz" &&\
  ISOLATION_PLUGIN_VER="$(curl -s https://api.github.com/repos/AkihiroSuda/cni-isolation/releases/latest | jq -r .name)" &&\
  curl -sL "https://github.com/AkihiroSuda/cni-isolation/releases/download/${ISOLATION_PLUGIN_VER}/cni-isolation-amd64.tgz" -o cni-isolation-amd64.tgz &&\
  tar xvf cni-isolation-amd64.tgz &&\
  apt-get purge -y jq &&\
  apt-get autoremove -y &&\
  rm -rf "cni-plugins-linux-amd64-${PLUGINS_VER}.tgz" cni-isolation-amd64.tgz /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/var/lib/containerd"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/containerd"]
