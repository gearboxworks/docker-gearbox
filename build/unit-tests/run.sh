#!/bin/bash -l

FILES="$(find /etc/gearbox/unit-tests -mindepth 2 ! -type d | sort)"

EXIT="0"
for CMD in ${FILES}
do
	if [ "${CMD}" == "/etc/gearbox/unit-tests/run.sh" ]
	then
		continue
	fi

	bash -l ${CMD}

	RETURN="$?"
	echo "RETURN:${RETURN}"
	if [ "$RETURN" != "0" ]
	then
		EXIT="$RETURN"
	fi
done

exit ${EXIT}
