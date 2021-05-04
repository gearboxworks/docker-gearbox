
test -f /etc/gearbox/build/base.env && . /etc/gearbox/build/base.env
test -f /etc/gearbox/bin/colors.sh && . /etc/gearbox/bin/colors.sh

case "${GEARBOX_BASE_VERSION}" in
	"alpine-3.3"|"alpine-3.4"|"alpine-3.5")
		# APKS="tini bash openrc nfs-utils sshfs openssh-client openssh git rsync sudo ncurses-terminfo-base ncurses-terminfo ncurses"
		APKS="s6 s6-rc s6-portable-utils s6-linux-utils bash nfs-utils sshfs openssh-client openssh git rsync sudo ncurses-terminfo-base ncurses-terminfo ncurses"
		;;

	"alpine-3.6"|"alpine-3.7"|"alpine-3.8"|"alpine-3.9"|"alpine-3.10"|"alpine-3.11"|"alpine-3.12"|"alpine-3.13")
		# APKS="tini bash openrc nfs-utils sshfs openssh-client openssh-server openssh git shadow rsync sudo ncurses-terminfo-base ncurses-terminfo ncurses"
		APKS="s6 s6-rc s6-portable-utils s6-linux-utils bash nfs-utils sshfs openssh-client openssh-server openssh git shadow rsync sudo ncurses-terminfo-base ncurses-terminfo ncurses"
		;;

	*)
		# APKS="tini bash openrc nfs-utils ssh-tools sshfs openssh-client openssh-server openssh git shadow rsync sudo ncurses-terminfo-base ncurses-terminfo ncurses"
		APKS="s6 s6-rc s6-portable-utils s6-linux-utils bash nfs-utils ssh-tools sshfs openssh-client openssh-server openssh git shadow rsync sudo ncurses-terminfo-base ncurses-terminfo ncurses"
		;;
esac

c_info "Update packages."
apk update; checkExit
apk add --no-cache ${APKS}; checkExit

rm -rf /etc/gearbox/rootfs/root/tmp; checkExit

