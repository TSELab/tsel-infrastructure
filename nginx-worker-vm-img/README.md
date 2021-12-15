# Nginx Container Hosting Worker VM ISO Image
This directory contains files to run an Nginx container that hosts VM ISO image file.
This Nginx container is proxied by [Nginx proxy](https://github.com/nginx-proxy/nginx-proxy) along with [acme-companion](https://github.com/nginx-proxy/acme-companion) containers to assign reachable HTTP URL.

# Steps

## Copy the ISO Image File
Make sure the ISO image file is located under this directory

## Docker Build
```s
docker build -t nginx-vm-img .
```

## Run
```
. run
```
