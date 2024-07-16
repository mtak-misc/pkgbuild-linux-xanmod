#!/bin/sh
USERID=$1

pacman -Syu --noconfirm base-devel sudo git
useradd builder -u ${USERID} -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#chown builder -R ..
#chown builder -R /tmp
su builder -c "gpg --recv 38DBBDC86092693E"
cd ./linux-xanmod-bore ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" env _compress_modules=y _use_numa=y _use_tracers=n makepkg --noconfirm -sc"
