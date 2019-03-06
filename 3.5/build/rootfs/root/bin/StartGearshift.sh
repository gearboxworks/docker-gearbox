#!/bin/bash

PATH="/opt/gearbox/sbin:/opt/gearbox/bin:/opt/gearbox/GearboxOS/bin:/opt/gearbox/GearboxOS/sbin:/root/go/bin:$PATH"

CMD="$(which GearboxGearshift)"

if [ -x "${CMD}" ]
then
	exec ${CMD} 
fi

# Avoid respawning too quickly.
sleep 5
