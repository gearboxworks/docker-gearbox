
test -f /etc/gearbox/build/base.env && . /etc/gearbox/build/base.env
test -f /etc/gearbox/bin/colors.sh && . /etc/gearbox/bin/colors.sh

c_info "Update packages."
DEBS="bash git rsync sudo wget nfs-common ssh fuse sshfs"
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
apt-get update; checkExit
apt-get install -y --no-install-recommends ${DEBS}; checkExit

apt-get install -y apt-utils locales; checkExit

c_info "Install S6."
cd /
# apt-get install -y curl tzdata; checkExit
# locale-gen en_US.UTF-8; checkExit
# curl -SLO "https://github.com/just-containers/s6-overlay/releases/download/v1.20.0.0/s6-overlay-${ARCH}.tar.gz"; checkExit
wget -nv --no-check-certificate "https://github.com/just-containers/s6-overlay/releases/download/v1.20.0.0/s6-overlay-amd64.tar.gz"; checkExit
tar -xzf /s6-overlay-amd64.tar.gz -C /; checkExit
tar -xzf /s6-overlay-amd64.tar.gz -C /usr ./bin; checkExit
rm -rf /s6-overlay-amd64.tar.gz /etc/gearbox/rootfs/root/tmp; checkExit

find /var/lib/apt/lists -type f -delete; checkExit

