#!/bin/bash

if [ -f /etc/profile.d/00-gearbox.sh ]
then
	. /etc/profile.d/00-gearbox.sh
fi

if [ ! -z "${GEARBOX_PROJECT_DIR}" ]
then
	GEARBOX_PROJECT_DIR="/home/gearbox/projects/default"
fi

if [ "${USER}" == "gearbox" ]
then
	if [ -d "${GEARBOX_PROJECT_DIR}" ]
	then
		cd "${GEARBOX_PROJECT_DIR}"
	else
		cd /home/gearbox/projects/default
	fi
fi

if [ -z "${SSH_ORIGINAL_COMMAND}" ]
then
	SSH_ORIGINAL_COMMAND="${SHELL} --login -i"
fi

SHLVL=1

exec ${SSH_ORIGINAL_COMMAND}
