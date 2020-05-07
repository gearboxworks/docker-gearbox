#!/bin/bash

test -f /etc/gearbox/build/base.env && . /etc/gearbox/build/base.env
test -f /etc/gearbox/bin/colors.sh && . /etc/gearbox/bin/colors.sh

c_ok "Started."

if [ "${GEARBOX_BASE_REF}" != "base" ]
then
	if [ "${GEARBOX_BASE}" != "" ]
	then
		GEARBOX_BASE_VERSION="$(echo "${GEARBOX_BASE}" | awk -F: '{print$2}')"
		export GEARBOX_BASE_VERSION
	fi
fi

c_ok "Install base O/S packages."

case "${GEARBOX_BASE_VERSION}" in
	"alpine-"*)
		c_ok "Alpine O/S detected - ${GEARBOX_BASE_VERSION}"
		/etc/gearbox/build/base-alpine.sh; checkExit
		;;

	"debian-"*)
		c_ok "Debian O/S detected - ${GEARBOX_BASE_VERSION}"
		/etc/gearbox/build/base-debian.sh; checkExit
		;;

	"ubuntu-"*)
		c_ok "Ubuntu O/S detected - ${GEARBOX_BASE_VERSION}"
		/etc/gearbox/build/base-ubuntu.sh; checkExit
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
		echo "gearbox:x:${GEARBOX_GID}:" >> /etc/group
	else
		groupadd -g ${GEARBOX_GID} gearbox; checkExit
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
		echo "gearbox:x:${GEARBOX_UID}:${GEARBOX_GID}:Gearbox user:/home/gearbox:/bin/bash" >> /etc/passwd
		echo 'gearbox:$6$XdlAWysgxyUyxjAV$ivrS09OkFINgCUdHjUQYG68FqW/Dkyia1iB1AN2RpgqdmgGP4DtYOAj47C5xCX8pD5iOub0q6M66zBn2bX27m1:17927:0:99999:7:::' >> /etc/shadow
	else
		useradd -d /home/gearbox -c "Gearbox user" -u ${GEARBOX_UID} -g ${GEARBOX_GID} -N -s /bin/bash -p '$6$XdlAWysgxyUyxjAV$ivrS09OkFINgCUdHjUQYG68FqW/Dkyia1iB1AN2RpgqdmgGP4DtYOAj47C5xCX8pD5iOub0q6M66zBn2bX27m1' gearbox; checkExit
	fi
fi


if [ -d "/etc/gearbox/rootfs/" ]
then
	c_ok "Copying /etc/gearbox/rootfs/ to /."
	chown -fhR root:root /etc/gearbox/rootfs; checkExit
	chown -fhR gearbox:gearbox /etc/gearbox/rootfs/home/gearbox; checkExit
	rsync -HvaxP /etc/gearbox/rootfs/ /; checkExit
else
	c_err "Error: /etc/gearbox/rootfs does not exist."
	exit 1
fi
chmod 440 /etc/sudoers.d/gearbox


c_info "Generate SSH host keys."
if [ ! -d /run/sshd ]
then
	mkdir -p /run/sshd
fi

if [ ! -d /var/run/sshd ]
then
	mkdir -p /var/run/sshd
fi
/usr/bin/ssh-keygen -A
addgroup fuse 2>/dev/null
addgroup gearbox fuse 2>/dev/null


c_ok "Cleaning up."
find /usr/local/*bin -type f | xargs chmod 775
rm -rf /root/tmp

c_ok "Creating env."
/etc/gearbox/bin/pullenv.sh
cp /etc/environment /etc/gearbox/build/base.env

c_ok "Finished."
exit 0
