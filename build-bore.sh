#!/bin/sh
USERID=$1

pacman -Syu --noconfirm base-devel sudo git
useradd builder -u ${USERID} -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#chown builder -R ..
#chown builder -R /tmp

curl -L https://archlinux.org/packages/extra-staging/x86_64/llvm/download/ -o llvm-x86_64.pkg.tar.zst
curl -L https://archlinux.org/packages/extra-staging/x86_64/llvm-libs/download/ -o llvm-libs-x86_64.pkg.tar.zst
curl -L https://archlinux.org/packages/extra-staging/x86_64/lld/download/ -o lld-x86_64.pkg.tar.zst
curl -L https://archlinux.org/packages/extra-staging/x86_64/compiler-rt/download/ -o compiler-rt-x86_64.pkg.tar.zst
curl -L https://archlinux.org/packages/extra-staging/x86_64/clang/download/ -o clang-x86_64.pkg.tar.zst

pacman --disable-sandbox --noconfirm -U *.pkg.tar.zst

su builder -c "gpg --recv 38DBBDC86092693E"
cd ./linux-xanmod-bore ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" env _compress_modules=y _use_numa=y _use_tracers=n _use_O3=y _compiler='clang' makepkg --noconfirm -sc"
