if [ -f "/etc/gearbox/bin/colors.sh" ]
then
	. /etc/gearbox/bin/colors.sh
fi

[ -z "$PS1" ] && return

shopt -s checkwinsize

if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]
then
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

if ! shopt -oq posix
then
	if [ -f /usr/share/bash-completion/bash_completion ]
	then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]
	then
		. /etc/bash_completion
	fi
fi

