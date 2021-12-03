FROM archlinux:latest

RUN pacman -Syu --noconfirm qemu libguestfs jq linux-lts socat
ADD entrypoint.sh /usr/bin/entrypoint.sh
ADD rebuilderd-worker.conf /rebuilderd-worker.conf

ENTRYPOINT '/usr/bin/entrypoint.sh'
