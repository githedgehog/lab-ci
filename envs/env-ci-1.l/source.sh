#!/usr/bin/env bash

export HHFAB_TLS_SAN=env-ci-1.l.hhdev.io
export HHFAB_FABRIC_MODE=spine-leaf

export HHFAB_VLAB_SRV_CPUS=4
export HHFAB_VLAB_SRV_RAM=2048

# pre-25.05
export HHFAB_CONTROL_NODE_MGMT_LINK="pci@0000:01:00.3"
export HHFAB_GATEWAY_NODE_MGMT_LINK="pci@0000:01:00.2"

# 25.06+
export HHFAB_NODE_MGMT_LINKS="control-1=pci@0000:01:00.3,gateway-1=pci@0000:01:00.2"

# 32a3343+
export HHFAB_OOB_MGMT_IFACE=eno4  # pci@0000:01:00.3, formerly control-1 mgmt passthrough
