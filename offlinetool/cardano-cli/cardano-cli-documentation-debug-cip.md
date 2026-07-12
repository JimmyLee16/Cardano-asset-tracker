# Cardano-CLI Documentation - Debug and CIP Commands (Version 11.0.0.0)

## Debug Commands

### Overview
```
cardano-cli.exe debug (log-epoch-state | check-node-configuration | transaction)
```

Debug commands are used for development, troubleshooting, and node analysis purposes.

---

### log-epoch-state
Log epoch state of a running node. This command will connect to a local node and log the epoch state to a file. The log file format is line delimited JSON. The command will not terminate.

**Usage:**
```
cardano-cli.exe debug log-epoch-state --socket-path SOCKET_PATH
                                      --node-configuration-file FILEPATH
                                      --out-file FILEPATH
```

**Options:**
- `--socket-path SOCKET_PATH` - Path to the node socket. This overrides the CARDANO_NODE_SOCKET_PATH environment variable. The argument is optional if CARDANO_NODE_SOCKET_PATH is defined and mandatory otherwise.
- `--node-configuration-file FILEPATH` - Input filepath of the node configuration file.
- `--out-file FILEPATH` - Output filepath of the log file. The log file format is line delimited JSON.

**Example:**
```bash
cardano-cli.exe debug log-epoch-state \
  --socket-path /path/to/node.socket \
  --node-configuration-file config.json \
  --out-file epoch-state.log
```

**Note:** This command runs continuously and will not terminate until manually stopped. Use Ctrl+C to stop it.

---

### check-node-configuration
Check hashes and paths of genesis files in the given node configuration file.

**Usage:**
```
cardano-cli.exe debug check-node-configuration --node-configuration-file FILEPATH
```

**Options:**
- `--node-configuration-file FILEPATH` - Input filepath of the node configuration file.

**Example:**
```bash
cardano-cli.exe debug check-node-configuration --node-configuration-file config.json
```

**Purpose:** This command validates that the genesis files referenced in the node configuration exist and have the correct hashes. It's useful for ensuring node configuration integrity before starting a node.

---

### transaction
Debug transaction commands for analyzing and troubleshooting transactions.

**Usage:**
```
cardano-cli.exe debug transaction (...)
```

Transaction debug commands provide tools for:
- Analyzing transaction structure
- Validating transaction formats
- Debugging transaction submission issues
- Inspecting transaction witnesses

---

## CIP Format Commands

### Overview
```
cardano-cli.exe cip-format cip-129 (drep | committee-hot-key | committee-cold-key | governance-action-id)
```

CIP (Cardano Improvement Proposal) format commands handle operations related to CIP changes. CIP-129 provides modified binary encoding for governance-related keys and actions.

**Reference:** https://github.com/cardano-foundation/CIPs/tree/master/CIP-0129

---

### drep
Convert DRep verification key to the CIP-129 compliant format.

**Usage:**
```
cardano-cli.exe cip-format cip-129 drep --drep-verification-key-file FILEPATH --out-file FILEPATH
```

**Options:**
- `--drep-verification-key-file FILEPATH` - Input DRep verification key file
- `--out-file FILEPATH` - Output file for CIP-129 compliant format

**Purpose:** Converts DRep (Delegate Representative) verification keys to the standardized CIP-129 binary encoding format for interoperability.

---

### committee-hot-key
Convert committee hot key to the CIP-129 compliant format.

**Usage:**
```
cardano-cli.exe cip-format cip-129 committee-hot-key --committee-hot-verification-key-file FILEPATH --out-file FILEPATH
```

**Options:**
- `--committee-hot-verification-key-file FILEPATH` - Input committee hot verification key file
- `--out-file FILEPATH` - Output file for CIP-129 compliant format

**Purpose:** Converts Constitutional Committee hot keys to the CIP-129 standard format.

---

### committee-cold-key
Convert committee cold key to the CIP-129 compliant format.

**Usage:**
```
cardano-cli.exe cip-format cip-129 committee-cold-key --committee-cold-verification-key-file FILEPATH --out-file FILEPATH
```

**Options:**
- `--committee-cold-verification-key-file FILEPATH` - Input committee cold verification key file
- `--out-file FILEPATH` - Output file for CIP-129 compliant format

**Purpose:** Converts Constitutional Committee cold keys to the CIP-129 standard format.

