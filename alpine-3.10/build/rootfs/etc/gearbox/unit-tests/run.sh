#!/bin/bash

FILES="$(find /etc/gearbox/unit-tests -mindepth 2 ! -type d | sort)"

for CMD in ${FILES}
do
	if [ "${CMD}" == "/etc/gearbox/unit-tests/run.sh" ]
	then
		continue
	fi

	bash ${CMD}
done

