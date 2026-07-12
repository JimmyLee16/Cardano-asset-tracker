---
description: Create a new Cardano wallet (keys + addresses) from mnemonic
---

# Create Cardano Wallet

This workflow generates a full Cardano wallet: mnemonic seed phrase, payment keys, stake keys, and addresses. No running node required.

## Prerequisites
- cardano-cli.exe available (or cardano-cli MCP server configured)
- Workspace directory for key files

## Steps

1. Generate a 24-word mnemonic seed phrase:
```bash
cardano-cli key generate-mnemonic --size 24 --out-file mnemonic.txt
```
// turbo

2. Derive the payment signing key from the mnemonic:
```bash
cardano-cli key derive-from-mnemonic \
  --mnemonic-from-file mnemonic.txt \
  --payment-key-with-number 0 \
  --account-number 0 \
  --signing-key-file payment.skey
```

3. Extract the payment verification key from the signing key:
```bash
cardano-cli key verification-key \
  --signing-key-file payment.skey \
  --verification-key-file payment.vkey
```

4. Derive the stake signing key from the mnemonic:
```bash
cardano-cli key derive-from-mnemonic \
  --mnemonic-from-file mnemonic.txt \
  --stake-key-with-number 0 \
  --account-number 0 \
  --signing-key-file stake.skey
```

5. Extract the stake verification key:
```bash
cardano-cli key verification-key \
  --signing-key-file stake.skey \
  --verification-key-file stake.vkey
```

6. Build the payment address (with stake delegation):
```bash
cardano-cli address build \
  --payment-verification-key-file payment.vkey \
  --stake-verification-key-file stake.vkey \
  --mainnet \
  --out-file payment.addr
```

7. Build the stake address:
```bash
cardano-cli conway stake-address build \
  --stake-verification-key-file stake.vkey \
  --mainnet \
  --out-file stake.addr
```

## Result Files
- `mnemonic.txt` — 24-word seed phrase (KEEP SECRET, backup offline)
- `payment.vkey` / `payment.skey` — Payment key pair
- `stake.vkey` / `stake.skey` — Stake key pair
- `payment.addr` — Payment address (share to receive ADA)
- `stake.addr` — Stake address (for staking operations)

## Security Notes
- **NEVER share** `mnemonic.txt`, `*.skey` files
- Store mnemonic offline (paper/metal backup)
- `payment.addr` and `*.vkey` files are safe to share
