# Cardano CLI MCP Server & Skills

MCP server wrapping `cardano-cli.exe` v11.0.0.0 plus workflow skills for common Cardano operations.

## Structure

```
cardano-cli-11.0.0.0-win64/
├── cardano-cli.exe              # The CLI binary
├── cardano-cli-mcp/             # MCP Server (Python)
│   ├── server.py                # Main MCP server — 40+ tools
│   ├── config.py                # Configuration (CLI path, network, workspace)
│   ├── cardano_cli.py           # Subprocess wrapper utility
│   └── requirements.txt         # Python dependencies
├── workflows/            # Skills / Workflows
│   ├── create-wallet.md         # Generate wallet from mnemonic
│   ├── build-and-sign-tx.md     # Build, sign, submit transactions
│   ├── register-staking.md      # Register stake + delegate to pool
│   ├── governance-vote.md       # DRep registration, voting, delegation
│   ├── mint-tokens.md           # Mint native tokens / NFTs
│   └── stake-pool-setup.md      # Full stake pool setup
└── workspace/                   # Generated key/tx files (auto-created)
```

## MCP Server Setup

### 1. Install Python dependencies

```bash
pip install mcp
```

### 2. Configure in Cursor / Claude Desktop / VS Code

A ready-to-use config file is at `mcp-config.json` in the project root. It uses **relative paths** so it works on any machine:

```json
{
  "mcpServers": {
    "cardano-cli": {
      "command": "python",
      "args": ["./cardano-cli-mcp/server.py"],
      "env": {
        "CARDANO_CLI_PATH": "./cardano-cli.exe",
        "CARDANO_NETWORK": "mainnet",
        "CARDANO_WORKSPACE": "./workspace"
      }
    }
  }
}
```

**Usage:** Copy the content of `mcp-config.json` into your MCP client's config, or merge the `cardano-cli` entry into your existing `mcpServers` object. Adjust paths to absolute if your MCP client requires it.

### 3. Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CARDANO_CLI_PATH` | `../cardano-cli.exe` | Path to cardano-cli.exe |
| `CARDANO_NETWORK` | `mainnet` | `mainnet` or `testnet` |
| `CARDANO_TESTNET_MAGIC` | `2` | Testnet magic (2=preview, 1=preprod) |
| `CARDANO_WORKSPACE` | `../workspace` | Directory for generated files |

### 4. Available MCP Tools (55+)

**Address:** `address_key_gen`, `address_key_hash`, `address_build`, `address_info`

**Key:** `key_generate_mnemonic`, `key_derive_from_mnemonic`, `key_verification_key`, `key_non_extended_key`

**Stake Address:** `stake_address_key_gen`, `stake_address_build`, `stake_address_registration_cert`, `stake_address_deregistration_cert`, `stake_delegation_cert`, `vote_delegation_cert`

**Transaction:** `transaction_build`, `transaction_build_raw`, `transaction_sign`, `transaction_witness`, `transaction_assemble`, `transaction_txid`, `transaction_policyid`, `transaction_calculate_min_fee`, `transaction_calculate_min_required_utxo`, `transaction_hash_script_data`

**Governance DRep:** `drep_key_gen`, `drep_id`, `drep_registration_cert`, `drep_retirement_cert`, `drep_update_cert`, `drep_metadata_hash`

**Governance Vote:** `governance_vote_create`, `governance_vote_view`

**Governance Action:** `governance_action_create_info`, `governance_action_view`

**Stake Pool:** `stake_pool_id`, `stake_pool_metadata_hash`, `stake_pool_registration_cert`, `stake_pool_deregistration_cert`

**Node Keys:** `node_key_gen`, `node_key_gen_kes`, `node_key_gen_vrf`, `node_issue_op_cert`

**Multi-Sig (Native Scripts):** `create_multisig_script`, `create_time_locked_multisig_script`, `multisig_address_build`, `multisig_transaction_build`, `multisig_transaction_build_raw`, `get_key_hashes`, `script_hash`

**Hash:** `hash_anchor_data`, `hash_script`, `hash_genesis_file`

**Utility:** `cli_version`, `list_workspace_files`, `read_workspace_file`

## Skills / Workflows

Use slash commands in Windsurf to trigger workflows:

| Command | Description |
|---------|-------------|
| `/create-wallet` | Generate mnemonic, payment/stake keys, addresses |
| `/build-and-sign-tx` | Build, sign, and prepare transaction for submission |
| `/register-staking` | Register stake address + delegate to pool |
| `/governance-vote` | DRep registration, vote delegation, voting on actions |
| `/mint-tokens` | Mint native tokens / NFTs with time-locked policy |
| `/stake-pool-setup` | Full stake pool key generation and registration |
| `/create-multisig` | M-of-N multi-sig address, partial signing, time-locks |

## Quick Test

```bash
# Test the CLI directly
cardano-cli.exe version

# Test the MCP server
cd cardano-cli-mcp
python server.py
```

## Security

- **Never share** `.skey` files or `mnemonic.txt`
- Keep signing keys on air-gapped machines for production
- The MCP server stores all generated files in the workspace directory
- Review all transaction details before signing
- This tool does NOT submit transactions (no node required for all operations except `submit`)

## Limitations

- `transaction build` (auto-fee) requires protocol parameters or node access
- `transaction submit` requires a running node
- All `query` commands require a running node
- Use `transaction build-raw` + `calculate-min-fee` for fully offline operation
