#!/bin/sh
set -e
RAM_SIZE=2G
IMAGE_PATH=/vm/worker.img
IMAGE_SRC="https://mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-basic-20211101.38317.qcow2"

mkdir -p /vm/mytpm0
swtpm socket --daemon --tpm2 --tpmstate dir=/vm/mytpm0 --ctrl type=unixio,path=/vm/mytpm0/swtpm-sock --log level=20

if [ ! -f "$IMAGE_PATH" ]
then
    echo "No image found, downloading latest worker image"
    curl "$IMAGE_SRC" -o "$IMAGE_PATH"
fi

qemu-system-x86_64 \
    -m $RAM_SIZE \
    -smp 8 \
    -enable-kvm \
    -k en-us \
    -vnc :0 \
    -hda $IMAGE_PATH \
    -nographic \
    -chardev socket,id=chrtpm,path=/vm/mytpm0/swtpm-sock \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-tis,tpmdev=tpm0 \
    -device e1000,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::10022-:22
