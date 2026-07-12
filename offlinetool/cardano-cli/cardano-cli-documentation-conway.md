# Cardano-CLI Documentation - Conway Era Commands (Version 11.0.0.0)

## Conway Era Commands

### Overview
```
cardano-cli.exe conway (address | key | genesis | governance | node | query | stake-address | stake-pool | text-view | transaction)
```

Conway era is the latest governance-focused era of Cardano, introducing on-chain governance, DReps (Delegate Representatives), constitutional committees, and advanced voting mechanisms.

---

## Transaction Commands

### Overview
```
cardano-cli.exe conway transaction (build-raw | build | build-estimate | sign | witness | assemble | submit | policyid | calculate-min-fee | calculate-min-required-utxo | calculate-plutus-script-cost | hash-script-data | txid)
```

### build-raw
Build a transaction (low-level, inconvenient). This command requires manual fee calculation and is not recommended for general use.

**Usage:**
```
cardano-cli.exe conway transaction build-raw [--alonzo-era | --babbage-era | --conway-era]
                                             [--out-file FILEPATH]
                                             --fee LOVELACE
                                             --tx-in TXIN
                                             --tx-out ADDRESS+LOVELACE
                                             [--tx-in-collateral TXIN]
                                             [--tx-in-script-file FILEPATH]
                                             [--tx-in-datum-file FILEPATH]
                                             [--tx-in-redeemer-file FILEPATH]
                                             [--tx-in-execution-units (MEMORY,STEPS)]
                                             [--required-signer-hash HASH]
                                             [--mint STRING+LOVELACE]
                                             [--minting-policy-file FILEPATH]
                                             [--minting-policy-script-file FILEPATH]
                                             [--mint-redeemer-file FILEPATH]
                                             [--mint-execution-units (MEMORY,STEPS)]
                                             [--certificate-file FILEPATH]
                                             [--metadata-json-file FILEPATH]
                                             [--metadata-json-string STRING]
                                             [--auxiliary-script-file FILEPATH]
```

### build
Build a balanced transaction (automatically calculates fees). This is the recommended way to build transactions.

**Usage:**
```
cardano-cli.exe conway transaction build [--alonzo-era | --babbage-era | --conway-era]
                                         [--out-file FILEPATH]
                                         [--change-address ADDRESS]
                                         [--tx-in TXIN]
                                         [--tx-out ADDRESS+LOVELACE]
                                         [--tx-in-collateral TXIN]
                                         [--tx-in-script-file FILEPATH]
                                         [--tx-in-datum-file FILEPATH]
                                         [--tx-in-redeemer-file FILEPATH]
                                         [--tx-in-execution-units (MEMORY,STEPS)]
                                         [--required-signer-hash HASH]
                                         [--required-signer-file FILEPATH]
                                         [--mint STRING+LOVELACE]
                                         [--minting-policy-file FILEPATH]
                                         [--minting-policy-script-file FILEPATH]
                                         [--mint-redeemer-file FILEPATH]
                                         [--mint-execution-units (MEMORY,STEPS)]
                                         [--certificate-file FILEPATH]
                                         [--metadata-json-file FILEPATH]
                                         [--metadata-json-string STRING]
                                         [--auxiliary-script-file FILEPATH]
                                         [--witness-override INT]
                                         [--protocol-parameters-file FILEPATH]
                                         (--socket-path FILEPATH | --host HOST --port PORT)
                                         [--mainnet | --testnet-magic NATURAL]
```

### build-estimate
Build a balanced transaction without access to a live node (automatically estimates fees). Useful for offline transaction building.

