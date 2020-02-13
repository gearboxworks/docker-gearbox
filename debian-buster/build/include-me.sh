#!/bin/sh

TERM=xterm-256color
export TERM

dummy_tput() {
	echo -n ""
}

TPUT="$(which tput)"
if [ -z "${TPUT}" ]
then
	# We have no tput. Just default to ignore.
	TPUT="dummy_tput"
fi



c_echo() {
	local _color=$1; shift

	echo -e "$(${TPUT} setaf $_color)$@$(${TPUT} sgr0)"
}

c_n_echo() {
	local _color=$1; shift
	echo -ne "$(${TPUT} setaf $_color)$@$(${TPUT} sgr0)"
}

# you can also define some variables
black=0; red=1; green=2; yellow=3; blue=4; pink=5; cyan=6; white=7;

echo_org() {
	c_n_echo $cyan "Gearbox["
	c_n_echo $white "$0"
	c_n_echo $cyan "]: "
}

c_err() {
	echo_org
	c_echo $red "$@"
}

c_warn() {
	echo_org
	c_echo $yellow "$@"
}

c_ok() {
	echo_org
	c_echo $green "$@"
}

checkExit()
{
	EXITCODE="$?"
	if [ "$EXITCODE" != "0" ]
	then
		c_err "Exited with $EXITCODE - \"$@\""
		exit $EXITCODE
	fi
}


# Usage
# c_echo $green "success!"
