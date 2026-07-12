---
description: Build, sign, and prepare a Cardano transaction for submission
---

# Build and Sign Transaction

This workflow builds a balanced transaction, signs it, and extracts the transaction ID. The signed transaction can then be submitted via a block explorer, public node, or wallet.

## Prerequisites
- Payment keys already generated (payment.vkey, payment.skey)
- Know your transaction inputs (UTxO from block explorer)
- Protocol parameters file (if using build-raw)

## Steps

### Option A: Build with automatic fee (requires node or protocol-params)

1. Build the transaction body:
```bash
cardano-cli conway transaction build \
  --conway-era \
  --tx-in <txhash>#<index> \
  --tx-out <recipient-address>+<amount-in-lovelace> \
  --change-address <your-payment-address> \
  --out-file tx.raw
```

### Option B: Build raw (fully offline, manual fee)

1. Calculate the minimum fee first (needs protocol-parameters.json):
```bash
cardano-cli conway transaction calculate-min-fee \
  --tx-body-file tx.raw \
  --tx-in-count 1 \
  --tx-out-count 2 \
  --witness-count 1 \
  --protocol-parameters-file protocol-parameters.json
```

2. Build raw transaction with the calculated fee:
```bash
cardano-cli conway transaction build-raw \
  --conway-era \
  --tx-in <txhash>#<index> \
  --tx-out <recipient-address>+<amount> \
  --tx-out <change-address>+<change-amount> \
  --fee <fee-in-lovelace> \
  --out-file tx.raw
```

### Sign the transaction

3. Sign with your payment key:
```bash
cardano-cli conway transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --out-file tx.signed
```

### Get transaction ID

4. Extract the transaction ID:
```bash
cardano-cli conway transaction txid --tx-file tx.signed
```

### Submit (requires node or external service)

5. Submit via node:
```bash
cardano-cli conway transaction submit \
  --tx-file tx.signed \
  --socket-path <node-socket-path>
```

Or submit via:
- CardanoScan (https://cardanoscan.io/tx-submit)
- Blockfrost API
- Koios API
- A wallet (Daedalus, Lace, etc.)

## Multi-signature (Partial Signing)

For transactions requiring multiple signatures (e.g. multi-sig or cold/hot wallet):

```bash
# Create witness on signing machine
cardano-cli conway transaction witness \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --out-file tx.witness

# Assemble on any machine
cardano-cli conway transaction assemble \
  --tx-body-file tx.raw \
  --witness-file tx.witness \
  --out-file tx.signed
```

## Unit Conversion
- 1 ADA = 1,000,000 lovelace
- Example: 10 ADA = 10000000 lovelace