**Usage:**
```
cardano-cli.exe conway transaction build-estimate [--alonzo-era | --babbage-era | --conway-era]
                                                  [--out-file FILEPATH]
                                                  [--change-address ADDRESS]
                                                  [--tx-in TXIN]
                                                  [--tx-out ADDRESS+LOVELACE]
                                                  [--tx-in-collateral TXIN]
                                                  [--tx-in-script-file FILEPATH]
                                                  [--tx-in-datum-file FILEPATH]
                                                  [--tx-in-redeemer-file FILEPATH]
                                                  [--tx-in-execution-units (MEMORY,STEPS)]
                                                  [--required-signer-hash HASH]
                                                  [--required-signer-file FILEPATH]
                                                  [--mint STRING+LOVELACE]
                                                  [--minting-policy-file FILEPATH]
                                                  [--minting-policy-script-file FILEPATH]
                                                  [--mint-redeemer-file FILEPATH]
                                                  [--mint-execution-units (MEMORY,STEPS)]
                                                  [--certificate-file FILEPATH]
                                                  [--metadata-json-file FILEPATH]
                                                  [--metadata-json-string STRING]
                                                  [--auxiliary-script-file FILEPATH]
                                                  [--witness-override INT]
                                                  [--protocol-parameters-file FILEPATH]
```

### sign
Sign a transaction with one or more signing keys.

**Usage:**
```
cardano-cli.exe conway transaction sign --tx-body-file FILEPATH
                                        --signing-key-file FILEPATH
                                        [--out-file FILEPATH]
```

### witness
Create a transaction witness for a specific signing key.

**Usage:**
```
cardano-cli.exe conway transaction witness --tx-body-file FILEPATH
                                          --signing-key-file FILEPATH
                                          [--out-file FILEPATH]
```

### assemble
Assemble a tx body and witness(es) to form a transaction.

**Usage:**
```
cardano-cli.exe conway transaction assemble --tx-body-file FILEPATH
                                           --witness-file FILEPATH
                                           [--out-file FILEPATH]
```

### submit
Submit a transaction to the local node.

**Usage:**
```
cardano-cli.exe conway transaction submit --tx-file FILEPATH
                                         (--socket-path FILEPATH | --host HOST --port PORT)
```

### policyid
Calculate the PolicyId from the monetary policy script.

**Usage:**
```
cardano-cli.exe conway transaction policyid --script-file FILEPATH [--out-file FILEPATH]
```

### calculate-min-fee
Calculate the minimum fee for a transaction.

**Usage:**
```
cardano-cli.exe conway transaction calculate-min-fee --tx-body-file FILEPATH
                                                     --tx-in-count INT
                                                     --tx-out-count INT
                                                     --witness-count INT
                                                     --protocol-parameters-file FILEPATH
```

### calculate-min-required-utxo
Calculate the minimum required UTxO for a transaction output.

**Usage:**
```
cardano-cli.exe conway transaction calculate-min-required-utxo --tx-out ADDRESS+LOVELACE
                                                                 --protocol-parameters-file FILEPATH
```

### calculate-plutus-script-cost
Calculate the costs of the Plutus scripts of a given transaction.

**Usage:**
```
cardano-cli.exe conway transaction calculate-plutus-script-cost --tx-body-file FILEPATH
                                                                  --protocol-parameters-file FILEPATH
```

### hash-script-data
Calculate the hash of script data.

**Usage:**
```
cardano-cli.exe conway transaction hash-script-data --script-data-file FILEPATH [--out-file FILEPATH]
```

### txid
Print a transaction identifier.

**Usage:**
```
cardano-cli.exe conway transaction txid --tx-file FILEPATH
```

---

## Stake Pool Commands

### Overview
```
cardano-cli.exe conway stake-pool (registration-certificate | deregistration-certificate | id | metadata-hash)
```

### registration-certificate
Create a stake pool registration certificate.

**Usage:**
```
cardano-cli.exe conway stake-pool registration-certificate --cold-verification-key-file FILEPATH
                                                             --vrf-verification-key-file FILEPATH
                                                             --pledge LOVELACE
                                                             --cost LOVELACE
                                                             --margin FRACTION
                                                             --reward-account-verification-key-file FILEPATH
                                                             --pool-owner-stake-verification-key-file FILEPATH
                                                             --pool-relay-ipv4 IPV4
                                                             --pool-relay-port PORT
                                                             --metadata-url URL
                                                             [--metadata-hash HASH]
                                                             [--out-file FILEPATH]
```

