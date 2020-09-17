
# Firebird SQL Server  ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/controlsoft/firebird?color=%231ed760) ![Docker Pulls](https://img.shields.io/docker/pulls/controlsoft/firebird)
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

## Volume:

#### `/databases`
Default location to put database files

## Environment Variables:

### `ISC_PASSWORD`
*Sysdba* user password, if left blank a random 10 character password will be set.
The password used will be placed in `/firebird/etc/SYSDBA.password`.

### `WIRECRYPT`

If this is set to true this will set `WireCrypt = enabled` to allow compatibility with Jaybird 3

## Default Ports

Firebird: 3050/TCP
Firebird Events: 3051/TCP
