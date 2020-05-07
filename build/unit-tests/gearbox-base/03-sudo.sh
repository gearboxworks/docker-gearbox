#!/bin/bash

c_info "Check SUDO"
sudo -v
if [ "$?" == "0" ]
then
	c_ok "SUDO OK"
else
	c_err "SUDO not OK"
fi
