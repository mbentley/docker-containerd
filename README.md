# mbentley/containerd

Note: this is no longer maintained simply because I don't use it so I'll just archive it.

## containerd + ctr

1. Start containerd

    ```
    docker run -d \
      --init \
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
      mbentley/containerd:latest
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

## containerd + nerdctl + buildkit

1. Start containerd

    ```
    docker run -d \
      --init \
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
      -e BUILDKITD_ENABLED="true" \
      mbentley/containerd:latest-full
    ```

1. Pull and run a container

    ```
    docker exec -it containerd bash
    nerdctl pull docker.io/library/alpine:latest
    nerdctl run -it --name alpine docker.io/library/alpine:latest sh
    ```

1. Clean up from the container and remove the image

    ```
    nerdctl rm alpine
    nerdctl rmi docker.io/library/alpine:latest
    ```
