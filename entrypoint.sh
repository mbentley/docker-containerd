#!/bin/sh

# set mount propagation
if [ -n "${MOUNT_PROPAGATION}" ]
then
  for MOUNT in ${MOUNT_PROPAGATION}
  do
    echo "Mounting ${MOUNT} as 'rshared'..."
    mount --make-rshared "${MOUNT}"
  done
fi

# cgroup v2: enable nesting (from https://github.com/moby/moby/blob/v20.10.8/hack/dind#L28-L38)
if [ -f /sys/fs/cgroup/cgroup.controllers ]
then
  echo -n "INFO: cgroups v2 detected; enabling nesting..."
  # move the processes from the root group to the /init group,
  # otherwise writing subtree_control fails with EBUSY.
  # An error during moving non-existent process (i.e., "cat") is ignored.
  mkdir -p /sys/fs/cgroup/init
  xargs -rn1 < /sys/fs/cgroup/cgroup.procs > /sys/fs/cgroup/init/cgroup.procs || :
  # enable controllers
  sed -e 's/ / +/g' -e 's/^/+/' < /sys/fs/cgroup/cgroup.controllers \
    > /sys/fs/cgroup/cgroup.subtree_control
  echo "done"
fi

# launch buildkit if it is found and has not been disabled
if [ -f "/usr/local/bin/buildkitd" ] && [ "${BUILDKITD_ENABLED}" = "true" ]
then
  /usr/local/bin/buildkitd &
fi

exec "${@}"
