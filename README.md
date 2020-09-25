# Firebird SQL Server  [![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/controlsoft/firebird?color=%231ed760)](https://hub.docker.com/r/controlsoft/firebird) [![Docker Pulls](https://img.shields.io/docker/pulls/controlsoft/firebird)](https://hub.docker.com/r/controlsoft/firebird)
Dockerfile to build a Firebird SQL Server container image which can be linked to other containers.

## Supported Docker tags

[`3.0`, `3.0.4`, `latest` (*Dockerfile*)](https://github.com/ControlSoft-Labs/firebird-docker/blob/master/Dockerfile)

# Installation

```bash
docker pull controlsoft/firebird:3
```
# Quick Start

Run the Firebird image

```bash
docker run --name firebird -d controlsoft/firebird:3
```
## ...via docker-compose
```
version: "2"
services:
  firebird:
    restart: always
    image: controlsoft/firebird
    container_name: firebird
    ports:
      - 3050:3050
      - 3051:3051
    volumes:
      - C:\databases:/databases # Windows
      - /home/user/databases:/databases # Linux
    environment:
      - ISC_PASSWORD=masterkey
      - WIRECRYPT=true
```

## Volume:

#### `/databases`
Default location to put database files

## Environment Variables:

### `ISC_PASSWORD`
**Sysdba** user password, if blank a random 10 character password will be set.
The password used will be placed in `/opt/firebird/SYSDBA.password`.

### `WIRECRYPT`

If this is set to true this will set `WireCrypt = enabled` to allow compatibility with Jaybird 3 (DBeaver, etc)

## Default Ports

**Firebird:** 3050/TCP

**Firebird Events:** 3051/TCP
