#!/bin/bash

test -f /etc/gearbox/bin/colors.sh && . /etc/gearbox/bin/colors.sh

c_ok "Started."

c_ok "Update packages."
if [ -f /etc/gearbox/bin/version-base.sh ]
then
	. /etc/gearbox/bin/version-base.sh
else
	echo "GEARBOX_BASE_VERSION=${GEARBOX_CONTAINER_VERSION}; export GEARBOX_BASE_VERSION" > /etc/gearbox/bin/version-base.sh
fi

case "${GEARBOX_BASE_VERSION}" in
	"alpine-"*)
		case "${GEARBOX_BASE_VERSION}" in
			"alpine-3.3"|"alpine-3.4"|"alpine-3.5")
				# APKS="tini bash openrc nfs-utils sshfs openssh-client openssh git rsync sudo ncurses"
				APKS="s6 s6-rc s6-portable-utils s6-linux-utils bash nfs-utils sshfs openssh-client openssh git rsync sudo ncurses"
				;;

			"alpine-3.6"|"alpine-3.7"|"alpine-3.8"|"alpine-3.9"|"alpine-3.10"|"alpine-3.11")
				# APKS="tini bash openrc nfs-utils sshfs openssh-client openssh-server openssh git shadow rsync sudo ncurses"
				APKS="s6 s6-rc s6-portable-utils s6-linux-utils bash nfs-utils sshfs openssh-client openssh-server openssh git shadow rsync sudo ncurses"
				;;

			*)
				# APKS="tini bash openrc nfs-utils ssh-tools sshfs openssh-client openssh-server openssh git shadow rsync sudo ncurses"
				APKS="s6 s6-rc s6-portable-utils s6-linux-utils bash nfs-utils ssh-tools sshfs openssh-client openssh-server openssh git shadow rsync sudo ncurses"
				;;
		esac

		apk update; checkExit
		apk add --no-cache ${APKS}; checkExit
		;;

	"debian-"*)
		DEBS="bash git rsync sudo wget s6 nfs-common ssh fuse libnfs-utils sshfs ssh-tools"
		apt-get update; checkExit
		apt-get install -y --no-install-recommends ${DEBS}; checkExit
		find /var/lib/apt/lists -type f -delete; checkExit
		;;

	*)
		c_err "Unknown base O/S."
		exit 1
		;;
esac


GROUP="$(grep ^gearbox /etc/group)"
if [ -z "${GROUP}" ]
then
	c_ok "Adding gearbox group."
	GROUPADD="$(which groupadd)"
	if [ -z "${GROUPADD}" ]
	then
		echo 'gearbox:x:1000:' >> /etc/group
	else
		groupadd -g 1000 gearbox; checkExit
	fi
fi


if [ ! -d /var/mail ]
then
	c_ok "Creating /var/mail."
	mkdir /var/mail
fi


PASSWD=$(grep ^gearbox /etc/passwd)
if [ -z "${PASSWD}" ]
then
	c_ok "Adding gearbox user."
	GROUPADD="$(which useradd)"
	if [ -z "${GROUPADD}" ]
	then
		echo 'gearbox:x:1000:1000:Gearbox user:/home/gearbox:/bin/bash' >> /etc/passwd
		echo 'gearbox:$6$XdlAWysgxyUyxjAV$ivrS09OkFINgCUdHjUQYG68FqW/Dkyia1iB1AN2RpgqdmgGP4DtYOAj47C5xCX8pD5iOub0q6M66zBn2bX27m1:17927:0:99999:7:::' >> /etc/shadow
	else
		useradd -d /home/gearbox -c "Gearbox user" -u 1000 -g 1000 -N -s /bin/bash -p '$6$XdlAWysgxyUyxjAV$ivrS09OkFINgCUdHjUQYG68FqW/Dkyia1iB1AN2RpgqdmgGP4DtYOAj47C5xCX8pD5iOub0q6M66zBn2bX27m1' gearbox; checkExit
	fi
fi


if [ -d "/etc/gearbox/rootfs/" ]
then
	c_ok "Copying /etc/gearbox/rootfs/ to /."
	chown -fhR root:root /etc/gearbox/rootfs; checkExit
	chown -fhR gearbox:gearbox /etc/gearbox/rootfs/home/gearbox; checkExit
	rsync -HvaxP /etc/gearbox/rootfs/ /; checkExit
else
	c_err "Error: /tmp/rootfs does not exist."
	exit 1
fi


/usr/bin/ssh-keygen -A
addgroup fuse
addgroup gearbox fuse


#c_ok "Installing MailHog client."
#export GOPATH=/etc/gearbox/gocode
#if [ ! -d "${GOPATH}" ]
#then
#	mkdir -p ${GOPATH}; checkExit
#fi
#go get github.com/mailhog/mhsendmail; checkExit
#find ${GOPATH} | xargs ls -ld
#du -sh ${GOPATH}
#mv ${GOPATH}/bin/MailHog /usr/local/bin; checkExit
#rm -rf ${GOPATH}


c_ok "Cleaning up."
find /usr/local/*bin -type f | xargs chmod 775


c_ok "Finished."
exit 0
