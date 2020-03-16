#!/bin/bash
# Created on 2020-02-18T18:39:32+1100, using template:02-release.sh.tmpl and json:debian-buster.json

p_info "gearbox-base-debian-buster" "Release test started."

if id -u gearbox
then
	c_ok "Gearbox user found."
else
	c_err "Gearbox user NOT found."
fi

if id -g gearbox
then
	c_ok "Gearbox group found."
else
	c_err "Gearbox group NOT found."
fi

p_info "gearbox-base-debian-buster" "Release test finished."
