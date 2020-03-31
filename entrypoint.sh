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

exec "${@}"
