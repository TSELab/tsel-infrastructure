FROM archlinux:latest

RUN pacman -Syu --noconfirm qemu libguestfs jq linux-lts socat

ADD entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT '/usr/bin/entrypoint.sh'