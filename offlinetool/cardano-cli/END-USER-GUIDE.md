# Cardano-CLI Guide for End Users (No Node Required)

## Overview

As an end user who doesn't run a Cardano node, you can still use most cardano-cli commands for:
- Managing your wallet keys and addresses
- Building and signing transactions
- Participating in governance (DRep voting)
- Staking and delegation
- Converting key formats

## Commands Available Without Running a Node

### ✅ **Address Management** (No Node Required)

**Location:** `cardano-cli address`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `key-gen` | Create address key pair | Generate new wallet keys |
| `key-hash` | Print hash of address key | Get key hash for other operations |
| `build` | Build payment address | Create addresses from keys |
| `info` | Print address information | Verify address details |

**Example:**
```bash
# Generate payment keys
cardano-cli address key-gen \
  --verification-key-file payment.vkey \
  --signing-key-file payment.skey

# Build address
cardano-cli address build \
  --payment-verification-key-file payment.vkey \
  --out-file address.addr \
  --mainnet
```

---

### ✅ **Key Management** (No Node Required)

**Location:** `cardano-cli key`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `verification-key` | Get verification key from signing key | Extract public key |
| `non-extended-key` | Get non-extended key from extended key | Key format conversion |
| `generate-mnemonic` | Generate mnemonic sentence | Create wallet seed phrase |
| `derive-from-mnemonic` | Derive keys from mnemonic | Restore wallet from seed |
| `convert-byron-key` | Convert Byron key to Shelley | Migrate old keys |
| `convert-byron-genesis-vkey` | Convert Byron genesis vkey | Legacy key migration |
| `convert-itn-key` | Convert ITN key to Shelley | Testnet key migration |
| `convert-itn-extended-key` | Convert ITN extended key | Extended key migration |
| `convert-itn-bip32-key` | Convert ITN BIP32 key | BIP32 key migration |
| `convert-cardano-address-key` | Convert cardano-address key | Hardware wallet key conversion |

**Example:**
```bash
# Generate mnemonic (24 words)
cardano-cli key generate-mnemonic \
  --size 24 \
  --out-file mnemonic.txt

# Derive payment key from mnemonic
cardano-cli key derive-from-mnemonic \
  --mnemonic-from-file mnemonic.txt \
  --payment-key-with-number 0 \
  --account-number 0 \
  --signing-key-file payment.skey
```

---

### ✅ **Transaction Building** (No Node Required)

**Location:** `cardano-cli conway transaction`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `build-raw` | Build transaction (manual fee) | Low-level transaction building |
| `build` | Build transaction (auto fee) | **Recommended** - automatic fee calculation |
| `build-estimate` | Build transaction offline | Offline transaction building |
| `sign` | Sign transaction | Sign with your keys |
| `witness` | Create transaction witness | Partial signing |
| `assemble` | Assemble tx body and witnesses | Combine signatures |
| `policyid` | Calculate policy ID | For minting tokens |
| `calculate-min-fee` | Calculate minimum fee | Fee estimation |
| `calculate-min-required-utxo` | Calculate minimum UTxO | Determine minimum output |
| `calculate-plutus-script-cost` | Calculate Plutus script cost | Smart contract cost |
| `hash-script-data` | Hash script data | For script transactions |
| `txid` | Print transaction ID | Get transaction identifier |

**Example:**
```bash
# Build transaction (with automatic fee calculation)
cardano-cli conway transaction build \
  --babbage-era \
  --tx-in 1234abcd...#0 \
  --tx-out addr1...+1000000 \
  --change-address addr1... \
  --out-file tx.raw

# Sign transaction
cardano-cli conway transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --out-file tx.signed
```

**Note:** To submit the transaction, you'll need to use a block explorer or a service like cardanoscan.io, or connect to a public node.

---

### ✅ **Stake Address Management** (No Node Required)

**Location:** `cardano-cli conway stake-address`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `key-gen` | Create stake address key pair | Generate staking keys |
| `key-hash` | Print hash of stake key | Get stake key hash |
| `build` | Build stake address | Create stake address |
| `registration-certificate` | Create registration certificate | Register for staking |
| `deregistration-certificate` | Create deregistration certificate | Unregister from staking |
| `stake-delegation-certificate` | Create delegation certificate | Delegate to stake pool |
| `stake-and-vote-delegation-certificate` | Delegate stake and vote | Delegate to pool + DRep |
| `vote-delegation-certificate` | Create vote delegation certificate | Delegate to DRep only |
| `registration-and-delegation-certificate` | Register and delegate | One-step registration + delegation |
| `registration-and-vote-delegation-certificate` | Register and vote delegate | Register + DRep delegation |
| `registration-stake-and-vote-delegation-certificate` | Register, stake, and vote delegate | All-in-one certificate |

