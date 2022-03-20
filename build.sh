#!/bin/bash


samba_version=$(git tag)
if [ "X$samba_version" == "X" ]; then
  samba_version=4
fi
version=$(git rev-parse --short HEAD)
build_date=$(date -Iseconds)
tagdate=$(date +%Y_%m_%d__%H%M)
gituser=kiwi

docker build \
        --build-arg "version=$version" \
        --build-arg "build_date=$build_date" \
        -t $gituser/docker-samba-ad-dc:${samba_version} .
docker tag $gituser/docker-samba-ad-dc:${samba_version} $gituser/docker-samba-ad-ac:latest
