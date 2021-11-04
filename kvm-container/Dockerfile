FROM archlinux:latest

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm qemu
RUN pacman -S --noconfirm swtpm

ADD entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT '/usr/bin/entrypoint.sh'
