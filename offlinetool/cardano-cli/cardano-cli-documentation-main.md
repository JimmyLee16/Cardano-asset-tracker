# Cardano-CLI Documentation (Version 11.0.0.0)

**Cardano-CLI** is a general purpose command-line utility to interact with cardano-node. It provides specific commands to manage keys, addresses, build & submit transactions, certificates, etc.

## Table of Contents
1. [Main Commands](#main-commands)
2. [Address Commands](#address-commands)
3. [Key Commands](#key-commands)
4. [Node Commands](#node-commands)
5. [Hash Commands](#hash-commands)
6. [Ping Command](#ping-command)

---

## Main Commands

### Overview
```
cardano-cli.exe (address | key | node | hash | query | legacy | byron | conway | dijkstra | latest | debug commands | version | cip-format | compatible)
```

### Global Options
- `--version` - Show the cardano-cli version
- `-h,--help` - Show this help text

### Available Commands
- **address** - Payment address commands
- **key** - Key utility commands
- **node** - Node operation commands
- **hash** - Compute the hash to pass to the various --*-hash arguments of commands
- **query** - Node query commands. Will query the local node whose Unix domain socket is obtained from the CARDANO_NODE_SOCKET_PATH environment variable
- **legacy** - Legacy commands
- **byron** - Byron specific commands
- **conway** - Conway era commands
- **dijkstra** - Dijkstra era commands
- **latest** - Latest era commands (Conway)
- **debug** - Debug commands
- **help** - Show all help
- **version** - Show the cardano-cli version
- **ping** - Ping a cardano node either using node-to-node or node-to-client protocol
- **cip-format** - Group of commands related to CIP changes
- **compatible** - Limited backward compatible commands for testing only

---

## Address Commands

### Overview
```
cardano-cli.exe address (key-gen | key-hash | build | info)
```

### key-gen
Create an address key pair.

**Usage:**
```
cardano-cli.exe address key-gen [--key-output-bech32 | --key-output-text-envelope | --key-output-format STRING]
                                 [--normal-key | --extended-key | --byron-key]
                                 --verification-key-file FILEPATH
                                 --signing-key-file FILEPATH
```

**Options:**
- `--key-output-bech32` - Format key output to BECH32
- `--key-output-text-envelope` - Format key output to TEXT_ENVELOPE (default)
- `--key-output-format STRING` - Optional key output format. Accepted output formats are "text-envelope" and "bech32". The --key-output-format flag is deprecated and will be removed in a future version
- `--normal-key` - Use a normal Shelley-era key (default)
- `--extended-key` - Use an extended ed25519 Shelley-era key
- `--byron-key` - Use a Byron-era key
- `--verification-key-file FILEPATH` - Output filepath of the verification key
- `--signing-key-file FILEPATH` - Output filepath of the signing key

### key-hash
Print the hash of an address key.

**Usage:**
```
cardano-cli.exe address key-hash (--payment-verification-key STRING | --payment-verification-key-file FILEPATH) [--out-file FILEPATH]
```

**Options:**
- `--payment-verification-key STRING` - Payment verification key (Bech32-encoded)
- `--payment-verification-key-file FILEPATH` - Filepath of the payment verification key
- `--out-file FILEPATH` - Optional output file. Default is to write to stdout

### build
Build a Shelley payment address, with optional delegation to a stake address.

**Usage:**
```
cardano-cli.exe address build (--payment-verification-key STRING | --payment-verification-key-file FILEPATH | --payment-script-file FILEPATH)
                              [--stake-verification-key STRING | --stake-verification-key-file FILEPATH | --stake-key-hash HASH | --stake-script-file FILEPATH | --stake-address ADDRESS]
                              (--mainnet | --testnet-magic NATURAL)
                              [--out-file FILEPATH]
```

**Options:**
- `--payment-verification-key STRING` - Payment verification key (Bech32-encoded)
- `--payment-verification-key-file FILEPATH` - Filepath of the payment verification key
- `--payment-script-file FILEPATH` - Filepath of the payment script
- `--stake-verification-key STRING` - Stake verification key (Bech32 or hex-encoded)
- `--stake-verification-key-file FILEPATH` - Filepath of the staking verification key
- `--stake-key-hash HASH` - Stake verification key hash (hex-encoded)
- `--stake-script-file FILEPATH` - Filepath of the staking script
- `--stake-address ADDRESS` - Target stake address (bech32 format)
- `--mainnet` - Use the mainnet magic id. This overrides the CARDANO_NODE_NETWORK_ID environment variable
- `--testnet-magic NATURAL` - Specify a testnet magic id. This overrides the CARDANO_NODE_NETWORK_ID environment variable
- `--out-file FILEPATH` - Optional output file. Default is to write to stdout

### info
Print information about an address.

**Usage:**
```
cardano-cli.exe address info --address ADDRESS [--out-file FILEPATH]
```

**Options:**
- `--address ADDRESS` - A Cardano address
- `--out-file FILEPATH` - Optional output file. Default is to write to stdout

---

## Key Commands

### Overview
```
cardano-cli.exe key (verification-key | non-extended-key | generate-mnemonic | derive-from-mnemonic | convert-byron-key | convert-byron-genesis-vkey | convert-itn-key | convert-itn-extended-key | convert-itn-bip32-key | convert-cardano-address-key)
```

### verification-key
Get a verification key from a signing key. This supports all key types.

**Usage:**
```
cardano-cli.exe key verification-key --signing-key-file FILEPATH --verification-key-file FILEPATH
```

**Options:**
- `--signing-key-file FILEPATH` - Input filepath of the signing key
- `--verification-key-file FILEPATH` - Output filepath of the verification key

### non-extended-key
Get a non-extended verification key from an extended verification key. This supports all extended key types.

**Usage:**
```
cardano-cli.exe key non-extended-key --extended-verification-key-file FILEPATH --verification-key-file FILEPATH
```

**Options:**
- `--extended-verification-key-file FILEPATH` - Input filepath of the ed25519-bip32 verification key
- `--verification-key-file FILEPATH` - Output filepath of the verification key

### generate-mnemonic
Generate a mnemonic sentence that can be used for key derivation.

**Usage:**
```
cardano-cli.exe key generate-mnemonic [--out-file FILEPATH] --size WORD32
```

**Options:**
- `--out-file FILEPATH` - The output file
- `--size WORD32` - Specify the desired number of words for the output mnemonic sentence (valid options are: 12, 15, 18, 21, and 24)

### derive-from-mnemonic
Derive an extended signing key from a mnemonic sentence. To ensure the safety of the mnemonic phrase, we recommend that key derivation is performed in an air-gapped environment.

**Usage:**
```
cardano-cli.exe key derive-from-mnemonic [--key-output-bech32 | --key-output-text-envelope | --key-output-format STRING]
                                        (--payment-key-with-number WORD32 | --stake-key-with-number WORD32 | --drep-key | --cc-cold-key | --cc-hot-key)
                                        --account-number WORD32
                                        (--mnemonic-from-file FILEPATH | --mnemonic-from-interactive-prompt)
                                        --signing-key-file FILEPATH
```

**Options:**
- `--key-output-bech32` - Format key output to BECH32
- `--key-output-text-envelope` - Format key output to TEXT_ENVELOPE (default)
- `--key-output-format STRING` - Optional key output format. Accepted output formats are "text-envelope" and "bech32". The --key-output-format flag is deprecated and will be removed in a future version
- `--payment-key-with-number WORD32` - Derive an extended payment key with the given payment address number from the derivation path
- `--stake-key-with-number WORD32` - Derive an extended stake key with the given stake address number from the derivation path
- `--drep-key` - Derive an extended DRep key
- `--cc-cold-key` - Derive an extended committee cold key
- `--cc-hot-key` - Derive an extended committee hot key
- `--account-number WORD32` - Account number in the derivation path
- `--mnemonic-from-file FILEPATH` - Input text file with the mnemonic
- `--mnemonic-from-interactive-prompt` - Input the mnemonic through an interactive prompt. This mode also accepts receiving the mnemonic through standard input directly, for example, by using a pipe
- `--signing-key-file FILEPATH` - Output filepath of the signing key

### convert-byron-key
Convert a Byron payment, genesis or genesis delegate key (signing or verification) to a corresponding Shelley-format key.

**Usage:**
```
cardano-cli.exe key convert-byron-key [--password TEXT]
                                        ( --byron-payment-key-type
                                        | --legacy-byron-payment-key-type
                                        | --byron-genesis-key-type
                                        | --legacy-byron-genesis-key-type
                                        | --byron-genesis-delegate-key-type
                                        | --legacy-byron-genesis-delegate-key-type
                                        )
                                        (--byron-signing-key-file FILEPATH | --byron-verification-key-file FILEPATH)
                                        --out-file FILEPATH
```

**Options:**
- `--password TEXT` - Password for signing key (if applicable)
- `--byron-payment-key-type` - Use a Byron-era payment key
- `--legacy-byron-payment-key-type` - Use a Byron-era payment key, in legacy SL format
- `--byron-genesis-key-type` - Use a Byron-era genesis key
- `--legacy-byron-genesis-key-type` - Use a Byron-era genesis key, in legacy SL format
- `--byron-genesis-delegate-key-type` - Use a Byron-era genesis delegate key
- `--legacy-byron-genesis-delegate-key-type` - Use a Byron-era genesis delegate key, in legacy SL format
- `--byron-signing-key-file FILEPATH` - Input filepath of the Byron-format signing key
- `--byron-verification-key-file FILEPATH` - Input filepath of the Byron-format verification key
- `--out-file FILEPATH` - The output file

### convert-byron-genesis-vkey
Convert a Base64-encoded Byron genesis verification key to a Shelley genesis verification key

**Usage:**
```
cardano-cli.exe key convert-byron-genesis-vkey --byron-genesis-verification-key BASE64 --out-file FILEPATH
```

**Options:**
- `--byron-genesis-verification-key BASE64` - Base64 string for the Byron genesis verification key
- `--out-file FILEPATH` - The output file

### convert-itn-key
Convert an Incentivized Testnet (ITN) non-extended (Ed25519) signing or verification key to a corresponding Shelley stake key

**Usage:**
```
cardano-cli.exe key convert-itn-key (--itn-signing-key-file FILEPATH | --itn-verification-key-file FILEPATH) --out-file FILEPATH
```

**Options:**
- `--itn-signing-key-file FILEPATH` - Filepath of the ITN signing key
- `--itn-verification-key-file FILEPATH` - Filepath of the ITN verification key
- `--out-file FILEPATH` - The output file

### convert-itn-extended-key
Convert an Incentivized Testnet (ITN) extended (Ed25519Extended) signing key to a corresponding Shelley stake signing key

**Usage:**
```
cardano-cli.exe key convert-itn-extended-key --itn-signing-key-file FILEPATH --out-file FILEPATH
```

**Options:**
- `--itn-signing-key-file FILEPATH` - Filepath of the ITN signing key
- `--out-file FILEPATH` - The output file

### convert-itn-bip32-key
Convert an Incentivized Testnet (ITN) BIP32 (Ed25519Bip32) signing key to a corresponding Shelley stake signing key

**Usage:**
```
cardano-cli.exe key convert-itn-bip32-key --itn-signing-key-file FILEPATH --out-file FILEPATH
```

**Options:**
- `--itn-signing-key-file FILEPATH` - Filepath of the ITN signing key
- `--out-file FILEPATH` - The output file

### convert-cardano-address-key
Convert a cardano-address extended signing key to a corresponding Shelley-format key.

**Usage:**
```
cardano-cli.exe key convert-cardano-address-key (--cc-cold-key | --cc-hot-key | --drep-key | --shelley-payment-key | --shelley-stake-key | --icarus-payment-key | --byron-payment-key)
                                                --signing-key-file FILEPATH
                                                --out-file FILEPATH
```

**Options:**
- `--cc-cold-key` - Use a committee cold key
- `--cc-hot-key` - Use a committee hot key
- `--drep-key` - Use a DRep key
- `--shelley-payment-key` - Use a Shelley-era extended payment key
- `--shelley-stake-key` - Use a Shelley-era extended stake key
- `--icarus-payment-key` - Use a Byron-era extended payment key formatted in the Icarus style
- `--byron-payment-key` - Use a Byron-era extended payment key formatted in the deprecated Byron style
- `--signing-key-file FILEPATH` - Input filepath of the signing key
- `--out-file FILEPATH` - The output file

---

## Node Commands

### Overview
```
cardano-cli.exe node (key-gen | key-gen-KES | key-gen-VRF | key-hash-VRF | new-counter | issue-op-cert)
```

### key-gen
Create a key pair for a node operator's offline key and a new certificate issue counter

**Usage:**
```
cardano-cli.exe node key-gen [--key-output-bech32 | --key-output-text-envelope | --key-output-format STRING]
                              --cold-verification-key-file FILEPATH
                              --cold-signing-key-file FILEPATH
                              --operational-certificate-issue-counter-file FILEPATH
```

**Options:**
- `--key-output-bech32` - Format key output to BECH32
- `--key-output-text-envelope` - Format key output to TEXT_ENVELOPE (default)
- `--key-output-format STRING` - Optional key output format. Accepted output formats are "text-envelope" and "bech32". The --key-output-format flag is deprecated and will be removed in a future version
- `--cold-verification-key-file FILEPATH` - Filepath of the cold verification key
- `--cold-signing-key FILEPATH` - Filepath of the cold signing key
- `--operational-certificate-issue-counter-file FILEPATH` - The file with the issue counter for the operational certificate

### key-gen-KES
Create a key pair for a node KES operational key

**Usage:**
```
cardano-cli.exe node key-gen-KES [--key-output-bech32 | --key-output-text-envelope | --key-output-format STRING] --verification-key-file FILEPATH --signing-key-file FILEPATH
```

**Options:**
- `--key-output-bech32` - Format key output to BECH32
- `--key-output-text-envelope` - Format key output to TEXT_ENVELOPE (default)
- `--key-output-format STRING` - Optional key output format. Accepted output formats are "text-envelope" and "bech32". The --key-output-format flag is deprecated and will be removed in a future version
- `--verification-key-file FILEPATH` - Output filepath of the verification key
- `--signing-key-file FILEPATH` - Output filepath of the signing key

### key-gen-VRF
Create a key pair for a node VRF operational key

**Usage:**
```
cardano-cli.exe node key-gen-VRF [--key-output-bech32 | --key-output-text-envelope | --key-output-format STRING] --verification-key-file FILEPATH --signing-key-file FILEPATH
```

**Options:**
- `--key-output-bech32` - Format key output to BECH32
- `--key-output-text-envelope` - Format key output to TEXT_ENVELOPE (default)
- `--key-output-format STRING` - Optional key output format. Accepted output formats are "text-envelope" and "bech32". The --key-output-format flag is deprecated and will be removed in a future version
- `--verification-key-file FILEPATH` - Output filepath of the verification key
- `--signing-key-file FILEPATH` - Output filepath of the signing key

### key-hash-VRF
Print hash of a node's operational VRF key.

**Usage:**
```
cardano-cli.exe node key-hash-VRF (--verification-key STRING | --verification-key-file FILEPATH) [--out-file FILEPATH]
```

**Options:**
- `--verification-key STRING` - Verification key (Bech32 or hex-encoded)
- `--verification-key-file FILEPATH` - Input filepath of the verification key
- `--out-file FILEPATH` - Optional output file. Default is to write to stdout

### new-counter
Create a new certificate issue counter

**Usage:**
```
cardano-cli.exe node new-counter ( --stake-pool-verification-key STRING
                                  | --stake-pool-verification-extended-key STRING
                                  | --genesis-delegate-verification-key STRING
                                  | --cold-verification-key-file FILEPATH
                                  )
                                  --counter-value INT
                                  --operational-certificate-issue-counter-file FILEPATH
```

**Options:**
- `--stake-pool-verification-key STRING` - Stake pool verification key (Bech32 or hex-encoded)
- `--stake-pool-verification-extended-key STRING` - Stake pool verification extended key (Bech32 or hex-encoded)
- `--genesis-delegate-verification-key STRING` - Genesis delegate verification key (hex-encoded)
- `--cold-verification-key-file FILEPATH` - Filepath of the cold verification key
- `--counter-value INT` - The next certificate issue counter value to use
- `--operational-certificate-issue-counter-file FILEPATH` - The file with the issue counter for the operational certificate

### issue-op-cert
Issue a node operational certificate

**Usage:**
```
cardano-cli.exe node issue-op-cert (--kes-verification-key STRING | --kes-verification-key-file FILEPATH)
                                    --cold-signing-key-file FILEPATH
                                    --operational-certificate-issue-counter-file FILEPATH
                                    --kes-period NATURAL
                                    --out-file FILEPATH
```

**Options:**
- `--kes-verification-key STRING` - A Bech32 or hex-encoded hot KES verification key
- `--kes-verification-key-file FILEPATH` - Filepath of the hot KES verification key
- `--cold-signing-key-file FILEPATH` - Filepath of the cold signing key
- `--operational-certificate-issue-counter-file FILEPATH` - The file with the issue counter for the operational certificate
- `--kes-period NATURAL` - The start of the KES key validity period
- `--out-file FILEPATH` - The output file

---

## Hash Commands

### Overview
```
cardano-cli.exe hash (anchor-data | script | genesis-file)
```

### anchor-data
Compute the hash of some anchor data (to then pass it to other commands).

**Usage:**
```
cardano-cli.exe hash anchor-data (--text TEXT | --file-binary FILEPATH | --file-text FILEPATH | --url TEXT) [--expected-hash HASH | --out-file FILEPATH]
```

**Options:**
- `--text TEXT` - Text to hash as UTF-8
- `--file-binary FILEPATH` - Binary file to hash
- `--file-text FILEPATH` - Text file to hash
- `--url TEXT` - A URL to the file to hash (HTTP(S) and IPFS only)
- `--expected-hash HASH` - Expected hash for the anchor data, for verification purposes. If provided, the hash of the anchor data will be compared to this value
- `--out-file FILEPATH` - The output file

### script
Compute the hash of a script (to then pass it to other commands).

**Usage:**
```
cardano-cli.exe hash script --script-file FILEPATH [--out-file FILEPATH]
```

**Options:**
- `--script-file FILEPATH` - Filepath of the script
- `--out-file FILEPATH` - The output file

### genesis-file
Compute the hash of a genesis file.

**Usage:**
```
cardano-cli.exe hash genesis-file --genesis FILEPATH
```

**Options:**
- `--genesis FILEPATH` - The genesis file

---

## Ping Command

### Overview
```
cardano-cli.exe ping [-c|--count COUNT] ((-h|--host HOST) | (-u|--unixsock SOCKET)) [-p|--port PORT] [-m|--magic MAGIC] [-j|--json] [-q|--quiet] [-Q|--query-versions] [-t|--tip]
```

### Description
Ping a cardano node either using node-to-node or node-to-client protocol. It negotiates a handshake and keeps sending keep alive messages.

**Options:**
- `-c,--count COUNT` - Stop after sending count requests and receiving count responses. If this option is not specified, ping will operate until interrupted
- `-h,--host HOST` - Hostname/IP, e.g. relay.iohk.example
- `-u,--unixsock SOCKET` - Unix socket, e.g. file.socket
- `-p,--port PORT` - Port number, e.g. 1234
- `-m,--magic MAGIC` - Network magic
- `-j,--json` - JSON output flag
- `-q,--quiet` - Quiet flag, CSV/JSON only output
- `-Q,--query-versions` - Query the supported protocol versions using the handshake protocol and terminate the connection
- `-t,--tip` - Request tip then exit
