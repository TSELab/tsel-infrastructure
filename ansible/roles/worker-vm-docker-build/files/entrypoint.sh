#!/bin/sh
set -e
RAM_SIZE=2G
IMAGE_PATH=/vm/worker.img
IMAGE_SRC="https://workervm.seal.purdue.wtf/worker.img"

# Start downloading worker VM image if it doesn't exist
if [ ! -f "$IMAGE_PATH" ]
then
    echo "No image found, downloading latest worker image"
    curl "$IMAGE_SRC" -o "$IMAGE_PATH"
fi

# Create hosts file with the container's IP resolved as "self"
cp /etc/hosts hosts
echo -e "$(ip -j a | jq -r .[1].addr_info[0].local)\tself" >> hosts

# Copy in the hosts file into the VM image
virt-copy-in -a $IMAGE_PATH hosts /etc

# Copy in the rebuilderd worker config into the VM image
virt-copy-in -a $IMAGE_PATH rebuilderd-worker.conf /etc

# Start up a worker VM in the background (nohup ...command... &)
nohup qemu-system-x86_64 -m $RAM_SIZE \
    -smp 8 \
    -enable-kvm \
    -k en-us \
    -vnc :0 \
    -hda $IMAGE_PATH \
    -nographic \
    -netdev user,id=net0 \
    -device e1000,netdev=net0 \
    &

# Start a socat instance that relays data between the VM and the rebuilderd daemon
socat -s -d -d TCP-LISTEN:8484,fork,reuseaddr TCP:rebuilderd:8484
