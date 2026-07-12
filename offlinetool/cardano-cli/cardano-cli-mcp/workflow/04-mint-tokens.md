---
description: Mint native tokens or NFTs on Cardano using a time-locked policy
---

# Mint Native Tokens

This workflow creates a minting policy, calculates the policy ID, builds a minting transaction, and signs it.

## Prerequisites
- Payment keys (payment.vkey, payment.skey)
- A UTxO to pay fees
- Protocol parameters file (for fee calculation)

## Steps

### 1. Create a minting policy script

Create a `policy.script` file with a time-locked policy (example):
```json
{
  "type": "all",
  "scripts": [
    {
      "type": "before",
      "slot": 99999999
    },
    {
      "type": "sig",
      "keyHash": "<your-payment-key-hash>"
    }
  ]
}
```

Get your key hash:
```bash
cardano-cli address key-hash --payment-verification-key-file payment.vkey
```

### 2. Calculate the policy ID
```bash
cardano-cli conway transaction policyid \
  --script-file policy.script \
  --out-file policyid.txt
```

### 3. Build the minting transaction
```bash
cardano-cli conway transaction build \
  --conway-era \
  --tx-in <txhash>#<index> \
  --tx-out <your-address>+<amount-lovelace>+"<policyid>.<tokenname> <quantity>" \
  --mint "<quantity> <policyid>.<tokenname>" \
  --minting-policy-file policy.script \
  --change-address <your-address> \
  --out-file tx.raw
```

### 4. Sign the transaction
```bash
cardano-cli conway transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --out-file tx.signed
```

### 5. Get transaction ID
```bash
cardano-cli conway transaction txid --tx-file tx.signed
```

### 6. Submit the transaction

## Minting NFTs

For NFTs, the quantity is 1 and you typically include metadata:

```bash
cardano-cli conway transaction build \
  --conway-era \
  --tx-in <txhash>#<index> \
  --tx-out <your-address>+<min-utxo>+"<policyid>.<nftname> 1" \
  --mint "1 <policyid>.<nftname>" \
  --minting-policy-file policy.script \
  --metadata-json-file metadata.json \
  --change-address <your-address> \
  --out-file tx.raw
```

Example `metadata.json` (CIP-25 format):
```json
{
  "721": {
    "<policyid>": {
      "<nftname>": {
        "name": "My NFT",
        "image": "ipfs://<ipfs-hash>",
        "description": "Description here"
      }
    }
  }
}
```

## Notes
- Token names are hex-encoded in the CLI (e.g. use ASCII hex for readable names)
- The `--before` slot in the policy makes tokens non-mintable after that slot
- Calculate min UTxO: `cardano-cli conway transaction calculate-min-required-utxo`
- 1 ADA = 1,000,000 lovelace
