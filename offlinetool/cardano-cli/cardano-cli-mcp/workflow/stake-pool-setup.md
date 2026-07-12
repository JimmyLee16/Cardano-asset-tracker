---
description: Set up a Cardano stake pool (keys, certificates, operational cert)
---

# Stake Pool Setup

This workflow generates all keys and certificates needed to register and operate a stake pool.

## Prerequisites
- Payment keys for pool owner
- Stake keys for reward account

## Steps

### 1. Generate node cold keys
```bash
cardano-cli node key-gen \
  --cold-verification-key-file cold.vkey \
  --cold-signing-key-file cold.skey \
  --operational-certificate-issue-counter-file op-cert.counter
```

### 2. Generate KES keys
```bash
cardano-cli node key-gen-KES \
  --verification-key-file kes.vkey \
  --signing-key-file kes.skey
```

### 3. Generate VRF keys
```bash
cardano-cli node key-gen-VRF \
  --verification-key-file vrf.vkey \
  --signing-key-file vrf.skey
```

### 4. Get VRF key hash (needed for registration)
```bash
cardano-cli node key-hash-VRF --verification-key-file vrf.vkey
```

### 5. Issue operational certificate
```bash
cardano-cli node issue-op-cert \
  --kes-verification-key-file kes.vkey \
  --cold-signing-key-file cold.skey \
  --operational-certificate-issue-counter-file op-cert.counter \
  --kes-period <current-kes-period> \
  --out-file op.cert
```

### 6. Get pool ID
```bash
cardano-cli conway stake-pool id \
  --cold-verification-key-file cold.vkey
```

### 7. Calculate pool metadata hash
```bash
cardano-cli conway stake-pool metadata-hash \
  --pool-metadata-file pool-metadata.json
```

### 8. Create pool registration certificate
```bash
cardano-cli conway stake-pool registration-certificate \
  --cold-verification-key-file cold.vkey \
  --vrf-verification-key-file vrf.vkey \
  --pledge <pledge-lovelace> \
  --cost <cost-lovelace> \
  --margin 0.05 \
  --reward-account-verification-key-file stake.vkey \
  --pool-owner-stake-verification-key-file stake.vkey \
  --pool-relay-ipv4 <relay-ip> \
  --pool-relay-port <relay-port> \
  --metadata-url <metadata-url> \
  --metadata-hash <metadata-hash> \
  --out-file pool-registration.cert
```

### 9. Build and sign registration transaction
```bash
cardano-cli conway transaction build \
  --conway-era \
  --tx-in <txhash>#<index> \
  --certificate-file pool-registration.cert \
  --change-address <your-address> \
  --out-file tx.raw

cardano-cli conway transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --signing-key-file cold.skey \
  --out-file tx.signed
```

### 10. Submit the transaction

## Pool Retirement
```bash
cardano-cli conway stake-pool deregistration-certificate \
  --cold-verification-key-file cold.vkey \
  --epoch <retirement-epoch> \
  --out-file pool-deregistration.cert
```

## Key Files Summary
- `cold.vkey` / `cold.skey` — Pool cold keys (KEEP OFFLINE)
- `kes.vkey` / `kes.skey` — KES operational keys (on the block producer)
- `vrf.vkey` / `vrf.skey` — VRF keys (on the block producer)
- `op.cert` — Operational certificate
- `op-cert.counter` — Certificate issue counter

## Notes
- KES keys must be rotated every ~90 days
- Pool pledge must be present in the pool owner's wallet
- Margin is a fraction (0.05 = 5%)
- Keep cold keys on an air-gapped machine
