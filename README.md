# mbentley/containerd

1. Start containerd

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

1. Pull and run a container

    ```
    docker exec -it containerd bash
    ctr i pull docker.io/library/alpine:latest
    ctr run -t docker.io/library/alpine:latest alpine sh
    ```

1. Clean up from the container and remove the image

    ```
    ctr c rm alpine
    ctr i rm docker.io/library/alpine:latest
    ```