**Example:**
```bash
# Generate stake keys
cardano-cli conway stake-address key-gen \
  --verification-key-file stake.vkey \
  --signing-key-file stake.skey

# Create registration certificate
cardano-cli conway stake-address registration-certificate \
  --stake-verification-key-file stake.vkey \
  --out-file stake.cert

# Create delegation certificate
cardano-cli conway stake-address stake-delegation-certificate \
  --stake-verification-key-file stake.vkey \
  --stake-pool-id pool1... \
  --out-file delegation.cert
```

---

### ✅ **Governance (DRep)** (No Node Required)

**Location:** `cardano-cli conway governance drep`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `key-gen` | Generate DRep keys | Become a DRep |
| `id` | Generate DRep ID | Get your DRep identifier |
| `registration-certificate` | Create registration certificate | Register as DRep |
| `retirement-certificate` | Create retirement certificate | Retire as DRep |
| `update-certificate` | Create update certificate | Update DRep metadata |
| `metadata-hash` | Calculate metadata hash | For DRep metadata |

**Location:** `cardano-cli conway governance vote`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `create` | Create vote | Vote on governance actions |
| `view` | View vote | Inspect vote details |

**Location:** `cardano-cli conway governance action`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `create-constitution` | Create constitution action | Propose constitution change |
| `update-committee` | Create committee proposal | Propose committee update |
| `create-info` | Create info action | Submit information |
| `create-no-confidence` | Create no-confidence | Propose no-confidence vote |
| `create-protocol-parameters-update` | Create parameter update | Propose protocol changes |
| `create-treasury-withdrawal` | Create treasury withdrawal | Request treasury funds |
| `create-hardfork` | Create hardfork proposal | Propose hardfork |
| `view` | View governance action | Inspect action details |

**Example:**
```bash
# Generate DRep keys
cardano-cli conway governance drep key-gen \
  --verification-key-file drep.vkey \
  --signing-key-file drep.skey

# Register as DRep
cardano-cli conway governance drep registration-certificate \
  --drep-verification-key-file drep.vkey \
  --deposit 500000000 \
  --stake-verification-key-file stake.vkey \
  --out-file drep.cert
```

---

### ✅ **Hash Computation** (No Node Required)

**Location:** `cardano-cli hash`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `anchor-data` | Compute hash of anchor data | For governance anchors |
| `script` | Compute hash of script | For script transactions |
| `genesis-file` | Compute hash of genesis file | Genesis validation |

---

### ✅ **CIP-129 Format Conversion** (No Node Required)

**Location:** `cardano-cli cip-format cip-129`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `drep` | Convert DRep key to CIP-129 | Standardize DRep keys |
| `committee-hot-key` | Convert committee hot key | Standardize committee keys |
| `committee-cold-key` | Convert committee cold key | Standardize committee keys |
| `governance-action-id` | Convert governance action ID | Standardize action IDs |

---

### ✅ **Stake Pool Registration** (No Node Required)

**Location:** `cardano-cli conway stake-pool`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `registration-certificate` | Create pool registration | Register stake pool |
| `deregistration-certificate` | Create pool deregistration | Retire stake pool |
| `id` | Build pool ID | Get pool identifier |
| `metadata-hash` | Calculate metadata hash | For pool metadata |

**Note:** These are for stake pool operators, not typical end users.

---

### ✅ **Node Key Generation** (No Node Required)

**Location:** `cardano-cli node`

| Command | Purpose | Use Case |
|---------|---------|----------|
| `key-gen` | Create node operator keys | For stake pool operators |
| `key-gen-KES` | Create KES operational keys | For stake pool operators |
| `key-gen-VRF` | Create VRF operational keys | For stake pool operators |
| `key-hash-VRF` | Print VRF key hash | For stake pool operators |
| `new-counter` | Create certificate counter | For stake pool operators |
| `issue-op-cert` | Issue operational certificate | For stake pool operators |

**Note:** These are for stake pool operators only.

---

## ❌ Commands That Require a Running Node

