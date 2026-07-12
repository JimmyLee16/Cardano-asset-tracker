# Cardano-CLI Documentation - Query Commands (Version 11.0.0.0)

## Query Commands

### Overview
```
cardano-cli.exe query (tip | protocol-parameters | stake-distribution | stake-snapshot | stake-address-info | utxo | tx-mempool | tx-info | gov-state | drep-state | committee-state | draft-constitution | committee-members | constitution | drep-anchors | drep-list | drep-deposit | drep-voting-governance-actions | vote-anchors | gov-action-anchors | gov-action-state | gov-action-details | gov-action-proposal | governance-poll | ledger-state | slot-number | leadership-schedule | stake-pools | pool-params | pool-params-raw | pool-status | kes-period-info | leadership-logs | leadership | set-ledger-state | protocol-state | protocol-version | block | block-header | tx-view | protocol-parameters-raw | stake-distribution-raw | stake-snapshot-raw | stake-address-info-raw | utxo-raw | tx-mempool-raw | tx-info-raw | gov-state-raw | drep-state-raw | committee-state-raw | draft-constitution-raw | committee-members-raw | constitution-raw | drep-anchors-raw | drep-list-raw | drep-deposit-raw | drep-voting-governance-actions-raw | vote-anchors-raw | gov-action-anchors-raw | gov-action-state-raw | gov-action-details-raw | gov-action-proposal-raw | governance-poll-raw | ledger-state-raw | slot-number-raw | leadership-schedule-raw | stake-pools-raw | pool-params-raw-raw | pool-status-raw | kes-period-info-raw | leadership-logs-raw | leadership-raw | set-ledger-state-raw | protocol-state-raw | protocol-version-raw | block-raw | block-header-raw | tx-view-raw)
```

### Global Query Options
- `--cardano-mode` - Cardano mode
- `--byron-mode` - Byron mode
- `--shelley-mode` - Shelley mode
- `--allegra-mode` - Allegra mode
- `--mary-mode` - Mary mode
- `--alonzo-mode` - Alonzo mode
- `--babbage-mode` - Babbage mode
- `--conway-mode` - Conway mode
- `--era STRING` - Cardano era: Byron, Shelley, Allegra, Mary, Alonzo, Babbage, or Conway
- `--socket-path FILEPATH` - Path to the node socket
- `--host HOST` - Hostname of the node
- `--port PORT` - Port number of the node
- `--config FILEPATH` - Path to the node configuration file
- `--out-file FILEPATH` - Optional output file. Default is to write to stdout
- `--out-format STRING` - Output format (json, yaml)

---

## tip

### Description
Query the tip of the blockchain.

**Usage:**
```
cardano-cli.exe query tip (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                          (--socket-path FILEPATH | --host HOST --port PORT)
                          [--config FILEPATH]
                          [--out-file FILEPATH]
```

---

## protocol-parameters

### Description
Query the protocol parameters.

**Usage:**
```
cardano-cli.exe query protocol-parameters (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                          (--socket-path FILEPATH | --host HOST --port PORT)
                                          [--config FILEPATH]
                                          [--out-file FILEPATH]
```

---

## stake-distribution

### Description
Query the stake distribution.

**Usage:**
```
cardano-cli.exe query stake-distribution (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                         (--socket-path FILEPATH | --host HOST --port PORT)
                                         [--config FILEPATH]
                                         [--out-file FILEPATH]
```

---

## stake-snapshot

### Description
Query the stake snapshot.

**Usage:**
```
cardano-cli.exe query stake-snapshot (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                     (--socket-path FILEPATH | --host HOST --port PORT)
                                     [--config FILEPATH]
                                     [--out-file FILEPATH]
```

---

## stake-address-info

### Description
Query the stake address info.

**Usage:**
```
cardano-cli.exe query stake-address-info (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                          (--socket-path FILEPATH | --host HOST --port PORT)
                                          [--config FILEPATH]
                                          --stake-address ADDRESS
                                          [--out-file FILEPATH]
```

**Options:**
- `--stake-address ADDRESS` - Stake address

---

## utxo

### Description
Query the UTxO entries.

**Usage:**
```
cardano-cli.exe query utxo (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                           (--socket-path FILEPATH | --host HOST --port PORT)
                           [--config FILEPATH]
                           [--address ADDRESS]
                           [--tx-in TXIN]
                           [--whole-utxo]
                           [--out-file FILEPATH]
```

