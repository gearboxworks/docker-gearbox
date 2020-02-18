#!/bin/bash

if [ "${SHLVL}" == "1" ]
then
	c_cyan "# You have entered the ${GEARBOX_CONTAINER_NAME} Docker container."
	c_cyan "# All changes made here outside of /home/gearbox/projects will not be permanent."
	echo ""

	#if [ -f "/project/.NOTMOUNTED" ]
	#then
	#	echo "# WARNING: Currently the project base directory has NOT been mounted. - /project"
	#fi

	if [ -f "/home/gearbox/projects/default/.NOTMOUNTED" ]
	then
		c_warn "# WARNING: Currently the project base directory has NOT been mounted."
		c_warn "#  - /home/gearbox/projects/default"
		echo ""
	fi
fi
