# 🏦 Corporate Governance Native Script - Implementation Guide

## 📋 Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Key Holders](#key-holders)
4. [Approval Flow](#approval-flow)
5. [JSON Structure](#json-structure)
6. [Use Cases](#use-cases)
7. [Implementation Steps](#implementation-steps)

---

## 🎯 Overview

This Native Script implements a **multi-layer corporate governance model** for high-value financial transactions on Cardano blockchain. It ensures:

- ✅ **Distributed Authority**: No single person can approve transactions
- ✅ **Flexible Paths**: Multiple approval routes based on transaction type
- ✅ **Professional Oversight**: Legal, audit, and financial controls
- ✅ **Time-bounded Execution**: Dual time windows for safety

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    ROOT POLICY                          │
│              (ALL 3 BLOCKS REQUIRED)                    │
└─────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐  ┌──────────────────┐  ┌─────────────────┐
│   BLOCK 1     │  │    BLOCK 2       │  │    BLOCK 3      │
│   Executive   │  │   Professional   │  │ Finalization +  │
│   Approval    │  │    Control       │  │  Time Window    │
│   (≥3 of 4)   │  │  (Choose Path)   │  │  (ALL Required) │
└───────────────┘  └──────────────────┘  └─────────────────┘
```

### **Block Structure:**

#### **BLOCK 1: Executive Approval** (REQUIRED)
- Minimum 3 out of 4 executive signatures
- Ensures top-level strategic alignment

#### **BLOCK 2: Professional Control** (CHOOSE ONE PATH)
- **Path A**: Majority Approval (Legal + Audit + Treasury/Tech)
- **Path B**: Operational Backup (Ops + Legal)

#### **BLOCK 3: Finalization** (ALL REQUIRED)
- Final approval checkpoint (Simple OR Strict)
- Time window validation (Primary OR Secondary)

---

## 👥 Key Holders

| Role | Verification Key | Responsibility |
|------|------------------|----------------|
| **Board Chair** | `addr_shared_vkh_board` | Strategic oversight, governance |
| **CFO** | `addr_shared_vkh_cfo` | Financial strategy, budget control |
| **COO** | `addr_shared_vkh_coo` | Operations execution, process |
| **CTO** | `addr_shared_vkh_cto` | Technology decisions, security |
| **Head Legal** | `addr_shared_vkh_legal` | Legal compliance, risk mitigation |
| **Auditor** | `addr_shared_vkh_auditor` | Financial audit, transparency |
| **Treasury Manager** | `addr_shared_vkh_treasury` | Cash management, fund operations |

---

## 🔄 Approval Flow

### **Visual Flow Diagram:**

```
START
  │
  ├─► BLOCK 1: Executive Board
  │   └─► [Board Chair] [CFO] [COO] [CTO]
  │       └─► Require ≥3 signatures
  │
  ├─► BLOCK 2: Choose ONE Path
  │   │
  │   ├─► PATH A: Majority Approval
  │   │   ├─► Step 1: Legal + Auditor (BOTH required)
  │   │   └─► Step 2: Choose ONE:
  │   │       ├─► Treasury/C-Senior (≥2 of 3)
  │   │       │   └─► [Treasury] [CFO] [COO]
  │   │       └─► Nested Tech Path
  │   │           ├─► [CTO alone] OR [Board + Legal]
  │   │           └─► AND [Treasury required]
  │   │
  │   └─► PATH B: Operational Backup
  │       ├─► Step 1: Choose ONE:
  │       │   ├─► [CFO] OR [COO] (≥1 of 2)
  │       │   └─► [Board + CTO] (BOTH)
  │       └─► Step 2: [Legal] (REQUIRED)
  │
  └─► BLOCK 3: Finalization (ALL Required)
      ├─► Part 1: Final Approval (Choose ONE):
      │   ├─► Simple: [Treasury] OR [Auditor]
      │   └─► Strict Finance:
      │       ├─► [Board + CFO] (BOTH)
      │       └─► [CTO alone] OR [Legal + Auditor]
      │
      └─► Part 2: Time Window (Choose ONE):
          ├─► Primary: Slot 182,732,198 → 190,000,000
          └─► Secondary: Slot 190,000,001 → 198,902,831
```

---

## 📄 JSON Structure

### **Complete Native Script:**

```json
{
  "all": [
    {
      "at_least": {
        "signatures": [
          {
            "signature": {
              "verification_key": "addr_shared_vkh_board"
            }
          },
          {
            "signature": {
              "verification_key": "addr_shared_vkh_cfo"
            }
          },
          {
            "signature": {
              "verification_key": "addr_shared_vkh_coo"
            }
          },
          {
            "signature": {
              "verification_key": "addr_shared_vkh_cto"
            }
          }
        ],
        "required": 3
      }
    },
    {
      "any": [
        {
          "all": [
            {
              "at_least": {
                "signatures": [
                  {
                    "signature": {
                      "verification_key": "addr_shared_vkh_legal"
                    }
                  },
                  {
                    "signature": {
                      "verification_key": "addr_shared_vkh_auditor"
                    }
                  }
                ],
                "required": 2
              }
            },
            {
              "any": [
                {
                  "at_least": {
                    "signatures": [
                      {
                        "signature": {
                          "verification_key": "addr_shared_vkh_treasury"
                        }
                      },
                      {
                        "signature": {
                          "verification_key": "addr_shared_vkh_cfo"
                        }
                      },
                      {
                        "signature": {
                          "verification_key": "addr_shared_vkh_coo"
                        }
                      }
                    ],
                    "required": 2
                  }
                },
                {
                  "all": [
                    {
                      "any": [
                        {
                          "signature": {
                            "verification_key": "addr_shared_vkh_cto"
                          }
                        },
                        {
                          "at_least": {
                            "signatures": [
                              {
                                "signature": {
                                  "verification_key": "addr_shared_vkh_board"
                                }
                              },
                              {
                                "signature": {
                                  "verification_key": "addr_shared_vkh_legal"
                                }
                              }
                            ],
                            "required": 2
                          }
                        }
                      ]
                    },
                    {
                      "at_least": {
                        "signatures": [
                          {
                            "signature": {
                              "verification_key": "addr_shared_vkh_treasury"
                            }
                          }
                        ],
                        "required": 1
                      }
                    }
                  ]
                }
              ]
            }
          ]
        },
        {
          "all": [
            {
              "any": [
                {
                  "at_least": {
                    "signatures": [
                      {
                        "signature": {
                          "verification_key": "addr_shared_vkh_cfo"
                        }
                      },
                      {
                        "signature": {
                          "verification_key": "addr_shared_vkh_coo"
                        }
                      }
                    ],
                    "required": 1
                  }
                },
                {
                  "at_least": {
                    "signatures": [
                      {
                        "signature": {
                          "verification_key": "addr_shared_vkh_board"
                        }
                      },
                      {
                        "signature": {
                          "verification_key": "addr_shared_vkh_cto"
                        }
                      }
                    ],
                    "required": 2
                  }
                }
              ]
            },
            {
              "at_least": {
                "signatures": [
                  {
                    "signature": {
                      "verification_key": "addr_shared_vkh_legal"
                    }
                  }
                ],
                "required": 1
              }
            }
          ]
        }
      ]
    },
    {
      "all": [
        {
          "any": [
            {
              "at_least": {
                "signatures": [
                  {
                    "signature": {
                      "verification_key": "addr_shared_vkh_treasury"
                    }
                  },
                  {
                    "signature": {
                      "verification_key": "addr_shared_vkh_auditor"
                    }
                  }
                ],
                "required": 1
              }
            },
            {
              "all": [
                {
                  "at_least": {
                    "signatures": [
                      {
                        "signature": {
                          "verification_key": "addr_shared_vkh_board"
                        }
                      },
                      {
                        "signature": {
                          "verification_key": "addr_shared_vkh_cfo"
                        }
                      }
                    ],
                    "required": 2
                  }
                },
                {
                  "any": [
                    {
                      "signature": {
                        "verification_key": "addr_shared_vkh_cto"
                      }
                    },
                    {
                      "at_least": {
                        "signatures": [
                          {
                            "signature": {
                              "verification_key": "addr_shared_vkh_legal"
                            }
                          },
                          {
                            "signature": {
                              "verification_key": "addr_shared_vkh_auditor"
                            }
                          }
                        ],
                        "required": 2
                      }
                    }
                  ]
                }
              ]
            }
          ]
        },
        {
          "any": [
            {
              "all": [
                {
                  "active_from": {
                    "slot": 182732198
                  }
                },
                {
                  "active_until": {
                    "slot": 190000000
                  }
                }
              ]
            },
            {
              "all": [
                {
                  "active_from": {
                    "slot": 190000001
                  }
                },
                {
                  "active_until": {
                    "slot": 198902831
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

---

## 💼 Use Cases

### **Scenario 1: Standard Equipment Purchase ($500K)**

**Transaction Type:** Regular operational expense

**Approval Path:**
1. ✅ **Block 1:** Board Chair + CFO + COO (3/4)
2. ✅ **Block 2 - Path A:**
   - Legal + Auditor ✓
   - Treasury/C-Senior: CFO + Treasury (2/3) ✓
3. ✅ **Block 3:**
   - Final: Treasury (Simple Path) ✓
   - Window: Primary (Slot 182M-190M) ✓

**Total Signatures:** 6 (Board, CFO x2, COO, Legal, Auditor, Treasury)

---

### **Scenario 2: Blockchain Infrastructure Investment ($5M)**

**Transaction Type:** High-value technology investment

**Approval Path:**
1. ✅ **Block 1:** Board + CFO + COO + CTO (4/4 - all executives)
2. ✅ **Block 2 - Path A:**
   - Legal + Auditor ✓
   - Nested Tech: CTO + Treasury ✓
3. ✅ **Block 3:**
   - Final: Strict Finance → Board + CFO + CTO ✓
   - Window: Primary ✓

**Total Signatures:** 7 (all key holders participate)

---

### **Scenario 3: Emergency Asset Liquidation**

**Transaction Type:** Urgent operational need

**Approval Path:**
1. ✅ **Block 1:** Board + CFO + COO (3/4)
2. ✅ **Block 2 - Path B (Operational Backup):**
   - Operations: CFO ✓
   - Legal: Required ✓
3. ✅ **Block 3:**
   - Final: Treasury (Simple) ✓
   - Window: Secondary (if missed Primary window) ✓

**Total Signatures:** 5 (Board, CFO x2, COO, Legal, Treasury)

---

### **Scenario 4: Sensitive M&A Transaction**

**Transaction Type:** Corporate acquisition with legal complexity

**Approval Path:**
1. ✅ **Block 1:** All 4 executives
2. ✅ **Block 2 - Path A:**
   - Legal + Auditor ✓
   - Nested: Board + Legal (instead of CTO) + Treasury ✓
3. ✅ **Block 3:**
   - Final: Strict → Board + CFO + (Legal + Auditor) ✓
   - Window: Primary ✓

**Total Signatures:** 7 with emphasis on legal oversight

---

## 🛠️ Implementation Steps

### **Prerequisites**

Install `cardano-address`:
```bash
# Via binary release
wget https://github.com/IntersectMBO/cardano-addresses/releases/download/3.12.0/cardano-addresses-3.12.0-linux64.tar.gz
tar -xzf cardano-addresses-3.12.0-linux64.tar.gz
sudo mv cardano-address /usr/local/bin/

# Verify installation
cardano-address --version
```

---

### **Step 1: Generate Recovery Phrases for Each Role**

```bash
# Generate 24-word mnemonic for Board Chair
cardano-address recovery-phrase generate --size 24 > board.mnemonic

# Repeat for each role
cardano-address recovery-phrase generate --size 24 > cfo.mnemonic
cardano-address recovery-phrase generate --size 24 > coo.mnemonic
cardano-address recovery-phrase generate --size 24 > cto.mnemonic
cardano-address recovery-phrase generate --size 24 > legal.mnemonic
cardano-address recovery-phrase generate --size 24 > auditor.mnemonic
cardano-address recovery-phrase generate --size 24 > treasury.mnemonic

# IMPORTANT: Distribute these mnemonics securely to each key holder
# Each person should store their phrase offline in a safe location
```

---

### **Step 2: Derive Root Keys from Recovery Phrases**

```bash
# Derive root key for Board Chair
cat board.mnemonic | cardano-address key from-recovery-phrase Shelley > board.root.xsk

# Repeat for all roles
cat cfo.mnemonic | cardano-address key from-recovery-phrase Shelley > cfo.root.xsk
cat coo.mnemonic | cardano-address key from-recovery-phrase Shelley > coo.root.xsk
cat cto.mnemonic | cardano-address key from-recovery-phrase Shelley > cto.root.xsk
cat legal.mnemonic | cardano-address key from-recovery-phrase Shelley > legal.root.xsk
cat auditor.mnemonic | cardano-address key from-recovery-phrase Shelley > auditor.root.xsk
cat treasury.mnemonic | cardano-address key from-recovery-phrase Shelley > treasury.root.xsk
```

---

### **Step 3: Derive Payment Keys**

```bash
# Derive payment key for Board Chair
cat board.root.xsk | cardano-address key child 1852H/1815H/0H/0/0 > board.payment.xsk

# Get public key
cat board.payment.xsk | cardano-address key public --with-chain-code > board.payment.xvk

# Repeat for all roles
cat cfo.root.xsk | cardano-address key child 1852H/1815H/0H/0/0 > cfo.payment.xsk
cat cfo.payment.xsk | cardano-address key public --with-chain-code > cfo.payment.xvk

# ... (repeat for coo, cto, legal, auditor, treasury)
```

---

### **Step 4: Extract Verification Key Hashes**

```bash
# Extract key hash for Board Chair
cat board.payment.xvk | cardano-address key hash > board.vkh

# View the hash
cat board.vkh
# Output example: addr_shared_vkh1abc123def456...

# Repeat for all roles
cat cfo.payment.xvk | cardano-address key hash > cfo.vkh
cat coo.payment.xvk | cardano-address key hash > coo.vkh
cat cto.payment.xvk | cardano-address key hash > cto.vkh
cat legal.payment.xvk | cardano-address key hash > legal.vkh
cat auditor.payment.xvk | cardano-address key hash > auditor.vkh
cat treasury.payment.xvk | cardano-address key hash > treasury.vkh
```

---

### **Step 5: Update Native Script JSON**

Replace placeholder verification keys in `script.json` with actual hashes:

```bash
# Create script with actual key hashes
cat > script.json << 'EOF'
{
  "all": [
    {
      "at_least": {
        "signatures": [
          {
            "signature": {
              "verification_key": "$(cat board.vkh)"
            }
          },
          {
            "signature": {
              "verification_key": "$(cat cfo.vkh)"
            }
          },
          {
            "signature": {
              "verification_key": "$(cat coo.vkh)"
            }
          },
          {
            "signature": {
              "verification_key": "$(cat cto.vkh)"
            }
          }
        ],
        "required": 3
      }
    },
    ...
  ]
}
EOF
```

---

### **Step 6: Generate Script Address**

```bash
# Convert script JSON to script format
cat script.json | cardano-address script hash > script.hash

# Build payment address from script
cat script.hash | cardano-address address payment --network-tag mainnet > payment.addr

# View the generated address
cat payment.addr
# Output: addr1w9xxx...yyy (shared payment address)
```

---

### **Step 7: Inspect Address Details**

```bash
# Inspect the generated address
cat payment.addr | cardano-address address inspect
# Output shows:
# - Address type: Script
# - Network: Mainnet
# - Spending key: Script hash
```

---

### **Step 8: Fund the Multi-Sig Address**

Send ADA to the address from any wallet:
```bash
# View address to fund
cat payment.addr

# Fund using any Cardano wallet (Daedalus, Yoroi, etc.)
# Or use cardano-cli if needed for automation
```

---

### **Step 9: Create Multi-Signature Transaction**

For spending from the multi-sig address, you'll need to:

1. **Build Transaction** (using cardano-cli or other tools):
```bash
# You'll still need cardano-cli for transaction building
cardano-cli transaction build \
  --tx-in $(cardano-cli query utxo --address $(cat payment.addr) --mainnet | tail -n 1 | awk '{print $1"#"$2}') \
  --tx-out <recipient-address>+<amount> \
  --change-address $(cat payment.addr) \
  --invalid-before <slot-start> \
  --invalid-hereafter <slot-end> \
  --out-file tx.raw \
  --mainnet
```

2. **Sign with Required Keys**:
```bash
# Each required signer signs the transaction
# Board Chair signs:
cat tx.raw | cardano-address transaction sign --signing-key board.payment.xsk > board.witness

# CFO signs:
cat tx.raw | cardano-address transaction sign --signing-key cfo.payment.xsk > cfo.witness

# COO signs:
cat tx.raw | cardano-address transaction sign --signing-key coo.payment.xsk > coo.witness

# ... collect signatures based on the chosen approval path
```

3. **Assemble and Submit**:
```bash
# Combine witnesses (still requires cardano-cli)
cardano-cli transaction assemble \
  --tx-body-file tx.raw \
  --witness-file board.witness \
  --witness-file cfo.witness \
  --witness-file coo.witness \
  --out-file tx.signed

# Submit
cardano-cli transaction submit --tx-file tx.signed --mainnet
```

---

### **Step 10: Verify Script Hash**

```bash
# Verify the script hash matches
cat script.json | cardano-address script hash

# Compare with policy ID derived from cardano-cli (if available)
# Both should match for security
```

---

## 📊 Signature Matrix

| Scenario | Block 1 | Block 2 | Block 3 | Total Sigs |
|----------|---------|---------|---------|------------|
| Standard Purchase | 3/4 Exec | Path A (Legal+Audit+Treasury) | Simple | 6 |
| Tech Investment | 4/4 Exec | Path A (Legal+Audit+CTO+Treasury) | Strict | 7 |
| Emergency Op | 3/4 Exec | Path B (Ops+Legal) | Simple | 5 |
| M&A Deal | 4/4 Exec | Path A (Legal+Audit+Board+Legal+Treasury) | Strict | 7 |

---

## ⚠️ Security Considerations

### **Key Management:**
- Store private keys in **hardware wallets** (Ledger, Trezor)
- Use **multi-party computation (MPC)** for high-value keys
- Implement **key rotation** procedures annually

### **Operational Security:**
- Never share private keys via email/chat
- Use **air-gapped signing** for large transactions
- Maintain **audit logs** of all signature requests
- Test on **testnet** before mainnet deployment

### **Time Window Management:**
- Monitor current slot number regularly
- Set alerts before window expiration
- Plan signature collection timeline
- Have escalation procedures for Secondary window

### **Disaster Recovery:**
- Document all key holder contacts
- Store backup keys in secure locations
- Test recovery procedures quarterly
- Maintain succession planning for key roles

---

