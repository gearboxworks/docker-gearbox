#!/bin/bash

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

PATH="/opt/gearbox/sbin:/opt/gearbox/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${GEARBOX_PROJECT_DIR}"
export PATH

PS1="[${GEARBOX_NAME}:${GEARBOX_VERSION}] \w\$ "
export PS1

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