### deregistration-certificate
Create a stake pool deregistration certificate.

**Usage:**
```
cardano-cli.exe conway stake-pool deregistration-certificate --cold-verification-key-file FILEPATH
                                                              --epoch NATURAL
                                                              [--out-file FILEPATH]
```

### id
Build pool id from the offline key.

**Usage:**
```
cardano-cli.exe conway stake-pool id (--cold-verification-key-file FILEPATH | --cold-verification-key STRING) [--out-file FILEPATH]
```

### metadata-hash
Calculate the hash of a stake pool metadata file.

**Usage:**
```
cardano-cli.exe conway stake-pool metadata-hash --pool-metadata-file FILEPATH [--out-file FILEPATH]
```

---

## Governance Commands

### Overview
```
cardano-cli.exe conway governance (action | committee | drep | vote)
```

### Governance Action Commands

#### Overview
```
cardano-cli.exe conway governance action (create-constitution | update-committee | create-info | create-no-confidence | create-protocol-parameters-update | create-treasury-withdrawal | create-hardfork | view)
```

#### create-constitution
Create a constitution governance action.

**Usage:**
```
cardano-cli.exe conway governance action create-constitution --constitution-file FILEPATH
                                                              --constitution-hash HASH
                                                              --action-deposit LOVELACE
                                                              --stake-verification-key-file FILEPATH
                                                              [--out-file FILEPATH]
```

#### update-committee
Create or update a new committee proposal.

**Usage:**
```
cardano-cli.exe conway governance action update-committee --cold-verification-key-file FILEPATH
                                                           --epoch-interval NATURAL
                                                           --members FILEPATH
                                                           --threshold FRACTION
                                                           --action-deposit LOVELACE
                                                           --stake-verification-key-file FILEPATH
                                                           [--out-file FILEPATH]
```

#### create-info
Create an info action.

**Usage:**
```
cardano-cli.exe conway governance action create-info --action-deposit LOVELACE
                                                     --stake-verification-key-file FILEPATH
                                                     --url URL
                                                     [--out-file FILEPATH]
```

#### create-no-confidence
Create a no confidence proposal.

**Usage:**
```
cardano-cli.exe conway governance action create-no-confidence --action-deposit LOVELACE
                                                               --stake-verification-key-file FILEPATH
                                                               [--out-file FILEPATH]
```

#### create-protocol-parameters-update
Create a protocol parameters update.

**Usage:**
```
cardano-cli.exe conway governance action create-protocol-parameters-update --protocol-parameters-file FILEPATH
                                                                            --action-deposit LOVELACE
                                                                            --stake-verification-key-file FILEPATH
                                                                            [--out-file FILEPATH]
```

#### create-treasury-withdrawal
Create a treasury withdrawal.

**Usage:**
```
cardano-cli.exe conway governance action create-treasury-withdrawal --treasury-withdrawal FILEPATH
                                                                     --action-deposit LOVELACE
                                                                     --stake-verification-key-file FILEPATH
                                                                     [--out-file FILEPATH]
```

#### create-hardfork
Create a hardfork initiation proposal.

**Usage:**
```
cardano-cli.exe conway governance action create-hardfork --action-deposit LOVELACE
                                                          --stake-verification-key-file FILEPATH
                                                          --protocol-version STRING
                                                          [--out-file FILEPATH]
```

#### view
View a governance action.

**Usage:**
```
cardano-cli.exe conway governance action view --governance-action-file FILEPATH [--out-file FILEPATH]
```

### Committee Commands

#### Overview
```
cardano-cli.exe conway governance committee (key-gen-cold | key-gen-hot | key-hash | create-hot-key-authorization-certificate | create-cold-key-resignation-certificate)
```

#### key-gen-cold
Create a cold key pair for a Constitutional Committee Member.

**Usage:**
```
cardano-cli.exe conway governance committee key-gen-cold [--key-output-bech32 | --key-output-text-envelope]
                                                          --verification-key-file FILEPATH
                                                          --signing-key-file FILEPATH
```

