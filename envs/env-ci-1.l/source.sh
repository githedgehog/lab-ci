#!/usr/bin/env bash

export HHFAB_TLS_SAN=env-ci-1.l.hhdev.io
export HHFAB_FABRIC_MODE=spine-leaf

export HHFAB_VLAB_GW_CPUS=16
export HHFAB_VLAB_GW_RAM=16384

export HHFAB_VLAB_SRV_CPUS=4
export HHFAB_VLAB_SRV_RAM=2048

export HHFAB_OOB_MGMT_IFACE=eno12399 # pci@0000:01:00.3, formerly control-1 mgmt passthrough
