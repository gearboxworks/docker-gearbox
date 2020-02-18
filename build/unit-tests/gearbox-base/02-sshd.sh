#!/bin/bash

c_info "Check SSHD"
if grep /usr/sbin/sshd /proc/[0-9]*/cmdline
then
	c_ok "SSHD running"
else
	c_err "SSHD not running"
fi