#### key-gen-hot
Create a hot key pair for a Constitutional Committee Member.

**Usage:**
```
cardano-cli.exe conway governance committee key-gen-hot [--key-output-bech32 | --key-output-text-envelope]
                                                         --verification-key-file FILEPATH
                                                         --signing-key-file FILEPATH
```

#### key-hash
Print the identifier (hash) of a public key.

**Usage:**
```
cardano-cli.exe conway governance committee key-hash (--verification-key STRING | --verification-key-file FILEPATH) [--out-file FILEPATH]
```

#### create-hot-key-authorization-certificate
Create hot key authorization certificate for a Constitutional Committee Member.

**Usage:**
```
cardano-cli.exe conway governance committee create-hot-key-authorization-certificate --cold-verification-key-file FILEPATH
                                                                                      --hot-verification-key-file FILEPATH
                                                                                      --out-file FILEPATH
```

#### create-cold-key-resignation-certificate
Create cold key resignation certificate for a Constitutional Committee Member.

**Usage:**
```
cardano-cli.exe conway governance committee create-cold-key-resignation-certificate --cold-verification-key-file FILEPATH
                                                                                       --out-file FILEPATH
```

### DRep Commands

#### Overview
```
cardano-cli.exe conway governance drep (key-gen | id | registration-certificate | retirement-certificate | update-certificate | metadata-hash)
```

#### key-gen
Generate Delegated Representative verification and signing keys.

**Usage:**
```
cardano-cli.exe conway governance drep key-gen [--key-output-bech32 | --key-output-text-envelope]
                                                --verification-key-file FILEPATH
                                                --signing-key-file FILEPATH
```

#### id
Generate a drep id.

**Usage:**
```
cardano-cli.exe conway governance drep id (--verification-key STRING | --verification-key-file FILEPATH) [--out-file FILEPATH]
```

#### registration-certificate
Create a DRep registration certificate.

**Usage:**
```
cardano-cli.exe conway governance drep registration-certificate --drep-verification-key-file FILEPATH
                                                                 --deposit LOVELACE
                                                                 --stake-verification-key-file FILEPATH
                                                                 [--out-file FILEPATH]
```

#### retirement-certificate
Create a DRep retirement certificate.

**Usage:**
```
cardano-cli.exe conway governance drep retirement-certificate --drep-verification-key-file FILEPATH
                                                                --deposit LOVELACE
                                                                --stake-verification-key-file FILEPATH
                                                                [--out-file FILEPATH]
```

#### update-certificate
Create a DRep update certificate.

**Usage:**
```
cardano-cli.exe conway governance drep update-certificate --drep-verification-key-file FILEPATH
                                                            --stake-verification-key-file FILEPATH
                                                            [--out-file FILEPATH]
```

#### metadata-hash
Calculate the hash of a metadata file.

**Usage:**
```
cardano-cli.exe conway governance drep metadata-hash --drep-metadata-file FILEPATH [--out-file FILEPATH]
```

### Vote Commands

#### Overview
```
cardano-cli.exe conway governance vote (create | view)
```

#### create
Vote creation.

**Usage:**
```
cardano-cli.exe conway governance vote create --governance-action-id GOVACTIONID
                                             --drep-verification-key-file FILEPATH
                                             --vote YES|NO|ABSTAIN
                                             [--out-file FILEPATH]
```

#### view
Vote viewing.

**Usage:**
```
cardano-cli.exe conway governance vote view --vote-file FILEPATH [--out-file FILEPATH]
```

---

## Stake Address Commands

### Overview
```
cardano-cli.exe conway stake-address (key-gen | key-hash | build | registration-certificate | deregistration-certificate | stake-delegation-certificate | stake-and-vote-delegation-certificate | vote-delegation-certificate | registration-and-delegation-certificate | registration-and-vote-delegation-certificate | registration-stake-and-vote-delegation-certificate)
```

### key-gen
Create a stake address key pair.

