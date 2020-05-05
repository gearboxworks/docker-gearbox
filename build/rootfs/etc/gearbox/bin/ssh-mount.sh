#!/bin/bash

# exec >& /tmp/log

if [ -z "${GEARBOX_MOUNT_PATH}" ]
then
	exit
fi

if [ -z "${GEARBOX_MOUNT_HOST}" ]
then
	exit
fi

if [ -z "${GEARBOX_MOUNT_PORT}" ]
then
	exit
fi


if [ -z "${GEARBOX_MOUNT_USER}" ]
then
	GEARBOX_MOUNT_USER="gearbox"
fi

if [ -z "${GEARBOX_MOUNT_PASSWORD}" ]
then
	GEARBOX_MOUNT_PASSWORD="box"
fi

if [ ! -d "${GEARBOX_MOUNT_PATH}" ]
then
	sudo mkdir -p "${GEARBOX_MOUNT_PATH}" >& /dev/null
fi

GEARBOX_MOUNT_UID="$(id -u gearbox 2> /dev/null)"
GEARBOX_MOUNT_GID="$(id -g gearbox 2> /dev/null)"

echo "${GEARBOX_MOUNT_PASSWORD}" | sudo sshfs "${GEARBOX_MOUNT_USER}@${GEARBOX_MOUNT_HOST}:${GEARBOX_MOUNT_PATH}" "${GEARBOX_MOUNT_PATH}" -o uid="${GEARBOX_MOUNT_UID}" -o gid="${GEARBOX_MOUNT_GID}" -o allow_other -o port="${GEARBOX_MOUNT_PORT}" -o StrictHostKeyChecking=no -o password_stdin > /tmp/log 2>&1

#(
#	echo "${GEARBOX_MOUNT_PASSWORD}" | sudo sshfs "${GEARBOX_MOUNT_USER}@${GEARBOX_MOUNT_HOST}:${GEARBOX_MOUNT_PATH}" "${GEARBOX_MOUNT_PATH}" -o uid="${GEARBOX_MOUNT_UID}" -o gid="${GEARBOX_MOUNT_GID}" -o allow_other -o port="${GEARBOX_MOUNT_PORT}" -o StrictHostKeyChecking=no -o password_stdin -f
#
#	if [ -d "${GEARBOX_MOUNT_PATH}" ]
#	then
#		sudo rmdir -p "${GEARBOX_MOUNT_PATH}"
#	fi
#)
