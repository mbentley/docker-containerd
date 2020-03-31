# docker-containerd

1. Start engine

    ```
    docker run -d \
      --name containerd \
      --hostname containerd \
      --restart unless-stopped \
      --privileged \
      -v /lib/modules:/lib/modules:ro \
      -v containerd-root:/root \
      -v containerd-opt-containerd:/opt/containerd \
      -v containerd-var-lib-containerd:/var/lib/containerd \
      --tmpfs /run \
      -e MOUNT_PROPAGATION="/" \
      mbentley/containerd
    ```

1. Communicate with that engine

    ```
    docker -H tcp://localhost:1000 info
    ```
