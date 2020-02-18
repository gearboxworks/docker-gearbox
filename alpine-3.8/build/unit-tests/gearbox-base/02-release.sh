#!/bin/bash
# Created on 2020-02-18T18:39:32+1100, using template:02-release.sh.tmpl and json:alpine-3.8.json

p_info "gearbox-base-alpine-3.8" "Release test started."

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

p_info "gearbox-base-alpine-3.8" "Release test finished."
