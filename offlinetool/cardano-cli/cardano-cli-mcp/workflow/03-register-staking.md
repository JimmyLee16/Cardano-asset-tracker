---
description: Register for staking and delegate to a stake pool
---

# Register Staking and Delegate to Pool

This workflow creates a stake address registration certificate and a delegation certificate, then builds and signs the transaction to submit them on-chain.

## Prerequisites
- Payment keys (payment.vkey, payment.skey)
- Stake keys (stake.vkey, stake.skey)
- A UTxO to pay the registration deposit + fees
- Target stake pool ID (pool1...)

## Steps

### 1. Create stake registration certificate
```bash
cardano-cli conway stake-address registration-certificate \
  --stake-verification-key-file stake.vkey \
  --out-file stake.cert
```

### 2. Create delegation certificate
```bash
cardano-cli conway stake-address stake-delegation-certificate \
  --stake-verification-key-file stake.vkey \
  --stake-pool-id <pool-id> \
  --out-file delegation.cert
```

### 3. Build transaction with both certificates
```bash
cardano-cli conway transaction build \
  --conway-era \
  --tx-in <txhash>#<index> \
  --tx-out <change-address>+<amount> \
  --certificate-file stake.cert \
  --certificate-file delegation.cert \
  --change-address <your-payment-address> \
  --out-file tx.raw
```

### 4. Sign with both payment and stake keys
```bash
cardano-cli conway transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --signing-key-file stake.skey \
  --out-file tx.signed
```

### 5. Get transaction ID
```bash
cardano-cli conway transaction txid --tx-file tx.signed
```

### 6. Submit the transaction
Submit via node, block explorer, or API service.

## Combined Registration + Delegation

You can also create a single certificate that registers AND delegates in one step:
```bash
cardano-cli conway stake-address registration-and-delegation-certificate \
  --stake-verification-key-file stake.vkey \
  --stake-pool-id <pool-id> \
  --out-file stake-reg-delegation.cert
```

## Deregistering Stake
```bash
cardano-cli conway stake-address deregistration-certificate \
  --stake-verification-key-file stake.vkey \
  --out-file stake-dereg.cert
```

## Notes
- Stake registration deposit: 2,000,000 lovelace (2 ADA) — refunded on deregistration
- After submission, it takes ~1 epoch for staking to activate
- Rewards accumulate automatically after activation