---

### governance-action-id
Convert governance action ID to the CIP-129 compliant format.

**Usage:**
```
cardano-cli.exe cip-format cip-129 governance-action-id --governance-action-id GOVACTIONID --out-file FILEPATH
```

**Options:**
- `--governance-action-id GOVACTIONID` - Governance action ID to convert
- `--out-file FILEPATH` - Output file for CIP-129 compliant format

**Purpose:** Converts governance action identifiers to the CIP-129 standard format for consistent encoding across tools and platforms.

---

## CIP-129 Overview

### What is CIP-129?
CIP-129 defines a modified binary encoding scheme for:
- DRep keys
- Constitutional Committee cold and hot keys
- Governance actions

### Why Use CIP-129?
- **Standardization:** Provides a consistent encoding format across different Cardano tools
- **Interoperability:** Ensures keys and actions can be shared between different implementations
- **Future-proofing:** Establishes a standard for governance-related encoding

### When to Use CIP-129 Commands
Use these commands when:
- Integrating with external tools that expect CIP-129 format
- Sharing governance keys or actions with other systems
- Ensuring compatibility with future Cardano governance standards

---

## Compatible Commands

### Overview
```
cardano-cli.exe compatible (...)
```

Compatible commands provide limited backward compatibility for testing purposes only. These are not intended for production use.

**Note:** These commands are deprecated and should only be used for testing legacy functionality. For production use, use the standard era-specific commands.

---

## Debugging Best Practices

### Using log-epoch-state
1. **Run during node operation:** Start the command while the node is running to capture real-time epoch state changes
2. **Monitor file size:** The log file can grow large over time; monitor disk space
3. **Use for analysis:** Parse the JSON output to analyze epoch transitions, stake distribution changes, and other state transitions

### Using check-node-configuration
1. **Before node start:** Run this command before starting a node to catch configuration errors early
2. **After configuration changes:** Re-run after modifying node configuration to ensure validity
3. **Troubleshooting:** Use when node fails to start due to genesis file issues

### Using CIP-129 Commands
1. **Format conversion:** Use when integrating with tools that require CIP-129 format
2. **Testing:** Verify encoding compatibility before deploying governance actions
3. **Documentation:** Keep records of both original and CIP-129 formatted keys for reference

---

## Debug Use Cases

### Epoch State Analysis
Monitor epoch transitions and state changes:
```bash
cardano-cli.exe debug log-epoch-state \
  --socket-path $CARDANO_NODE_SOCKET_PATH \
  --node-configuration-file config.json \
  --out-file epoch-analysis.log
```

### Configuration Validation
Validate node setup before deployment:
```bash
cardano-cli.exe debug check-node-configuration \
  --node-configuration-file config.json
```

### Governance Key Standardization
Convert governance keys to standard format:
```bash
cardano-cli.exe cip-format cip-129 drep \
  --drep-verification-key-file drep.vkey \
  --out-file drep-cip129.vkey
```

---

## Troubleshooting

### log-epoch-state Issues

**Connection Failed**
```
Error: Couldn't connect to node
```
Solution: Ensure the node is running and the socket path is correct.

**Permission Denied**
```
Error: Permission denied on socket
```
Solution: Check file permissions on the node socket file.

### check-node-configuration Issues

**Genesis File Not Found**
```
Error: Genesis file not found
```
Solution: Verify paths in the configuration file are correct and files exist.

**Hash Mismatch**
```
Error: Genesis file hash mismatch
```
Solution: Re-download or regenerate the genesis files with correct hashes.

### CIP-129 Conversion Issues

**Invalid Key Format**
```
Error: Invalid key format
```
Solution: Ensure the input key file is in the correct format (text envelope or Bech32).

**Conversion Failed**
```
Error: Conversion failed
```
Solution: Verify the key type matches the conversion command (e.g., use committee-cold-key for cold keys only).

---

## Additional Resources

- [CIP-129 Specification](https://github.com/cardano-foundation/CIPs/tree/master/CIP-0129)
- [Cardano Node Configuration](https://docs.cardano.org/getting-started/installing-cardano-node)
- [Debugging Guide](https://docs.cardano.org/developer-resources/cardano-cli-and-node/)

---

*This documentation covers Debug and CIP format commands for Cardano-CLI version 11.0.0.0.*
