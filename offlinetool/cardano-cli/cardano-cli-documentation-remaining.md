# Cardano-CLI Documentation - Remaining Commands (Version 11.0.0.0)

## Legacy Commands

### Overview
Legacy commands are deprecated and provided for backward compatibility only. Use the modern equivalents where possible.

**Main legacy categories:**
- Address and stake key management
- Stake pool operations
- Voting and governance
- Node operations
- Genesis operations
- Query operations (deprecated)

### Note
The legacy commands have been superseded by the modern command structure. For new implementations, use the standard `address`, `key`, `node`, `query`, and governance commands documented in the main documentation files.

---

## Byron Commands

### Overview
```
cardano-cli.exe byron (...)
```

Byron commands are specific to the Byron era of Cardano. These commands handle Byron-specific operations including:

- Byron address generation and management
- Byron key operations
- Byron transaction handling
- Byron genesis operations

### Note
Most Byron operations are deprecated in favor of Shelley and later era commands. Use these only when specifically working with Byron-era data or nodes.

---

## Conway Commands

### Overview
```
cardano-cli.exe conway (...)
```

Conway commands are specific to the Conway era (the latest governance-focused era). These include:

- Governance action creation
- DRep (Delegate Representative) operations
- Committee management
- Constitution handling
- Voting procedures

### Key Conway Features
- On-chain governance
- DRep registration and voting
- Constitutional committees
- Governance proposals

---

## Dijkstra Commands

### Overview
```
cardano-cli.exe dijkstra (...)
```

Dijkstra commands are specific to the Dijkstra era (intermediate governance era).

---

## Latest Commands

### Overview
```
cardano-cli.exe latest (...)
```

The `latest` command is an alias for the most recent era's commands (currently Conway). It provides forward compatibility by always pointing to the latest era's functionality.

---

## Debug Commands

### Overview
```
cardano-cli.exe debug (...)
```

Debug commands are used for development and troubleshooting purposes. These include:

- Ledger state inspection
- Protocol state debugging
- Transaction analysis
- Node state verification

---

## CIP Format Commands

### Overview
```
cardano-cli.exe cip-format (...)
```

CIP (Cardano Improvement Proposal) format commands handle operations related to CIP changes and implementations.

---

## Compatible Commands

### Overview
```
cardano-cli.exe compatible (...)
```

Compatible commands provide limited backward compatibility for testing purposes only. These are not intended for production use.

---

## Version Command

### Description
Show the cardano-cli version.

**Usage:**
```
cardano-cli.exe version
```

**Output:**
```
cardano-cli 11.0.0.0 - linux-x86_64 - ghc-9.6.3
```

---

## Help Command

### Description
Show all help information.

**Usage:**
```
cardano-cli.exe help
```

This displays the main help menu with all available commands and their descriptions.

---

## Environment Variables

### CARDANO_NODE_SOCKET_PATH
The path to the cardano-node socket file. Required for query commands that interact with a running node.

**Example:**
```bash
export CARDANO_NODE_SOCKET_PATH=/path/to/node.socket
```

### CARDANO_NODE_NETWORK_ID
The network identifier (mainnet or testnet magic). Can be overridden with command-line flags.

**Example:**
```bash
export CARDANO_NODE_NETWORK_ID=mainnet
# or
export CARDANO_NODE_NETWORK_ID=1097911063  # testnet magic
```

---

## Common Usage Patterns

### Key Generation Workflow
1. Generate mnemonic: `cardano-cli key generate-mnemonic`
2. Derive keys: `cardano-cli key derive-from-mnemonic`
3. Build address: `cardano-cli address build`

### Transaction Building Workflow
1. Query UTxO: `cardano-cli query utxo`
2. Build transaction: `cardano-cli transaction build`
3. Sign transaction: `cardano-cli transaction sign`
4. Submit transaction: `cardano-cli transaction submit`

### Stake Pool Workflow
1. Generate pool keys: `cardano-cli node key-gen`
2. Generate KES keys: `cardano-cli node key-gen-KES`
3. Generate VRF keys: `cardano-cli node key-gen-VRF`
4. Issue operational certificate: `cardano-cli node issue-op-cert`
5. Register pool: `cardano-cli stake-pool registration-certificate`

---

## File Formats

### Key Files
Keys can be stored in multiple formats:
- **Bech32**: Human-readable format (e.g., `addr_vkh1...`)
- **Text Envelope**: JSON format with metadata
- **Hex**: Raw hexadecimal encoding

### Transaction Files
Transactions are stored in text envelope format (JSON) containing:
- Transaction body
- Witnesses (signatures)
- Metadata

### Certificate Files
Certificates are stored in text envelope format containing:
- Certificate type
- Required parameters
- Signatures

---

## Network Magic Values

### Mainnet
- Magic: `764824073` (or use `--mainnet` flag)

### Testnet
- Preview: `2`
- Preprod: `1`
- Legacy: `1097911063`

---

## Era Selection

### Automatic Era Detection
The CLI can automatically detect the era based on the network and protocol parameters.

### Manual Era Selection
Use era-specific flags:
- `--byron-mode`
- `--shelley-mode`
- `--allegra-mode`
- `--mary-mode`
- `--alonzo-mode`
- `--babbage-mode`
- `--conway-mode`

Or use the `--era` flag with explicit era name.

---

## Security Best Practices

### Key Management
- Never share signing keys
- Store keys in secure, air-gapped environments
- Use hardware wallets when possible
- Backup keys securely

### Transaction Safety
- Always verify transaction details before signing
- Use `--dry-run` to test transactions without submitting
- Verify addresses before sending funds
- Keep small test transactions for validation

### Node Security
- Use secure socket paths
- Verify node connection
- Monitor for suspicious activity

---

## Troubleshooting

### Common Issues

**Socket Connection Error**
```
Error: Couldn't connect to node
```
Solution: Ensure `CARDANO_NODE_SOCKET_PATH` is set correctly and the node is running.

**Era Mismatch**
```
Error: Era mismatch
```
Solution: Use the correct era flag or let the CLI auto-detect the era.

**Invalid Key Format**
```
Error: Invalid key format
```
Solution: Ensure keys are in the correct format (Bech32 or text envelope).

**Insufficient Funds**
```
Error: Insufficient funds in UTxO
```
Solution: Check UTxO with `query utxo` and ensure sufficient balance.

---

## Additional Resources

- [Cardano Documentation](https://docs.cardano.org/)
- [Cardano GitHub](https://github.com/input-output-hk/cardano-node)
- [CIP Repository](https://github.com/cardano-foundation/CIPs)
- [Stake Pool School](https://stakepoolschool.cardano.org/)

---

## Command Reference Summary

### Quick Reference

| Category | Purpose |
|----------|---------|
| `address` | Address generation and management |
| `key` | Key generation and conversion |
| `node` | Node operator operations |
| `hash` | Hash computation |
| `query` | Node queries |
| `transaction` | Transaction building and signing |
| `stake-pool` | Stake pool operations |
| `governance` | Governance and voting |
| `byron` | Byron-era operations |
| `conway` | Conway-era operations |

---

*This documentation covers Cardano-CLI version 11.0.0.0. For the most up-to-date information, refer to the official Cardano documentation.*
