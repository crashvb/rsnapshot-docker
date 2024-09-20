# rsnapshot-docker

[![version)](https://img.shields.io/docker/v/crashvb/rsnapshot/latest)](https://hub.docker.com/repository/docker/crashvb/rsnapshot)
[![image size](https://img.shields.io/docker/image-size/crashvb/rsnapshot/latest)](https://hub.docker.com/repository/docker/crashvb/rsnapshot)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/rsnapshot-docker.svg)](https://github.com/crashvb/rsnapshot-docker/blob/master/LICENSE.md)

## Overview

This docker image contains [rsnapshot](https://rsnapshot.org/).

## Entrypoint Scripts

### rsnapshot

The embedded entrypoint script is located at `/etc/entrypoint.d/rsnapshot` and performs the following actions:

1. A new rsnapshot configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |
 | RSNAPSHOT\_CONF | | If defined, this value will be written to `<rsnapshot_conf>/rsnapshot.conf`. |
 | RSNAPSHOT\_CONFD\_* | | The contents of `<rsnapshot_conf>/conf.d/*.conf`. For example, `RSNAPSHOT_CONFD_FOO` will create `<rsnapshot_conf>/conf.d/foo.conf`. The contents of this directory will be used to generate `<rsnapshot_config>/rsnapshot-confd.conf` and will be included at the bottom of `<rsnapshot_conf>/rsnapshot.conf`. |

2. Volume permissions are normalized.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ cron.hourly/
│  │  └─ rsnapshot
│  ├─ cron.daily/
│  │  └─ rsnapshot
│  ├─ cron.weekly/
│  │  └─ rsnapshot
│  ├─ cron.monthly/
│  │  └─ rsnapshot
│  ├─ rsnapshot/
│  │  └─ conf.d/
│  └─ entrypoint.d/
│     └─ rsnapshot
├─ run/
│  └─ secrets/
│     ├─ id_rsa.rsnapshot
│     └─ id_rsa.rsnapshot.pub
└─ var/
   ├─ lib/
   │  └─ rsnapshot/
   └─ log/
      └─ rsnapshot*
```

### Exposed Ports

None.

### Volumes

* `/etc/rsnapshot` - rsnapshot configuration directory.
* `/var/lib/rsnapshot` - rsnapshot data directory.

## Development

[Source Control](https://github.com/crashvb/rsnapshot-docker)

