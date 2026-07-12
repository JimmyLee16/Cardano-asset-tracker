---
description: Participate in Cardano governance as a DRep or delegate votes
---

# Governance Participation

This workflow covers two governance roles:
1. **Becoming a DRep** — Register as a Delegate Representative
2. **Delegating votes** — Delegate your voting power to a DRep
3. **Voting on governance actions** — Create votes as a DRep

## Prerequisites
- Payment and stake keys already generated
- A UTxO for transaction fees + deposits

---

## Part 1: Become a DRep

### 1. Generate DRep keys
```bash
cardano-cli conway governance drep key-gen \
  --verification-key-file drep.vkey \
  --signing-key-file drep.skey
```

### 2. Get DRep ID
```bash
cardano-cli conway governance drep id \
  --verification-key-file drep.vkey
```

### 3. Create DRep registration certificate
```bash
cardano-cli conway governance drep registration-certificate \
  --drep-verification-key-file drep.vkey \
  --deposit 500000000 \
  --stake-verification-key-file stake.vkey \
  --out-file drep.cert
```

### 4. Build and sign the registration transaction
```bash
cardano-cli conway transaction build \
  --conway-era \
  --tx-in <txhash>#<index> \
  --certificate-file drep.cert \
  --change-address <your-address> \
  --out-file tx.raw

cardano-cli conway transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --signing-key-file drep.skey \
  --out-file tx.signed
```

### 5. Submit the transaction

---

## Part 2: Delegate Votes to a DRep

### 1. Create vote delegation certificate
```bash
cardano-cli conway stake-address vote-delegation-certificate \
  --stake-verification-key-file stake.vkey \
  --drep-id <drep-id> \
  --out-file vote-delegation.cert
```

### 2. Build and sign transaction
```bash
cardano-cli conway transaction build \
  --conway-era \
  --tx-in <txhash>#<index> \
  --certificate-file vote-delegation.cert \
  --change-address <your-address> \
  --out-file tx.raw

cardano-cli conway transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --signing-key-file stake.skey \
  --out-file tx.signed
```

### 3. Submit

---

## Part 3: Vote on a Governance Action (as DRep)

### 1. Create a vote
```bash
cardano-cli conway governance vote create \
  --governance-action-id <action-txhash>#<index> \
  --drep-verification-key-file drep.vkey \
  --vote YES \
  --out-file vote.json
```

Vote options: `YES`, `NO`, `ABSTAIN`

### 2. View the vote
```bash
cardano-cli conway governance vote view --vote-file vote.json
```

### 3. Build and sign the voting transaction
```bash
cardano-cli conway transaction build \
  --conway-era \
  --tx-in <txhash>#<index> \
  --vote-file vote.json \
  --change-address <your-address> \
  --out-file tx.raw

cardano-cli conway transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --signing-key-file drep.skey \
  --out-file tx.signed
```

### 4. Submit

---

## Combined Stake + Vote Delegation

Delegate both stake (to a pool) and vote (to a DRep) in one certificate:
```bash
cardano-cli conway stake-address stake-and-vote-delegation-certificate \
  --stake-verification-key-file stake.vkey \
  --stake-pool-id <pool-id> \
  --drep-id <drep-id> \
  --out-file stake-vote-delegation.cert
```

## DRep Retirement
```bash
cardano-cli conway governance drep retirement-certificate \
  --drep-verification-key-file drep.vkey \
  --deposit 500000000 \
  --stake-verification-key-file stake.vkey \
  --out-file drep-retirement.cert
```

## Notes
- DRep deposit: 500,000,000 lovelace (500 ADA) — refunded on retirement
- Always verify governance action IDs before voting
- You can delegate to `drep_always_abstain` or `drep_always_no_confidence` (special DRep IDs)
