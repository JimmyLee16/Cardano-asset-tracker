---
description: Create and use a multi-sig (M-of-N) address with native scripts
---

# Multi-Sig Address (Native Scripts)

Cardano supports multi-sig via **native scripts** — no Plutus needed. This workflow creates an M-of-N multi-sig address, builds a spending transaction, and collects partial signatures from each required signer.

## Prerequisites
- Each signer has their own key pair (vkey + skey)
- Know how many signatures are required (M) out of total signers (N)

---

## Part 1: Setup — Create Multi-Sig Address

### 1. Generate keys for each signer

Each person generates their own key pair independently:

```bash
# Signer 1
cardano-cli address key-gen \
  --verification-key-file signer1.vkey \
  --signing-key-file signer1.skey

# Signer 2
cardano-cli address key-gen \
  --verification-key-file signer2.vkey \
  --signing-key-file signer2.skey

# Signer 3
cardano-cli address key-gen \
  --verification-key-file signer3.vkey \
  --signing-key-file signer3.skey
```

### 2. Get key hash for each signer

```bash
cardano-cli address key-hash --payment-verification-key-file signer1.vkey
cardano-cli address key-hash --payment-verification-key-file signer2.vkey
cardano-cli address key-hash --payment-verification-key-file signer3.vkey
```

### 3. Create the multi-sig script

Write a JSON file `multisig.json`. Example: **2-of-3** (any 2 of 3 signers required):

```json
{
  "type": "atLeast",
  "required": 2,
  "scripts": [
    { "type": "sig", "keyHash": "<hash-signer1>" },
    { "type": "sig", "keyHash": "<hash-signer2>" },
    { "type": "sig", "keyHash": "<hash-signer3>" }
  ]
}
```

**Script types:**

| Type | Description | Use Case |
|------|-------------|----------|
| `all` | ALL sub-scripts must be satisfied | N-of-N (everyone signs) |
| `any` | ANY one sub-script must be satisfied | 1-of-N (anyone signs) |
| `atLeast` | At least M sub-scripts must be satisfied | M-of-N multi-sig |
| `before` | Valid only before slot N | Time-locked expiry |
| `after` | Valid only after slot N | Time-locked vesting |

**Nested example** — 2-of-3 + time-lock (valid until slot 99999999):

```json
{
  "type": "all",
  "scripts": [
    {
      "type": "atLeast",
      "required": 2,
      "scripts": [
        { "type": "sig", "keyHash": "<hash1>" },
        { "type": "sig", "keyHash": "<hash2>" },
        { "type": "sig", "keyHash": "<hash3>" }
      ]
    },
    { "type": "before", "slot": 99999999 }
  ]
}
```

### 4. Build the multi-sig address

```bash
cardano-cli address build \
  --payment-script-file multisig.json \
  --mainnet \
  --out-file multisig.addr
```

### 5. (Optional) Calculate script hash

```bash
cardano-cli hash script --script-file multisig.json
```

---

## Part 2: Spend from Multi-Sig Address

### 6. Build the transaction

```bash
cardano-cli conway transaction build \
  --conway-era \
  --tx-in <txhash>#<index> \
  --tx-in-script-file multisig.json \
  --tx-out <recipient-address>+<amount> \
  --change-address <multisig-addr> \
  --out-file tx.raw
```

### 7. Each required signer creates a witness

Each signer signs INDEPENDENTLY on their own machine:

```bash
# Signer 1 creates witness
cardano-cli conway transaction witness \
  --tx-body-file tx.raw \
  --signing-key-file signer1.skey \
  --out-file witness1.witness

# Signer 2 creates witness
cardano-cli conway transaction witness \
  --tx-body-file tx.raw \
  --signing-key-file signer2.skey \
  --out-file witness2.witness
```

Only `required` (M) witnesses are needed. Any M of the N signers.

### 8. Assemble the transaction with witnesses

```bash
cardano-cli conway transaction assemble \
  --tx-body-file tx.raw \
  --witness-file witness1.witness \
  --witness-file witness2.witness \
  --out-file tx.signed
```

### 9. Get transaction ID

```bash
cardano-cli conway transaction txid --tx-file tx.signed
```

### 10. Submit the transaction

Submit via node, block explorer, or API service.

---

## Security Notes

- **Script file is public** — it only contains key hashes, not private keys
- Each signer only needs: `tx.raw` (transaction body) + their own `signerX.skey`
- Signers never need to share their signing keys with each other
- The transaction body (`tx.raw`) can be safely sent over any channel
- Witnesses can be collected from different machines/locations
- Once assembled, `tx.signed` contains the full transaction with all signatures

## Common Patterns

### Treasury (2-of-3)
Two board members must approve any spending from the treasury.

### Escrow (2-of-3: buyer, seller, arbiter)
```json
{
  "type": "atLeast",
  "required": 2,
  "scripts": [
    { "type": "sig", "keyHash": "<buyer-hash>" },
    { "type": "sig", "keyHash": "<seller-hash>" },
    { "type": "sig", "keyHash": "<arbiter-hash>" }
  ]
}
```

### Vesting with time-lock
Funds locked until a specific slot, then 1-of-2 can spend:
```json
{
  "type": "all",
  "scripts": [
    { "type": "after", "slot": 50000000 },
    {
      "type": "any",
      "scripts": [
        { "type": "sig", "keyHash": "<owner-hash>" },
        { "type": "sig", "keyHash": "<backup-hash>" }
      ]
    }
  ]
}
```
