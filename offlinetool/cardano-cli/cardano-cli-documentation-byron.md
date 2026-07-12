# Cardano-CLI Documentation - Byron Era Commands (Version 11.0.0.0)

## Byron Era Commands

### Overview
```
cardano-cli.exe byron (key | transaction | genesis | governance | miscellaneous)
```

Byron era is the original era of Cardano. These commands handle Byron-specific operations. Most Byron operations are deprecated in favor of Shelley and later era commands. Use these only when specifically working with Byron-era data or nodes.

---

## Byron Key Commands

### Overview
```
cardano-cli.exe byron key (keygen | to-verification | signing-key-public | signing-key-address | migrate-delegate-key-from)
```

### keygen
Generate a Byron signing key.

**Usage:**
```
cardano-cli.exe byron key keygen --verification-key-file FILEPATH --signing-key-file FILEPATH
```

**Options:**
- `--verification-key-file FILEPATH` - Output filepath of the verification key
- `--signing-key-file FILEPATH` - Output filepath of the signing key

### to-verification
Extract a verification key in its base64 form.

**Usage:**
```
cardano-cli.exe byron key to-verification --signing-key-file FILEPATH --out-file FILEPATH
```

**Options:**
- `--signing-key-file FILEPATH` - Input filepath of the signing key
- `--out-file FILEPATH` - Output file for the verification key

### signing-key-public
Pretty-print a signing key's verification key (not a secret).

**Usage:**
```
cardano-cli.exe byron key signing-key-public --signing-key-file FILEPATH
```

**Options:**
- `--signing-key-file FILEPATH` - Input filepath of the signing key

### signing-key-address
Print address of a signing key.

**Usage:**
```
cardano-cli.exe byron key signing-key-address --signing-key-file FILEPATH [--out-file FILEPATH]
```

**Options:**
- `--signing-key-file FILEPATH` - Input filepath of the signing key
- `--out-file FILEPATH` - Optional output file

### migrate-delegate-key-from
Migrate a delegate key from an older version.

**Usage:**
```
cardano-cli.exe byron key migrate-delegate-key-from --input-file FILEPATH --out-file FILEPATH
```

**Options:**
- `--input-file FILEPATH` - Input file with the old delegate key
- `--out-file FILEPATH` - Output file for the migrated key

---

## Byron Transaction Commands

### Overview
```
cardano-cli.exe byron transaction (submit-tx | issue-genesis-utxo-expenditure | issue-utxo-expenditure | txid)
```

### submit-tx
Submit a raw, signed transaction, in its on-wire representation.

**Usage:**
```
cardano-cli.exe byron transaction submit-tx --tx-file FILEPATH (--socket-path FILEPATH | --host HOST --port PORT)
```

**Options:**
- `--tx-file FILEPATH` - The transaction file to submit
- `--socket-path FILEPATH` - Path to the node socket
- `--host HOST` - Node hostname
- `--port PORT` - Node port

### issue-genesis-utxo-expenditure
Write a file with a signed transaction, spending genesis UTxO.

**Usage:**
```
cardano-cli.exe byron transaction issue-genesis-utxo-expenditure --tx-in TXIN
                                                                --tx-out ADDRESS+LOVELACE
                                                                --genesis-verification-key-file FILEPATH
                                                                --signing-key-file FILEPATH
                                                                --out-file FILEPATH
```

**Options:**
- `--tx-in TXIN` - Transaction input to spend
- `--tx-out ADDRESS+LOVELACE` - Transaction output
- `--genesis-verification-key-file FILEPATH` - Genesis verification key file
- `--signing-key-file FILEPATH` - Signing key file
- `--out-file FILEPATH` - Output transaction file

### issue-utxo-expenditure
Write a file with a signed transaction, spending normal UTxO.

**Usage:**
```
cardano-cli.exe byron transaction issue-utxo-expenditure --tx-in TXIN
                                                         --tx-out ADDRESS+LOVELACE
                                                         --signing-key-file FILEPATH
                                                         --out-file FILEPATH
```

**Options:**
- `--tx-in TXIN` - Transaction input to spend
- `--tx-out ADDRESS+LOVELACE` - Transaction output
- `--signing-key-file FILEPATH` - Signing key file
- `--out-file FILEPATH` - Output transaction file

### txid
Print the txid of a raw, signed transaction.

**Usage:**
```
cardano-cli.exe byron transaction txid --tx-file FILEPATH
```

**Options:**
- `--tx-file FILEPATH` - The transaction file

---

## Byron Genesis Commands

### Overview
```
cardano-cli.exe byron genesis (genesis | print-genesis-hash)
```

### genesis
Create Byron genesis.

**Usage:**
```
cardano-cli.exe byron genesis genesis --genesis-dir DIRECTORY
                                      --protocol-parameters-file FILEPATH
                                      --start-time NATURAL
                                      --n-delegate-count INT
                                      --n-dark-pool-count INT
                                      --total-balance LOVELACE
                                      --delegate-share FRACTION
                                      --avvm-entry-count INT
                                      --avvm-entry-balance LOVELACE
```

**Options:**
- `--genesis-dir DIRECTORY` - Directory for genesis files
- `--protocol-parameters-file FILEPATH` - Protocol parameters file
- `--start-time NATURAL` - Start time for the genesis
- `--n-delegate-count INT` - Number of delegates
- `--n-dark-pool-count INT` - Number of dark pools
- `--total-balance LOVELACE` - Total balance
- `--delegate-share FRACTION` - Delegate share
- `--avvm-entry-count INT` - AVVM entry count
- `--avvm-entry-balance LOVELACE` - AVVM entry balance

### print-genesis-hash
Compute hash of a genesis file.

**Usage:**
```
cardano-cli.exe byron genesis print-genesis-hash --genesis FILEPATH
```

**Options:**
- `--genesis FILEPATH` - The genesis file

---

## Byron Governance Commands

### Overview
```
cardano-cli.exe byron governance (...)
```

Byron governance commands handle Byron-era governance operations. These are largely superseded by Conway-era governance commands.

---

## Byron Miscellaneous Commands

### Overview
```
cardano-cli.exe byron miscellaneous (validate-cbor | pretty-print-cbor)
```

### validate-cbor
Validate a CBOR blockchain object.

**Usage:**
```
cardano-cli.exe byron miscellaneous validate-cbor --cbor-in FILEPATH
```

**Options:**
- `--cbor-in FILEPATH` - Input CBOR file to validate

### pretty-print-cbor
Pretty print a CBOR file.

**Usage:**
```
cardano-cli.exe byron miscellaneous pretty-print-cbor --cbor-in FILEPATH [--out-file FILEPATH]
```

**Options:**
- `--cbor-in FILEPATH` - Input CBOR file
- `--out-file FILEPATH` - Optional output file

---

## Byron Era Notes

### Migration to Shelley
Byron-era keys and addresses can be migrated to Shelley format using the main `key` commands:
- `cardano-cli key convert-byron-key` - Convert Byron keys to Shelley format
- `cardano-cli key convert-byron-genesis-vkey` - Convert Byron genesis verification keys

### Deprecated Status
Most Byron commands are deprecated and should only be used for:
- Historical data analysis
- Interacting with legacy Byron nodes
- Testing and compatibility checks

For new implementations, use Shelley, Allegra, Mary, Alonzo, Babbage, or Conway era commands.

---

*This documentation covers Byron era commands for Cardano-CLI version 11.0.0.0.*