**Usage:**
```
cardano-cli.exe conway stake-address key-gen [--key-output-bech32 | --key-output-text-envelope]
                                              --verification-key-file FILEPATH
                                              --signing-key-file FILEPATH
```

### key-hash
Print the hash of a stake address key.

**Usage:**
```
cardano-cli.exe conway stake-address key-hash (--verification-key STRING | --verification-key-file FILEPATH) [--out-file FILEPATH]
```

### build
Build a stake address.

**Usage:**
```
cardano-cli.exe conway stake-address build --stake-verification-key STRING
                                           --stake-verification-key-file FILEPATH
                                           (--mainnet | --testnet-magic NATURAL)
                                           [--out-file FILEPATH]
```

### registration-certificate
Create a stake address registration certificate.

**Usage:**
```
cardano-cli.exe conway stake-address registration-certificate --stake-verification-key-file FILEPATH
                                                               --out-file FILEPATH
```

### deregistration-certificate
Create a stake address deregistration certificate.

**Usage:**
```
cardano-cli.exe conway stake-address deregistration-certificate --stake-verification-key-file FILEPATH
                                                                  --out-file FILEPATH
```

### stake-delegation-certificate
Create a stake address stake delegation certificate.

**Usage:**
```
cardano-cli.exe conway stake-address stake-delegation-certificate --stake-verification-key-file FILEPATH
                                                                   --stake-pool-id POOLID
                                                                   --out-file FILEPATH
```

### stake-and-vote-delegation-certificate
Create a stake address stake and vote delegation certificate.

**Usage:**
```
cardano-cli.exe conway stake-address stake-and-vote-delegation-certificate --stake-verification-key-file FILEPATH
                                                                          --stake-pool-id POOLID
                                                                          --drep-id DREPID
                                                                          --out-file FILEPATH
```

### vote-delegation-certificate
Create a stake address vote delegation certificate.

**Usage:**
```
cardano-cli.exe conway stake-address vote-delegation-certificate --stake-verification-key-file FILEPATH
                                                                  --drep-id DREPID
                                                                  --out-file FILEPATH
```

### registration-and-delegation-certificate
Create a stake address registration and delegation certificate.

**Usage:**
```
cardano-cli.exe conway stake-address registration-and-delegation-certificate --stake-verification-key-file FILEPATH
                                                                           --stake-pool-id POOLID
                                                                           --out-file FILEPATH
```

### registration-and-vote-delegation-certificate
Create a stake address registration and vote delegation certificate.

**Usage:**
```
cardano-cli.exe conway stake-address registration-and-vote-delegation-certificate --stake-verification-key-file FILEPATH
                                                                                --drep-id DREPID
                                                                                --out-file FILEPATH
```

### registration-stake-and-vote-delegation-certificate
Create a stake address registration, stake delegation and vote delegation certificate.

**Usage:**
```
cardano-cli.exe conway stake-address registration-stake-and-vote-delegation-certificate --stake-verification-key-file FILEPATH
                                                                                          --stake-pool-id POOLID
                                                                                          --drep-id DREPID
                                                                                          --out-file FILEPATH
```

---

## Genesis Commands

### Overview
```
cardano-cli.exe conway genesis (key-gen-genesis | key-gen-delegate | key-gen-utxo | key-hash | get-ver-key | initial-addr | initial-txin | create-cardano | create | create-staked | create-testnet-data | hash)
```

### key-gen-genesis
Create a Shelley genesis key pair.

**Usage:**
```
cardano-cli.exe conway genesis key-gen-genesis [--key-output-bech32 | --key-output-text-envelope]
                                                --verification-key-file FILEPATH
                                                --signing-key-file FILEPATH
```

### key-gen-delegate
Create a Shelley genesis delegate key pair.

**Usage:**
```
cardano-cli.exe conway genesis key-gen-delegate [--key-output-bech32 | --key-output-text-envelope]
                                                 --verification-key-file FILEPATH
                                                 --signing-key-file FILEPATH
```