**Options:**
- `--address ADDRESS` - Address to query
- `--tx-in TXIN` - Transaction input (format: txid#ix)
- `--whole-utxo` - Query the whole UTxO set

---

## tx-mempool

### Description
Query the mempool.

**Usage:**
```
cardano-cli.exe query tx-mempool (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                (--socket-path FILEPATH | --host HOST --port PORT)
                                [--config FILEPATH]
                                [--out-file FILEPATH]
```

---

## tx-info

### Description
Query transaction info.

**Usage:**
```
cardano-cli.exe query tx-info (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                              (--socket-path FILEPATH | --host HOST --port PORT)
                              [--config FILEPATH]
                              --tx-id TXID
                              [--out-file FILEPATH]
```

**Options:**
- `--tx-id TXID` - Transaction ID

---

## gov-state

### Description
Query the governance state.

**Usage:**
```
cardano-cli.exe query gov-state (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                (--socket-path FILEPATH | --host HOST --port PORT)
                                [--config FILEPATH]
                                [--out-file FILEPATH]
```

---

## drep-state

### Description
Query the DRep state.

**Usage:**
```
cardano-cli.exe query drep-state (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                  (--socket-path FILEPATH | --host HOST --port PORT)
                                  [--config FILEPATH]
                                  --drep-id DREPID
                                  [--out-file FILEPATH]
```

**Options:**
- `--drep-id DREPID` - DRep ID

---

## committee-state

### Description
Query the committee state.

**Usage:**
```
cardano-cli.exe query committee-state (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                      (--socket-path FILEPATH | --host HOST --port PORT)
                                      [--config FILEPATH]
                                      [--out-file FILEPATH]
```

---

## draft-constitution

### Description
Query the draft constitution.

**Usage:**
```
cardano-cli.exe query draft-constitution (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                         (--socket-path FILEPATH | --host HOST --port PORT)
                                         [--config FILEPATH]
                                         [--out-file FILEPATH]
```

---

## committee-members

### Description
Query the committee members.

**Usage:**
```
cardano-cli.exe query committee-members (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                        (--socket-path FILEPATH | --host HOST --port PORT)
                                        [--config FILEPATH]
                                        [--out-file FILEPATH]
```

---

## constitution

### Description
Query the constitution.

**Usage:**
```
cardano-cli.exe query constitution (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                   (--socket-path FILEPATH | --host HOST --port PORT)
                                   [--config FILEPATH]
                                   [--out-file FILEPATH]
```

---

## drep-anchors

### Description
Query DRep anchors.

**Usage:**
```
cardano-cli.exe query drep-anchors (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                   (--socket-path FILEPATH | --host HOST --port PORT)
                                   [--config FILEPATH]
                                   [--out-file FILEPATH]
```

---

## drep-list

### Description
Query the DRep list.

**Usage:**
```
cardano-cli.exe query drep-list (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                (--socket-path FILEPATH | --host HOST --port PORT)
                                [--config FILEPATH]
                                [--out-file FILEPATH]
```

---

## drep-deposit

### Description
Query the DRep deposit.

**Usage:**
```
cardano-cli.exe query drep-deposit (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                   (--socket-path FILEPATH | --host HOST --port PORT)
                                   [--config FILEPATH]
                                   [--out-file FILEPATH]
```

---

## drep-voting-governance-actions

### Description
Query DRep voting on governance actions.

**Usage:**
```
cardano-cli.exe query drep-voting-governance-actions (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                                     (--socket-path FILEPATH | --host HOST --port PORT)
                                                     [--config FILEPATH]
                                                     --drep-id DREPID
                                                     [--out-file FILEPATH]
```

**Options:**
- `--drep-id DREPID` - DRep ID

---

## vote-anchors

### Description
Query vote anchors.

**Usage:**
```
cardano-cli.exe query vote-anchors (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                   (--socket-path FILEPATH | --host HOST --port PORT)
                                   [--config FILEPATH]
                                   [--out-file FILEPATH]
```

---

## gov-action-anchors

### Description
Query governance action anchors.

**Usage:**
```
cardano-cli.exe query gov-action-anchors (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                          (--socket-path FILEPATH | --host HOST --port PORT)
                                          [--config FILEPATH]
                                          [--out-file FILEPATH]
```

---

## gov-action-state

### Description
Query governance action state.

**Usage:**
```
cardano-cli.exe query gov-action-state (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                       (--socket-path FILEPATH | --host HOST --port PORT)
                                       [--config FILEPATH]
                                       --gov-action-id GOVACTIONID
                                       [--out-file FILEPATH]
```

**Options:**
- `--gov-action-id GOVACTIONID` - Governance action ID

---

## gov-action-details

### Description
Query governance action details.

**Usage:**
```
cardano-cli.exe query gov-action-details (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                          (--socket-path FILEPATH | --host HOST --port PORT)
                                          [--config FILEPATH]
                                          --gov-action-id GOVACTIONID
                                          [--out-file FILEPATH]
```

**Options:**
- `--gov-action-id GOVACTIONID` - Governance action ID

---

## gov-action-proposal

### Description
Query governance action proposal.

**Usage:**
```
cardano-cli.exe query gov-action-proposal (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                           (--socket-path FILEPATH | --host HOST --port PORT)
                                           [--config FILEPATH]
                                           --gov-action-id GOVACTIONID
                                           [--out-file FILEPATH]
```

**Options:**
- `--gov-action-id GOVACTIONID` - Governance action ID

---

## governance-poll

### Description
Query governance poll.

**Usage:**
```
cardano-cli.exe query governance-poll (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                      (--socket-path FILEPATH | --host HOST --port PORT)
                                      [--config FILEPATH]
                                      [--out-file FILEPATH]
```

---

## ledger-state

### Description
Query the ledger state.

**Usage:**
```
cardano-cli.exe query ledger-state (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                   (--socket-path FILEPATH | --host HOST --port PORT)
                                   [--config FILEPATH]
                                   [--out-file FILEPATH]
```

---

## slot-number

### Description
Query the current slot number.

**Usage:**
```
cardano-cli.exe query slot-number (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                  (--socket-path FILEPATH | --host HOST --port PORT)
                                  [--config FILEPATH]
                                  [--out-file FILEPATH]
```

---

## leadership-schedule

### Description
Query the leadership schedule.

**Usage:**
```
cardano-cli.exe query leadership-schedule (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                          (--socket-path FILEPATH | --host HOST --port PORT)
                                          [--config FILEPATH]
                                          --stake-pool-id POOLID
                                          --vrf-verification-key-file FILEPATH
                                          [--out-file FILEPATH]
```

**Options:**
- `--stake-pool-id POOLID` - Stake pool ID
- `--vrf-verification-key-file FILEPATH` - VRF verification key file

---

## stake-pools

### Description
Query the stake pools.

**Usage:**
```
cardano-cli.exe query stake-pools (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                  (--socket-path FILEPATH | --host HOST --port PORT)
                                  [--config FILEPATH]
                                  [--out-file FILEPATH]
```

---

## pool-params

### Description
Query pool parameters.

**Usage:**
```
cardano-cli.exe query pool-params (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                   (--socket-path FILEPATH | --host HOST --port PORT)
                                   [--config FILEPATH]
                                   --stake-pool-id POOLID
                                   [--out-file FILEPATH]
```

**Options:**
- `--stake-pool-id POOLID` - Stake pool ID

---

## pool-params-raw

### Description
Query pool parameters (raw).

**Usage:**
```
cardano-cli.exe query pool-params-raw (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                       (--socket-path FILEPATH | --host HOST --port PORT)
                                       [--config FILEPATH]
                                       --stake-pool-id POOLID
                                       [--out-file FILEPATH]
```

**Options:**
- `--stake-pool-id POOLID` - Stake pool ID

---

## pool-status

### Description
Query pool status.

**Usage:**
```
cardano-cli.exe query pool-status (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                   (--socket-path FILEPATH | --host HOST --port PORT)
                                   [--config FILEPATH]
                                   --stake-pool-id POOLID
                                   [--out-file FILEPATH]
```

**Options:**
- `--stake-pool-id POOLID` - Stake pool ID

---

## kes-period-info

### Description
Query KES period info.

**Usage:**
```
cardano-cli.exe query kes-period-info (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                      (--socket-path FILEPATH | --host HOST --port PORT)
                                      [--config FILEPATH]
                                      --kes-verification-key-file FILEPATH
                                      [--out-file FILEPATH]
```

**Options:**
- `--kes-verification-key-file FILEPATH` - KES verification key file

---

## leadership-logs

### Description
Query leadership logs.

**Usage:**
```
cardano-cli.exe query leadership-logs (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                      (--socket-path FILEPATH | --host HOST --port PORT)
                                      [--config FILEPATH]
                                      --stake-pool-id POOLID
                                      --vrf-verification-key-file FILEPATH
                                      [--out-file FILEPATH]
```

**Options:**
- `--stake-pool-id POOLID` - Stake pool ID
- `--vrf-verification-key-file FILEPATH` - VRF verification key file

---

## leadership

### Description
Query leadership.

**Usage:**
```
cardano-cli.exe query leadership (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                  (--socket-path FILEPATH | --host HOST --port PORT)
                                  [--config FILEPATH]
                                  --stake-pool-id POOLID
                                  --vrf-verification-key-file FILEPATH
                                  [--out-file FILEPATH]
```

**Options:**
- `--stake-pool-id POOLID` - Stake pool ID
- `--vrf-verification-key-file FILEPATH` - VRF verification key file

---

## set-ledger-state

### Description
Set ledger state.

**Usage:**
```
cardano-cli.exe query set-ledger-state (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                        (--socket-path FILEPATH | --host HOST --port PORT)
                                        [--config FILEPATH]
                                        --set-ledger-state FILEPATH
                                        [--out-file FILEPATH]
```

**Options:**
- `--set-ledger-state FILEPATH` - Ledger state file

---

## protocol-state

### Description
Query protocol state.

**Usage:**
```
cardano-cli.exe query protocol-state (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                     (--socket-path FILEPATH | --host HOST --port PORT)
                                     [--config FILEPATH]
                                     [--out-file FILEPATH]
```

---

## protocol-version

### Description
Query protocol version.

**Usage:**
```
cardano-cli.exe query protocol-version (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                        (--socket-path FILEPATH | --host HOST --port PORT)
                                        [--config FILEPATH]
                                        [--out-file FILEPATH]
```

---

## block

### Description
Query a block.

**Usage:**
```
cardano-cli.exe query block (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                            (--socket-path FILEPATH | --host HOST --port PORT)
                            [--config FILEPATH]
                            --block INT
                            [--out-file FILEPATH]
```

**Options:**
- `--block INT` - Block number

---

## block-header

### Description
Query a block header.

**Usage:**
```
cardano-cli.exe query block-header (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                                   (--socket-path FILEPATH | --host HOST --port PORT)
                                   [--config FILEPATH]
                                   --block INT
                                   [--out-file FILEPATH]
```

**Options:**
- `--block INT` - Block number

---

## tx-view

### Description
View a transaction.

**Usage:**
```
cardano-cli.exe query tx-view (--cardano-mode | --byron-mode | --shelley-mode | --allegra-mode | --mary-mode | --alonzo-mode | --babbage-mode | --conway-mode | --era STRING)
                              (--socket-path FILEPATH | --host HOST --port PORT)
                              [--config FILEPATH]
                              --tx-file FILEPATH
                              [--out-file FILEPATH]
```

**Options:**
- `--tx-file FILEPATH` - Transaction file

---

## Raw Query Commands

The following commands are the raw versions of the query commands, which output data in a different format (typically JSON):

- `protocol-parameters-raw`
- `stake-distribution-raw`
- `stake-snapshot-raw`
- `stake-address-info-raw`
- `utxo-raw`
- `tx-mempool-raw`
- `tx-info-raw`
- `gov-state-raw`
- `drep-state-raw`
- `committee-state-raw`
- `draft-constitution-raw`
- `committee-members-raw`
- `constitution-raw`
- `drep-anchors-raw`
- `drep-list-raw`
- `drep-deposit-raw`
- `drep-voting-governance-actions-raw`
- `vote-anchors-raw`
- `gov-action-anchors-raw`
- `gov-action-state-raw`
- `gov-action-details-raw`
- `gov-action-proposal-raw`
- `governance-poll-raw`
- `ledger-state-raw`
- `slot-number-raw`
- `leadership-schedule-raw`
- `stake-pools-raw`
- `pool-params-raw-raw`
- `pool-status-raw`
- `kes-period-info-raw`
- `leadership-logs-raw`
- `leadership-raw`
- `set-ledger-state-raw`
- `protocol-state-raw`
- `protocol-version-raw`
- `block-raw`
- `block-header-raw`
- `tx-view-raw`

These raw commands accept the same options as their non-raw counterparts.
