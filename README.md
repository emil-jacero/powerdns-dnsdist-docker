[![GitHub license](https://img.shields.io/github/license/emil-jacero/powerdns-dnsdist-docker)](https://github.com/emil-jacero/powerdns-dnsdist-docker/blob/master/LICENSE) [![GitHub stars](https://img.shields.io/github/stars/emil-jacero/powerdns-dnsdist-docker)](https://github.com/emil-jacero/powerdns-dnsdist-docker/stargazers) [![GitHub issues](https://img.shields.io/github/issues/emil-jacero/powerdns-dnsdist-docker)](https://github.com/emil-jacero/powerdns-dnsdist-docker/issues)

# powerdns-dnsdist-docker

This is simple PowerDNS dnsdist loadbalancer built to accompany PowerDNS authorative DNS & PowerDNS recursor DNS

## Related projects

- [powerdns-auth-docker](https://github.com/emil-jacero/powerdns-auth-docker)
- [powerdns-recursor-docker](https://github.com/emil-jacero/powerdns-recursor-docker)

## Supported Architectures

The images are built and tested on multiple platforms.

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armv7l | armhf-latest |

## Version Tags

This image provides various versions that are available via tags. `latest` tag provides the latest stable version.

| Tag | Description |
| :----: | --- |
| amd64-latest | Latest stable version |
| amd64-1.5.x | Latest micro release of 1.5 |
| arm64v8-latest | Latest stable version |
| arm64v8-1.5.x | Latest micro release of 1.5 |
| armhf-latest | Latest stable version |
| armhf-1.5.x | Latest micro release of 1.5 |

## Environment variables

| Name | Value | Default |
| :----: | --- | --- |
| `TZ` | Timezone | Europe/Stockholm |
| `LOG_LEVEL` | Prefered log level | INFO |
| `ENV_BIND_ADDRESS` | IP address to bind the instance to | N/A|
| `ENV_INTERNAL_RESOVERS` | List of addresses to `internal` dns servers. (separated by `;`) | N/A |
| `ENV_PUBLIC_RESOVERS` | List of addresses to `public` dns servers. (separated by `;`) | N/A |
| `ENV_INTERNAL_SUBNETS` | List of subnets to listen for to send to `public`. (separated by `;`) | N/A |
| `ENV_CUSTOM_OPTS` | List of any custom options for dnsdist. (separated by `;`) | N/A |

## Usage

### Example

```
    version: '3'
    services:
      pdns-dnsdist:
        container_name: pdns-dnsdist
        image: emiljacero/powerdns-dnsdist-docker:amd64-1.5.x
        restart: unless-stopped
        network_mode: host
        environment:
          TZ: Europe/Stockholm
          LOG_LEVEL: DEBUG
          ENV_BIND_ADDRESS: 10.10.10.5
          ENV_INTERNAL_RESOVERS: "10.10.0.10;10.10.0.20"
          ENV_PUBLIC_RESOVERS: "1.1.1.1"
          ENV_INTERNAL_SUBNETS: "192.168.0.0/24"
          ENV_CUSTOM_OPTS: 'webserver("0.0.0.0:8083", "supersecretpassword", "supersecretAPIkey", {}, "0.0.0.0/0")'
```