### key-gen-utxo
Create a Shelley genesis UTxO key pair.

**Usage:**
```
cardano-cli.exe conway genesis key-gen-utxo [--key-output-bech32 | --key-output-text-envelope]
                                             --verification-key-file FILEPATH
                                             --signing-key-file FILEPATH
```

### key-hash
Print the identifier (hash) of a public key.

**Usage:**
```
cardano-cli.exe conway genesis key-hash (--verification-key STRING | --verification-key-file FILEPATH) [--out-file FILEPATH]
```

### get-ver-key
Derive the verification key from a signing key.

**Usage:**
```
cardano-cli.exe conway genesis get-ver-key --signing-key-file FILEPATH --out-file FILEPATH
```

### initial-addr
Get the address for an initial UTxO based on the verification key.

**Usage:**
```
cardano-cli.exe conway genesis initial-addr --verification-key-file FILEPATH (--mainnet | --testnet-magic NATURAL) [--out-file FILEPATH]
```

### initial-txin
Get the TxIn for an initial UTxO based on the verification key.

**Usage:**
```
cardano-cli.exe conway genesis initial-txin --verification-key-file FILEPATH --out-file FILEPATH
```

### create-cardano
Create a Byron and Shelley genesis file from a genesis template and genesis/delegation/spending keys.

**Usage:**
```
cardano-cli.exe conway genesis create-cardano --genesis-dir DIRECTORY
                                              --byron-genesis-dir DIRECTORY
                                              --byron-start-time NATURAL
                                              --byron-delegate-verification-key-file FILEPATH
                                              --byron-genesis-verification-key-file FILEPATH
                                              --byron-genesis-delegation-verification-key-file FILEPATH
                                              --shelley-genesis-dir DIRECTORY
                                              --shelley-genesis-verification-key-file FILEPATH
                                              --shelley-genesis-delegation-verification-key-file FILEPATH
                                              --shelley-utxo-verification-key-file FILEPATH
```

### create
Create a Shelley genesis file from a genesis template and genesis/delegation/spending keys.

**Usage:**
```
cardano-cli.exe conway genesis create --genesis-dir DIRECTORY
                                      --genesis-verification-key-file FILEPATH
                                      --genesis-delegation-verification-key-file FILEPATH
                                      --utxo-verification-key-file FILEPATH
```

### create-staked
Create a staked Shelley genesis file from a genesis template and genesis/delegation/spending keys.

**Usage:**
```
cardano-cli.exe conway genesis create-staked --genesis-dir DIRECTORY
                                              --genesis-verification-key-file FILEPATH
                                              --genesis-delegation-verification-key-file FILEPATH
                                              --utxo-verification-key-file FILEPATH
                                              --stake-verification-key-file FILEPATH
```

### create-testnet-data
Create data to use for starting a testnet.

**Usage:**
```
cardano-cli.exe conway genesis create-testnet-data --testnet-magic NATURAL
                                                    --testnet-dir DIRECTORY
                                                    --num-bulk-creds-files INT
                                                    --num-stake-pools INT
                                                    --num-dreps INT
                                                    --num-active-dreps INT
                                                    --total-balance LOVELACE
                                                    --supply LOVELACE
```

### hash
Compute the hash of a genesis file (deprecated).

**Usage:**
```
cardano-cli.exe conway genesis hash --genesis FILEPATH
```

---

## Text View Commands

### Overview
```
cardano-cli.exe conway text-view (...)
```

Text view commands are used for dealing with Shelley TextView files. Transactions, addresses etc are stored on disk as TextView files.

---

## Additional Conway Address and Key Commands

The Conway era also provides address and key commands that are era-specific versions of the main commands:

### conway address
Payment address commands (Conway era specific).

### conway key
Key utility commands (Conway era specific).

### conway node
Node operation commands (Conway era specific).

### conway query
Node query commands (Conway era specific).

These work similarly to their main command counterparts but are era-specific for Conway.

---

*This documentation covers Conway era commands for Cardano-CLI version 11.0.0.0.*
