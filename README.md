# hm-gwmfr

**Please note: this repo has been deprecated and replaced by the [gateway-mfr-rs](https://github.com/helium/gateway-mfr-rs) helper functions built into the [hm-pyhelper package](https://github.com/NebraLtd/hm-pyhelper). These functions for programming the ECC chip are not called directly but are used in the [diagnostics container hm-diag](https://github.com/NebraLtd/hm-diag) to both program and read back from the security chip.**

This container provisions the ECC security key on the Nebra Helium Miners during manufacturing.

Environment variable `OVERRIDE_GWMFR_EXIT` keeps the container alive and stops it from exiting, for debugging purposes.

## Pre built containers

This repo automatically builds docker containers and uploads them to two repositories for easy access:
- [hm-gwmfr on DockerHub](https://hub.docker.com/r/nebraltd/hm-gwmfr)
- [hm-gwmfr on GitHub Packages](https://github.com/NebraLtd/hm-gwmfr/pkgs/container/hm-gwmfr)

The images are tagged using the docker long and short commit SHAs for that release. The current version deployed to miners can be found in the [helium-miner-software repo](https://github.com/NebraLtd/helium-miner-software/blob/production/docker-compose.yml).
