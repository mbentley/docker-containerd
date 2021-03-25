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

# launch buildkit if it is found and has not been disabled
if [ -f "/usr/local/bin/buildkitd" ] && [ "${BUILDKITD_ENABLED}" = "true" ]
then
  /usr/local/bin/buildkitd &
fi

exec "${@}"
