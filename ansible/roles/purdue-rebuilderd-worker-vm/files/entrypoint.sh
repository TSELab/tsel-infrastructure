!/bin/sh
set -e
RAM_SIZE=2G
IMAGE_PATH=/vm/worker.img
IMAGE_SRC="https://mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-basic-20211115.39179.qcow2"

if [ ! -f "$IMAGE_PATH" ]
then
    echo "No image found, downloading latest worker image"
    curl "$IMAGE_SRC" -o "$IMAGE_PATH"
fi

cp /etc/hosts hosts
echo -e "$(ip -j a | jq -r .[1].addr_info[0].local)\tself" >> hosts

virt-copy-in -a $IMAGE_PATH hosts /etc

qemu-system-x86_64 -m $RAM_SIZE \
    -smp 8 \
    -enable-kvm \
    -k en-us \
    -vnc :0 \
    -hda $IMAGE_PATH \
    -nographic \
    -netdev user,id=net0 \
    -device e1000,netdev=net0 &

socat -s -d -d TCP-LISTEN:8484,fork,reuseaddr TCP:rebuilderd:8484