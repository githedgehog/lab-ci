# env-ci-1 with two fabrics

Wiring for a CI job that installs two Fabrics on env-ci-1. Offline validated only (`hhfab validate` with the `ema/multi-fabric-5` build), never deployed.

## Files

| File | Content |
|---|---|
| `wiring-fabrics.yaml` | `Fabric/fabric-a` (leaf ASNs 4200000000-4200000080, spine 4200000090, gateway 4200000091) and `Fabric/fabric-b` (leaf ASNs 64600-64680, spine 64690, gateway 64691) |
| `wiring-multifabric.yaml` | `wiring.yaml` and `wiring-gateway.yaml` split into the two fabrics (generated, 54 objects) |
| `wiring-interconnect.yaml` | optional: an External on each side of one cable between the fabrics. The cable does not exist today. |

Use `wiring-fabrics.yaml` + `wiring-multifabric.yaml` for the base case, add `wiring-interconnect.yaml` once the cable is in.

## Topology

```
                        lab network / internet
                                  |
                       ds2000-02 (external router, not managed by Fabric)
                          |                         |
              (cables, unused: ds3000-01/02)        | VLANs 100, 200, 210
                          |                         |
  fabric-a  (4-byte ASNs, namespace ipns-a)         |      fabric-b  (namespace default)
                                                    |
  gateway-1                                         |      gateway-2
      |                                             |          |
  ds4000-01 (spine)                                 |      ds4000-02 (spine)
    |       |                                       |        |        |
  ds3000-01 ds3000-02 ==== interconnect (cable) ==== ds3000-03 ---- sse-c4632-01
  \__eslag-2__/            ds3000-02/E1/26            \____ eslag-1, border ____/
    |      |   |           ds3000-03/E1/26             |   |      |        |
  srv-1  srv-2 srv-3                                  srv-5 srv-6 srv-7,8  srv-9
 (eslag)(eslag)(bundled)                              (eslag)(eslag)(unbundled on ds3000-03)  (unbundled on sse)
```

Externals `default`, `other` (BGP, ASN 64102, VLANs 100 and 200) and `static-ext` (VLAN 210) are in fabric-b, attached to `ds3000-03` and `sse-c4632-01`. Spine-leaf cables that would cross fabrics (`ds4000-01` to `ds3000-03` and `sse-c4632-01`, `ds4000-02` to `ds3000-01` and `ds3000-02`) are not declared and stay unused.

## What it covers

- Two fabrics with disjoint leaf ASN ranges, each with its own IPv4 namespace and gateway.
- One fabric on a 4-byte leaf range (fabric-a).
- With the interconnect: an External on each side of one link, and internet access for fabric-a through fabric-b with `setup-peerings ext.default+ext.fabric-a:gw` (both Externals carry the `hhfab.githedgehog.com/interconnect` annotation). The interconnect Externals use `localASN` (64910/64911), so neither side depends on the other fabric's leaf ASNs.
- The CI default flow (`setup-vpcs`, `setup-peerings`, `test-connectivity`): VPCs 1 to 3 are the fabric-a servers, so the hard-coded peerings `1+2` and `2+3:gw` land in fabric-a through gateway-1; the check also expects every other pair to stay isolated.

## Known gaps

- The interconnect cable `ds3000-02` E1/26 to `ds3000-03` E1/26 does not exist. The ports are unused in `wiring.yaml`; whether they are free on the hardware was not checked. Until it is cabled, leave `wiring-interconnect.yaml` out.
- The release suites are not a valid pass/fail signal on two fabrics: they assume one fabric and pair VPCs across fabrics, which admission rejects. The CI job runs the default flow instead.
- `--ready=setup-peerings` has hard-coded requests (`1+2`, `2+3:gw`), so CI does not exercise fabric-b peerings, the Externals, or the interconnect. Making the requests configurable in hhfab is the follow-up.
- Multi-domain is not wired on this environment. It is covered by a VLAB job (`--orphan-leafs-count=3 --extra-domain`).
- The 4-byte range was tested on Dell switches (env-1), not on the Celestica or Supermicro switches of this environment.
- CI reads this directory from the default branch of `githedgehog/lab-ci`, so the files must be merged before the job can use them.
