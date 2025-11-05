#!/usr/bin/env bash

export HHFAB_TLS_SAN=env-ci-1.l.hhdev.io
export HHFAB_CONTROL_NODE_MGMT_LINK="pci@0000:01:00.3"
export HHFAB_GATEWAY_NODE_MGMT_LINK="pci@0000:01:00.2"
export HHFAB_FABRIC_MODE=spine-leaf
export HHFAB_GATEWAY=true