### Query Commands
All `cardano-cli query` commands require a running node:
- tip, protocol-parameters, stake-distribution, etc.
- All Conway query commands

### Transaction Submission
- `cardano-cli conway transaction submit` - Requires node to submit transaction

### Debug Commands
- `cardano-cli debug log-epoch-state` - Requires running node
- `cardano-cli debug check-node-configuration` - Requires node configuration

### Ping
- `cardano-cli ping` - Requires node to ping

---

## How to Submit Transactions Without Running a Node

Since you can't use `transaction submit` without a node, use these alternatives:

### 1. **Public Node Services**
Use a public node's socket:
```bash
export CARDANO_NODE_SOCKET_PATH=/path/to/public/node/socket
cardano-cli conway transaction submit --tx-file tx.signed
```

### 2. **Wallet Services**
- Daedalus Wallet
- Lace Wallet 

### 3. **REST APIs**
- Blockfrost API
- Koios API
- Omigos API

---

## Typical End User Workflow

### 1. **Create Wallet**
```bash
# Generate mnemonic
cardano-cli key generate-mnemonic --size 24 --out-file mnemonic.txt

# Derive payment key
cardano-cli key derive-from-mnemonic \
  --mnemonic-from-file mnemonic.txt \
  --payment-key-with-number 0 \
  --account-number 0 \
  --signing-key-file payment.skey

# Derive stake key
cardano-cli key derive-from-mnemonic \
  --mnemonic-from-file mnemonic.txt \
  --stake-key-with-number 0 \
  --account-number 0 \
  --signing-key-file stake.skey

# Build addresses
cardano-cli address build \
  --payment-verification-key-file payment.vkey \
  --out-file payment.addr

cardano-cli conway stake-address build \
  --stake-verification-key-file stake.vkey \
  --out-file stake.addr
```

### 2. **Register for Staking**
```bash
# Create registration certificate
cardano-cli conway stake-address registration-certificate \
  --stake-verification-key-file stake.vkey \
  --out-file stake.cert

# Build transaction (with registration cert)
cardano-cli conway transaction build \
  --babbage-era \
  --tx-in <input> \
  --tx-out <change> \
  --certificate-file stake.cert \
  --change-address <address> \
  --out-file tx.raw

# Sign transaction
cardano-cli conway transaction sign \
  --tx-body-file tx.raw \
  --signing-key-file payment.skey \
  --signing-key-file stake.skey \
  --out-file tx.signed

# Submit via block explorer or public node
```

### 3. **Delegate to Stake Pool**
```bash
# Create delegation certificate
cardano-cli conway stake-address stake-delegation-certificate \
  --stake-verification-key-file stake.vkey \
  --stake-pool-id <pool-id> \
  --out-file delegation.cert

# Build transaction
cardano-cli conway transaction build \
  --babbage-era \
  --tx-in <input> \
  --tx-out <change> \
  --certificate-file delegation.cert \
  --change-address <address> \
  --out-file tx.raw

# Sign and submit
```

### 4. **Participate in Governance**
```bash
# Generate DRep keys (optional)
cardano-cli conway governance drep key-gen \
  --verification-key-file drep.vkey \
  --signing-key-file drep.skey

# Create vote delegation
cardano-cli conway stake-address vote-delegation-certificate \
  --stake-verification-key-file stake.vkey \
  --drep-id <drep-id> \
  --out-file vote-delegation.cert

# Build transaction with vote delegation
cardano-cli conway transaction build \
  --babbage-era \
  --tx-in <input> \
  --tx-out <change> \
  --certificate-file vote-delegation.cert \
  --change-address <address> \
  --out-file tx.raw

# Sign and submit
```

---

## Summary

### ✅ You CAN Use (No Node Required):
- **~100+ commands** for key management, address building, transaction building, staking, and governance
- All address, key, hash, and most transaction commands
- All stake address and governance commands
- CIP-129 format conversion

### ❌ You CANNOT Use (Node Required):
- Query commands (need node to query blockchain state)
- Transaction submit (need node to broadcast)
- Debug commands (need running node)
- Ping (need node to ping)

### 💡 Tip:
For most end-user operations, you only need cardano-cli for:
1. Key generation and management
2. Address building
3. Transaction building and signing
4. Certificate creation (staking, governance)
5. Submit via block explorer or public node

---

*This guide focuses on end users who don't run their own Cardano node.*
