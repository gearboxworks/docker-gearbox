#!/bin/bash

GEARBOX_SHELL_DIR="/home/gearbox/projects/default"

if [ "${USER}" == "gearbox" ]
then
if [ ! -z "${GEARBOX_MOUNT_PATH}" ]
then
	if [ -d "${GEARBOX_MOUNT_PATH}" ]
	then
		GEARBOX_SHELL_DIR="${GEARBOX_MOUNT_PATH}"
	fi
else
	if [ ! -z "${GEARBOX_PROJECT_DIR}" ]
	then
		if [ -d "${GEARBOX_PROJECT_DIR}" ]
		then
			GEARBOX_SHELL_DIR="${GEARBOX_PROJECT_DIR}"
		fi
	else
		GEARBOX_PROJECT_DIR="${GEARBOX_SHELL_DIR}"
	fi
fi
cd "${GEARBOX_SHELL_DIR}"
fi

PATH="/opt/gearbox/sbin:/opt/gearbox/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${GEARBOX_SHELL_DIR}"
export PATH

PS1="[${GEARBOX_NAME}:${GEARBOX_VERSION}] \w \$ "
export PS1

HISTFILE="${HOME}/.bash_history"
export HISTFILE

if [ "${SHLVL}" == "1" ]
then
	c_cyan "# You have entered the ${GEARBOX_CONTAINER_NAME} Docker container."

	if [ -f "${GEARBOX_PROJECT_DIR}/.NOTMOUNTED" ]
	then
		c_warn "# WARNING: Currently the project base directory has NOT been mounted."
		c_warn "#  - ${GEARBOX_PROJECT_DIR}"
		echo ""
	else
		c_cyan "# All changes made outside of /home/gearbox/projects may not be permanent."
		echo ""
	fi
fi

