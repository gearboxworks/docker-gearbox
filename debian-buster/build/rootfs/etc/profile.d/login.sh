#!/bin/bash

echo ""
echo "# You have entered the ${GEARBOX_CONTAINER_NAME} Docker container."
echo "# All changes made here outside of /project and /projects will not be permanent."
echo ""

if [ -f "/project/.NOTMOUNTED" ]
then
	echo "# WARNING: Currently the project base directory has NOT been mounted. - /project"
fi

if [ -f "/projects/.NOTMOUNTED" ]
then
	echo "# WARNING: Currently the global projects base directory has NOT been mounted. - /projects"
fi

echo ""
