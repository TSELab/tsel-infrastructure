# Simple containerized kvm workload.

This is a demo of how to set up a vm inside of a docker container using qemu,
kvm, and an arch base image.

## To use

Before running "run", you need to create a volume for your machine (this helps with persistence).

```bash
docker volume create vmvolume0
```

This volume is where a qcow/raw vm image will be stored.

Now, you should be able to run everything by building and running the container.

```
docker build -t virtualized_worker .
. run
```

## Connecting the display

By default the graphic interface is not plugged in, though VNC is set up to
show you the container's display. You can figure out the port redirection through docker ps:

```
[santiago@meme-cluster kvmstuff]$ docker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED              STATUS              PORTS                                                                                      NAMES
02cd3982d862   virtualized_worker   "/bin/sh -c '/usr/bi…"   About a minute ago   Up About a minute   0.0.0.0:49156->5800/tcp, :::49156->5800/tcp, 0.0.0.0:49155->5900/tcp, :::49155->5900/tcp   inspiring_feynman
```

In this case, port 5900 of VNC is sent to 49155. This should let you use a VNC

## Setting up virtual TPM

You can set up a virtual TPM inside the VM with `swtpm`

### `Dockerfile`

Add the following line to install `swtpm` inside the container

```Dockerfile
RUN pacman -S --noconfirm swtpm
```

### `entrypoint.sh`

First create a virtual TPM by adding the following lines

```s
mkdir -p /vm/mytpm0
swtpm socket --daemon --tpm2 --tpmstate dir=/vm/mytpm0 --ctrl type=unixio,path=/vm/mytpm0/swtpm-sock --log level=20
```

Add following flags to `qemu-system-x86_64` command

```
-chardev socket,id=chrtpm,path=/vm/mytpm0/swtpm-sock \
-tpmdev emulator,id=tpm0,chardev=chrtpm \
-device tpm-tis,tpmdev=tpm0 \
```

Reference: https://en.opensuse.org/Software_TPM_Emulator_For_QEMU


## Setting up ssh server inside the VM

You can set up ssh server inside the VM

Once you are able to use VNC client to get inside the VM, install `openssh` package:

```s
pacman -Syu
pacman -S openssh
```

Once that is installed on the VM, let's go back to the local files.

Make sure you have setup port forwarding between a port on the container and the ssh 
port 22 of the VM by adding the following flags to `qemu-system-x86_64` command in `entrypoint.sh`

```
-device e1000,netdev=net0 \
-netdev user,id=net0,hostfwd=tcp::10022-:22
```

Reference: https://wiki.qemu.org/Documentation/Networking#How_to_get_SSH_access_to_a_guest

Make sure you publish the container's port that is used in the previous step by adding 
options to `docker run` command in `run`

```s
docker run ... -p 10022:10022 ...
```

In this case, since container's port `10022` is mapped to VM's port `22` and container's port 
`10022` is further mapped to host's port `10022`

Finally, try

```s
ssh usernameinvm@hostaddr -p 10022
```
