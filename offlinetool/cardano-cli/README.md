# Cardano-CLI Documentation (Version 11.0.0.0) - Complete Reference

## Documentation Files

This documentation has been split into multiple files for better organization and navigation:

### 1. **cardano-cli-documentation-main.md**
Main commands and core functionality:
- Main Commands Overview
- Address Commands (key-gen, key-hash, build, info)
- Key Commands (verification-key, non-extended-key, generate-mnemonic, derive-from-mnemonic, convert-byron-key, etc.)
- Node Commands (key-gen, key-gen-KES, key-gen-VRF, key-hash-VRF, new-counter, issue-op-cert)
- Hash Commands (anchor-data, script, genesis-file)
- Ping Command

### 2. **cardano-cli-documentation-query.md**
All query commands for interacting with a running node:
- tip, protocol-parameters, stake-distribution, stake-snapshot
- stake-address-info, utxo, tx-mempool, tx-info
- gov-state, drep-state, committee-state, draft-constitution
- committee-members, constitution, drep-anchors, drep-list
- drep-deposit, drep-voting-governance-actions, vote-anchors
- gov-action-anchors, gov-action-state, gov-action-details, gov-action-proposal
- governance-poll, ledger-state, slot-number, leadership-schedule
- stake-pools, pool-params, pool-params-raw, pool-status
- kes-period-info, leadership-logs, leadership
- set-ledger-state, protocol-state, protocol-version
- block, block-header, tx-view
- Raw query command variants

### 3. **cardano-cli-documentation-conway.md**
Conway era commands (latest governance-focused era):
- **Transaction Commands:** build-raw, build, build-estimate, sign, witness, assemble, submit, policyid, calculate-min-fee, calculate-min-required-utxo, calculate-plutus-script-cost, hash-script-data, txid
- **Stake Pool Commands:** registration-certificate, deregistration-certificate, id, metadata-hash
- **Governance Commands:**
  - Action: create-constitution, update-committee, create-info, create-no-confidence, create-protocol-parameters-update, create-treasury-withdrawal, create-hardfork, view
  - Committee: key-gen-cold, key-gen-hot, key-hash, create-hot-key-authorization-certificate, create-cold-key-resignation-certificate
  - DRep: key-gen, id, registration-certificate, retirement-certificate, update-certificate, metadata-hash
  - Vote: create, view
- **Stake Address Commands:** key-gen, key-hash, build, registration-certificate, deregistration-certificate, stake-delegation-certificate, stake-and-vote-delegation-certificate, vote-delegation-certificate, registration-and-delegation-certificate, registration-and-vote-delegation-certificate, registration-stake-and-vote-delegation-certificate
- **Genesis Commands:** key-gen-genesis, key-gen-delegate, key-gen-utxo, key-hash, get-ver-key, initial-addr, initial-txin, create-cardano, create, create-staked, create-testnet-data, hash
- **Text View Commands**

### 4. **cardano-cli-documentation-byron.md**
Byron era commands (original Cardano era):
- **Byron Key Commands:** keygen, to-verification, signing-key-public, signing-key-address, migrate-delegate-key-from
- **Byron Transaction Commands:** submit-tx, issue-genesis-utxo-expenditure, issue-utxo-expenditure, txid
- **Byron Genesis Commands:** genesis, print-genesis-hash
- **Byron Governance Commands**
- **Byron Miscellaneous Commands:** validate-cbor, pretty-print-cbor

### 5. **cardano-cli-documentation-debug-cip.md**
Debug and CIP format commands:
- **Debug Commands:**
  - log-epoch-state: Log epoch state of a running node
  - check-node-configuration: Check hashes and paths of genesis files
  - transaction: Debug transaction commands
- **CIP-129 Commands:**
  - drep: Convert DRep verification key to CIP-129 format
  - committee-hot-key: Convert committee hot key to CIP-129 format
  - committee-cold-key: Convert committee cold key to CIP-129 format
  - governance-action-id: Convert governance action ID to CIP-129 format

### 6. **cardano-cli-documentation-remaining.md**
Additional information:
- Legacy Commands overview
- Byron Commands overview
- Conway Commands overview
- Dijkstra Commands overview
- Latest Commands overview
- Debug Commands overview
- CIP Format Commands overview
- Compatible Commands overview
- Version Command
- Help Command
- Environment Variables
- Common Usage Patterns
- File Formats
- Network Magic Values
- Era Selection
- Security Best Practices
- Troubleshooting
- Additional Resources

---

## Command Structure Overview

```
cardano-cli.exe
├── address              # Payment address commands
├── key                  # Key utility commands
├── node                 # Node operation commands
├── hash                 # Compute hashes
├── query                # Node query commands
├── legacy               # Legacy commands
├── byron                # Byron era commands
├── conway               # Conway era commands
│   ├── address
│   ├── key
│   ├── genesis
│   ├── governance
│   │   ├── action
│   │   ├── committee
│   │   ├── drep
│   │   └── vote
│   ├── node
│   ├── query
│   ├── stake-address
│   ├── stake-pool
│   ├── text-view
│   └── transaction
├── dijkstra             # Dijkstra era commands
├── latest               # Latest era commands (Conway)
├── debug                # Debug commands
├── ping                 # Ping a node
├── cip-format           # CIP format commands
├── compatible           # Backward compatible commands
├── version              # Show version
└── help                 # Show help
```

---

## Quick Start

### For New Users
1. Start with **cardano-cli-documentation-main.md** for basic operations
2. Read **cardano-cli-documentation-query.md** for node interaction
3. Use **cardano-cli-documentation-conway.md** for modern governance features

### For Stake Pool Operators
1. Review **cardano-cli-documentation-main.md** (Node Commands section)
2. Check **cardano-cli-documentation-conway.md** (Stake Pool Commands section)
3. Use **cardano-cli-documentation-query.md** for pool monitoring

### For Governance Participants
1. Read **cardano-cli-documentation-conway.md** (Governance Commands section)
2. Review DRep and Committee command sections
3. Use **cardano-cli-documentation-debug-cip.md** for CIP-129 format conversion

### For Developers
1. Review **cardano-cli-documentation-debug-cip.md** for debugging tools
2. Check **cardano-cli-documentation-byron.md** for legacy compatibility
3. Use **cardano-cli-documentation-remaining.md** for additional resources

---

## Version Information

- **Cardano-CLI Version:** 11.0.0.0
- **Documented Era:** Conway (latest governance era)
- **Supported Eras:** Byron, Shelley, Allegra, Mary, Alonzo, Babbage, Conway

---

## Notes

- This documentation covers all commands available in cardano-cli version 11.0.0.0
- Conway era is the latest and recommended era for new implementations
- Byron commands are deprecated and should only be used for legacy compatibility
- Legacy commands are provided for backward compatibility testing only
- Always use era-specific commands (e.g., `conway transaction`) for the best experience

---

## Documentation Status

✅ Main commands - Complete
✅ Query commands - Complete  
✅ Conway era commands - Complete
✅ Byron era commands - Complete
✅ Debug commands - Complete
✅ CIP format commands - Complete
✅ Additional resources - Complete

All commands and their options have been documented based on the actual help output from cardano-cli.exe version 11.0.0.0.
