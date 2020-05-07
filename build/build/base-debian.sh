
test -f /etc/gearbox/build/base.env && . /etc/gearbox/build/base.env
test -f /etc/gearbox/bin/colors.sh && . /etc/gearbox/bin/colors.sh

case "${GEARBOX_BASE_VERSION}" in
	"debian-squeeze")
		c_info "Update packages."
		DEBS="bash rsync sudo wget nfs-common ssh"
		echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

		SOURCES="$(find /etc/apt/sources.list.d /etc/apt/sources.list -type f)"
		echo "SOURCES: ${SOURCES}"
		for i in ${SOURCES}
		do
			echo "# Debian apt source: $i"
			cat $i
		done

		sed -i '
			s/^deb http:\/\/httpredir.debian.org\/debian squeeze-updates/# deb http:\/\/httpredir.debian.org\/debian squeeze-updates/;
			s/^deb http:\/\/httpredir.debian.org\/debian/deb http:\/\/archive.debian.org\/debian/;
			s/^deb http:\/\/security.debian.org squeeze/# deb http:\/\/security.debian.org squeeze/;

			s/^deb http:\/\/http.debian.net\/debian squeeze-updates/# deb http:\/\/http.debian.net\/debian squeeze-updates/;
			s/^deb http:\/\/http.debian.net\/debian squeeze/deb http:\/\/archive.debian.org\/debian squeeze/;
			s/^deb http:\/\/security.debian.org squeeze/# deb http:\/\/security.debian.org squeeze/;

			s/^deb http:\/\/deb.debian.org\/debian squeeze-updates/# deb http:\/\/deb.debian.org\/debian squeeze-updates/;
			s/^deb http:\/\/deb.debian.org\/debian squeeze/deb http:\/\/archive.debian.org\/debian squeeze/;
			s/^deb http:\/\/security.debian.org\/debian-security/# deb http:\/\/security.debian.org\/debian-security/;
			s/^deb http:\/\/security.debian.org squeeze/# deb http:\/\/security.debian.org squeeze/;
			' ${SOURCES}

		echo "SOURCES: ${SOURCES}"
		for i in ${SOURCES}
		do
			echo "# Debian apt source: $i"
			cat $i
		done

		# apt-key list
		# UK="$(apt-key list 2>&1 | awk '/expired/{print$2}' | awk -F/ '{print$2}')"
		# for i in ${UK}
		# do
		# 	echo "apt-key adv --recv-keys --keyserver keys.gnupg.net $i"
		# 	apt-key adv --recv-keys --keyserver keys.gnupg.net $i
		# done

		if [ ! -d /etc/apt/apt.conf.d/ ]
		then
			mkdir -p /etc/apt/apt.conf.d/
		fi
		echo 'APT::Get::AllowUnauthenticated "true";' > /etc/apt/apt.conf.d/IgnoreExpiredKeys
		echo 'Acquire::AllowInsecureRepositories "true";' >> /etc/apt/apt.conf.d/IgnoreExpiredKeys

		apt-get -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true update; checkExit
		apt-get install -y -o APT::Get::AllowUnauthenticated=true --no-install-recommends ${DEBS}; checkExit

		apt-get install -y -o APT::Get::AllowUnauthenticated=true apt-utils locales; checkExit

		cd /
		tar -xzf /etc/gearbox/rootfs/root/tmp/s6-overlay-amd64.tar.gz -C /; checkExit
		tar -xzf /etc/gearbox/rootfs/root/tmp/s6-overlay-amd64.tar.gz -C /usr ./bin; checkExit
		;;

	"debian-wheezy")
		c_info "Update packages."
		DEBS="bash rsync sudo wget nfs-common ssh fuse sshfs"
		echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

		SOURCES="$(find /etc/apt/sources.list.d /etc/apt/sources.list -type f)"
		sed -i '
			s/^deb http:\/\/http.debian.net\/debian wheezy-updates/# deb http:\/\/http.debian.net\/debian wheezy-updates/;
			s/^deb http:\/\/http.debian.net\/debian wheezy/deb http:\/\/archive.debian.org\/debian wheezy/;
			s/^deb http:\/\/security.debian.org wheezy/# deb http:\/\/security.debian.org wheezy/;

			s/^deb http:\/\/deb.debian.org\/debian wheezy-updates/# deb http:\/\/deb.debian.org\/debian wheezy-updates/;
			s/^deb http:\/\/deb.debian.org\/debian wheezy/deb http:\/\/archive.debian.org\/debian wheezy/;
			s/^deb http:\/\/security.debian.org\/debian-security/# deb http:\/\/security.debian.org\/debian-security/;
			s/^deb http:\/\/security.debian.org wheezy/# deb http:\/\/security.debian.org wheezy/;
			' ${SOURCES}

		echo "SOURCES: ${SOURCES}"
		for i in ${SOURCES}
		do
			echo "# Debian apt source: $i"
			cat $i
		done

		#UK="$(apt-key list 2>&1 | awk '/expired/{print$2}' | awk -F/ '{print$2}')"
		#for i in ${UK}
		#do
		#	echo "apt-key adv --recv-keys --keyserver keys.gnupg.net $i"
		#	apt-key adv --recv-keys --keyserver keys.gnupg.net $i
		#done

		apt-get update; checkExit
		apt-get install -y --no-install-recommends ${DEBS}; checkExit

		apt-get install -y apt-utils locales; checkExit
		cd /
		wget -nv --no-check-certificate "https://github.com/just-containers/s6-overlay/releases/download/v1.20.0.0/s6-overlay-amd64.tar.gz"; checkExit
		tar -xzf /s6-overlay-amd64.tar.gz -C /; checkExit
		tar -xzf /s6-overlay-amd64.tar.gz -C /usr ./bin; checkExit
		rm -rf /s6-overlay-amd64.tar.gz /etc/gearbox/rootfs/root/tmp; checkExit
		;;

	"debian-stretch"|"debian-jessie")
		c_info "Update packages."
		DEBS="bash git rsync sudo wget nfs-common ssh fuse sshfs"
		echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
		apt-get update; checkExit
		apt-get install -y --no-install-recommends ${DEBS}; checkExit

		apt-get install -y apt-utils locales; checkExit
		cd /
		wget -nv --no-check-certificate "https://github.com/just-containers/s6-overlay/releases/download/v1.20.0.0/s6-overlay-amd64.tar.gz"; checkExit
		tar -xzf /s6-overlay-amd64.tar.gz -C /; checkExit
		tar -xzf /s6-overlay-amd64.tar.gz -C /usr ./bin; checkExit
		rm -rf /s6-overlay-amd64.tar.gz /etc/gearbox/rootfs/root/tmp; checkExit
		;;

	"debian-"*)
		c_info "Update packages."
		DEBS="bash git rsync sudo wget s6 nfs-common ssh fuse libnfs-utils sshfs ssh-tools"
		apt-get update; checkExit
		apt-get install -y --no-install-recommends ${DEBS}; checkExit

		# Different path for S6 on later versions of Debian.
		ls -1 /usr/bin/s6* | xargs -i ln -s {} /bin 2>/dev/null
		rm -rf /etc/gearbox/rootfs/root/tmp; checkExit
		;;
esac

find /var/lib/apt/lists -type f -delete; checkExit

