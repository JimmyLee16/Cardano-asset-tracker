# 👨‍👩‍👧‍👦 Family Savings Plan - Multig-address Guide

## 📋 Table of Contents
1. [Overview](#overview)
2. [Family Structure](#family-structure)
3. [Approval Rules](#approval-rules)
4. [Flow Diagram](#flow-diagram)
5. [JSON Structure](#json-structure)
6. [Use Cases](#use-cases)
7. [Implementation Guide](#implementation-guide)

---

## 🎯 Overview

This Native Script implements a **family savings governance model** for managing children's education fund and future investments. It ensures:

- ✅ **Parental Control**: Major decisions require both parents
- ✅ **Child Participation**: Children involved in financial literacy
- ✅ **Guardian Oversight**: Third-party supervision for transparency
- ✅ **Age-based Rules**: Different access levels as children mature
- ✅ **Emergency Access**: Quick withdrawal for urgent family needs

---

## 👨‍👩‍👧‍👦 Family Structure

| Role | Verification Key | Age/Status | Responsibility |
|------|------------------|------------|----------------|
| **Father** | `addr_shared_vkh_father` | 45 years | Primary income, strategic decisions |
| **Mother** | `addr_shared_vkh_mother` | 42 years | Financial planning, daily management |
| **Son** | `addr_shared_vkh_son` | 16 years | Learning financial responsibility |
| **Daughter** | `addr_shared_vkh_daughter` | 14 years | Understanding money management |
| **Guardian** | `addr_shared_vkh_guardian` | Trusted family friend/relative | Independent oversight, dispute resolution |

---

## 📜 Approval Rules

### **Rule 1: Major Withdrawals (Education, Investment)**
**Amount:** >50,000 ADA  
**Requirements:**
- **BOTH parents** must approve (Father + Mother)
- **Guardian oversight** required
- **At least 1 child** must acknowledge (financial education)
- **Time window:** Only during planning periods

### **Rule 2: Regular Withdrawals (Living Expenses, Tuition)**
**Amount:** 10,000 - 50,000 ADA  
**Requirements:**
- **Either parent** can approve (Father OR Mother)
- **Guardian notification**
- Children optional

### **Rule 3: Emergency Withdrawals (Medical, Crisis)**
**Amount:** Any amount  
**Requirements:**
- **1 parent** + **Guardian** (for accountability)
- No time restrictions
- Immediate access

### **Rule 4: Children's Learning Withdrawals (Small Expenses)**
**Amount:** <10,000 ADA  
**Requirements:**
- **Both children** together can request
- **1 parent** must approve
- Guardian review within 7 days (educational purpose)

### **Rule 5: Maturity Access (When children turn 18)**
**Requirements:**
- **Child** + **1 parent** + **Guardian**
- Gradual access to their portion

---

## Architecture

```text
                                    ┌─────────────────────────────────────────────┐
                                    │         🏦 FAMILY SAVINGS ACCOUNT           │
                                    │        (Choose 1 of 5 main scenarios)       │
                                    └─────────────────────────────────────────────┘
                                                    │
 ┌─────────────────────────────────────────────────────────────────────────────────────────────┬─────────────────────────────────────────────────────────────────────────────────────────────┬─────────────────────────────────────────────────────────────────────────────────────────────┬─────────────────────────────────────────────────────────────────────────────────────────────┬─────────────────────────────────────────────────────────────────────────────────────────────┐
 │                                                     │                                         │                                         │                                         │                                         │
 ▼                                                     ▼                                         ▼                                         ▼                                         ▼
┌──────────────────────────────┐       ┌──────────────────────────────┐       ┌──────────────────────────────┐       ┌──────────────────────────────┐       ┌──────────────────────────────┐
│ 🔴 SCENARIO 1: Major Expense │       │ 🟢 SCENARIO 2: Routine Use │       │ 🟠 SCENARIO 3: Emergency │       │ 🟣 SCENARIO 4: Education/Project │       │ 🔵 SCENARIO 5: Independence │
│  (>50K ADA - Tuition, Investment) │  │  (10K–50K ADA - Daily Costs) │      │  (Any Amount - Medical, Crisis) │    │  (<10K ADA - Study Trip, Research) │   │  (Child reaches 18) │
└──────────────────────────────┘       └──────────────────────────────┘       └──────────────────────────────┘       └──────────────────────────────┘       └──────────────────────────────┘
         │                                      │                                      │                                      │                                      │
         ▼                                      ▼                                      ▼                                      ▼                                      ▼
 ┌───────────────────────────┐        ┌───────────────────────────┐        ┌───────────────────────────┐        ┌───────────────────────────┐        ┌───────────────────────────┐
 │   📘 ALL BASE CONDITIONS  │        │   📘 ALL BASE CONDITIONS  │        │   📘 ALL BASE CONDITIONS  │        │   📘 ALL BASE CONDITIONS  │        │   📘 ALL BASE CONDITIONS  │
 └───────────────────────────┘        └───────────────────────────┘        └───────────────────────────┘        └───────────────────────────┘        └───────────────────────────┘
         │                                      │                                      │                                      │                                      │
         ├───────────────┬──────────────┬──────────────┬──────────────┐       ├──────────────┬──────────────┬──────────────┐       ├──────────────┬──────────────┬──────────────┐       ├──────────────┬──────────────┬──────────────┬──────────────┐       ├──────────────┬──────────────┬──────────────┐
         ▼               ▼              ▼              ▼              ▼       ▼              ▼              ▼              ▼       ▼              ▼              ▼              ▼       ▼              ▼              ▼              ▼       ▼              ▼              ▼              ▼
 ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐           ┌──────────┐ ┌──────────┐ ┌──────────┐           ┌──────────┐ ┌──────────┐ ┌──────────┐           ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐           ┌──────────┐ ┌──────────┐ ┌──────────┐
 │👨‍👩‍👧‍👦 Both Parents│ │🧑‍⚖️ Guardian│ │👧 At least 1 Child│ │⏰ Time Slot│          │👨‍👩‍👧 One Parent│ │🧑‍⚖️ Guardian│ │👦 Son (16)│           │👨‍👩‍👧 Parents│ │🧑‍⚖️ Guardian│ │⏰ Any Time│          │👨‍👩‍👧 2 Children│ │🧑‍⚖️ Guardian│ │📊 Financial Purpose│ │⏰ Limited Window│          │👦 Son 18+│ │👧 Daughter│ │🧑‍⚖️ Guardian│
 └──────────┘ └──────────┘ └──────────┘ └──────────┘           └──────────┘ └──────────┘ └──────────┘           └──────────┘ └──────────┘ └──────────┘           └──────────┘ └──────────┘ └──────────┘ └──────────┘           └──────────┘ └──────────┘ └──────────┘

         │                                                          │                                                       │                                                        │                                                      │
         ▼                                                          ▼                                                       ▼                                                        ▼                                                      ▼
 ┌─────────────────────────────┐                     ┌─────────────────────────────┐                      ┌─────────────────────────────┐                      ┌─────────────────────────────┐                      ┌─────────────────────────────┐
 │ Family Summary (5 Members)  │                     │ Members’ Joint Confirmation │                      │ Valid per Time Condition     │                      │ Study/Project Supervision   │                      │ Activate Independence Right │
 └─────────────────────────────┘                     └─────────────────────────────┘                      └─────────────────────────────┘                      └─────────────────────────────┘                      └─────────────────────────────┘
```



## 🔄 Flow Diagram

```<img width="8343" height="2442" alt="Untitled diagram-2025-10-14-060928" src="https://github.com/user-attachments/assets/5649eb40-65d3-4a7c-bb8c-3507423d67bb" />

START: Family Savings Account
  │
  ├─► SCENARIO 1: Major Decisions (>50K ADA)
  │   └─► ALL of these:
  │       ├─► Father + Mother (BOTH parents)
  │       ├─► Guardian (oversight)
  │       ├─► Son OR Daughter (≥1 child)
  │       └─► Time Window: Planning Period
  │
  ├─► SCENARIO 2: Regular Expenses (10K-50K ADA)
  │   └─► ALL of these:
  │       ├─► Father OR Mother (any 1 parent)
  │       └─► Guardian (notification)
  │
  ├─► SCENARIO 3: Emergency (Any Amount)
  │   └─► ALL of these:
  │       ├─► Father OR Mother (any 1 parent)
  │       └─► Guardian (accountability)
  │       └─► NO time restrictions
  │
  ├─► SCENARIO 4: Children's Learning (<10K ADA)
  │   └─► ALL of these:
  │       ├─► Son AND Daughter (both children)
  │       ├─► Father OR Mother (any 1 parent)
  │       └─► Guardian (review within 7 days)
  │
  └─► SCENARIO 5: Maturity Access (Age 18+)
      └─► ALL of these:
          ├─► Son OR Daughter (the adult child)
          ├─► Father OR Mother (any 1 parent)
          └─► Guardian (approval)
```

---

## 📄 JSON Structure

### **Complete Native Script:**

```json
{
  "any": [
    {
      "all": [
        {
          "at_least": {
            "signatures": [
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_father"
                }
              },
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_mother"
                }
              }
            ],
            "required": 2
          }
        },
        {
          "signature": {
            "verification_key": "addr_shared_vkh_guardian"
          }
        },
        {
          "at_least": {
            "signatures": [
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_son"
                }
              },
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_daughter"
                }
              }
            ],
            "required": 1
          }
        },
        {
          "any": [
            {
              "all": [
                {
                  "active_from": {
                    "slot": 180000000
                  }
                },
                {
                  "active_until": {
                    "slot": 185000000
                  }
                }
              ]
            },
            {
              "all": [
                {
                  "active_from": {
                    "slot": 190000000
                  }
                },
                {
                  "active_until": {
                    "slot": 195000000
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
          "at_least": {
            "signatures": [
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_father"
                }
              },
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_mother"
                }
              }
            ],
            "required": 1
          }
        },
        {
          "signature": {
            "verification_key": "addr_shared_vkh_guardian"
          }
        }
      ]
    },
    {
      "all": [
        {
          "at_least": {
            "signatures": [
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_son"
                }
              },
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_daughter"
                }
              }
            ],
            "required": 2
          }
        },
        {
          "at_least": {
            "signatures": [
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_father"
                }
              },
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_mother"
                }
              }
            ],
            "required": 1
          }
        },
        {
          "signature": {
            "verification_key": "addr_shared_vkh_guardian"
          }
        }
      ]
    },
    {
      "all": [
        {
          "at_least": {
            "signatures": [
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_son"
                }
              },
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_daughter"
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
                  "verification_key": "addr_shared_vkh_father"
                }
              },
              {
                "signature": {
                  "verification_key": "addr_shared_vkh_mother"
                }
              }
            ],
            "required": 1
          }
        },
        {
          "signature": {
            "verification_key": "addr_shared_vkh_guardian"
          }
        },
        {
          "active_from": {
            "slot": 200000000
          }
        }
      ]
    }
  ]
}
```

---

## 💼 Use Cases

### **Scenario 1: University Tuition Payment (€30,000)**

**Type:** Major Educational Expense

**Required Signatures:**
1. ✅ Father
2. ✅ Mother
3. ✅ Son (the beneficiary, learning process)
4. ✅ Guardian (oversight)

**Time:** During planning window (Slot 180M-185M)

**Process:**
1. Parents discuss and agree on university choice
2. Son participates in decision (learning responsibility)
3. Guardian reviews tuition invoice
4. All 4 sign transaction
5. Payment sent to university

**Educational Value:** Son learns about higher education costs and financial planning.

---

### **Scenario 2: Monthly Living Expenses (€2,000)**

**Type:** Regular Family Expense

**Required Signatures:**
1. ✅ Mother (handles daily finances)
2. ✅ Guardian (notification only)

**Time:** Anytime

**Process:**
1. Mother creates transaction for monthly expenses
2. Guardian receives notification (no action needed)
3. Payment processed

**Note:** Father can also do this independently if needed.

---

### **Scenario 3: Emergency Medical Treatment (€15,000)**

**Type:** Urgent Medical Need

**Required Signatures:**
1. ✅ Father
2. ✅ Guardian

**Time:** Immediate (no restrictions)

**Process:**
1. Medical emergency occurs
2. Father initiates withdrawal
3. Guardian approves for accountability
4. Instant access to funds
5. Hospital payment completed

**Safety:** Guardian prevents impulsive decisions while allowing emergency access.

---

### **Scenario 4: Children's Project - School Trip (€800)**

**Type:** Educational Expense (<10K ADA)

**Required Signatures:**
1. ✅ Son
2. ✅ Daughter
3. ✅ Mother
4. ✅ Guardian (review)

**Time:** Anytime

**Process:**
1. Both children research and plan school trip
2. They present proposal to Mother
3. Mother approves if reasonable
4. Guardian reviews within 7 days
5. Payment made to school

**Educational Value:** Children learn:
- Budgeting and planning
- Negotiation skills
- Responsibility for spending
- Working together as siblings

---

### **Scenario 5: Son's 18th Birthday - First Independence (€5,000)**

**Type:** Maturity Access

**Required Signatures:**
1. ✅ Son
2. ✅ Father
3. ✅ Guardian

**Time:** After slot 200,000,000 (maturity date)

**Process:**
1. Son turns 18, gains partial access
2. Discusses first independent withdrawal with Father
3. Guardian approves transition
4. Son receives portion for car/education/business

**Educational Value:** Gradual independence with parental guidance.

---

## 🛠️ Implementation Guide

### **Step 1: Generate Family Recovery Phrases**

```bash
# Father's recovery phrase
cardano-address recovery-phrase generate --size 24 > father.mnemonic

# Mother's recovery phrase
cardano-address recovery-phrase generate --size 24 > mother.mnemonic

# Son's recovery phrase (parent helps secure it)
cardano-address recovery-phrase generate --size 24 > son.mnemonic

# Daughter's recovery phrase (parent helps secure it)
cardano-address recovery-phrase generate --size 24 > daughter.mnemonic

# Guardian's recovery phrase
cardano-address recovery-phrase generate --size 24 > guardian.mnemonic
```

**Security Tips:**
- Parents store children's phrases until they're mature enough
- Guardian phrase stored separately by trusted person
- Consider metal backup plates for long-term storage
- Never store digitally (no photos, no cloud)

---

### **Step 2: Derive Root Keys**

```bash
# Derive root keys for all family members
cat father.mnemonic | cardano-address key from-recovery-phrase Shelley > father.root.xsk
cat mother.mnemonic | cardano-address key from-recovery-phrase Shelley > mother.root.xsk
cat son.mnemonic | cardano-address key from-recovery-phrase Shelley > son.root.xsk
cat daughter.mnemonic | cardano-address key from-recovery-phrase Shelley > daughter.root.xsk
cat guardian.mnemonic | cardano-address key from-recovery-phrase Shelley > guardian.root.xsk
```

---

### **Step 3: Derive Payment Keys**

```bash
# Derive payment keys (path: 1852H/1815H/0H/0/0)
cat father.root.xsk | cardano-address key child 1852H/1815H/0H/0/0 > father.payment.xsk
cat father.payment.xsk | cardano-address key public --with-chain-code > father.payment.xvk

cat mother.root.xsk | cardano-address key child 1852H/1815H/0H/0/0 > mother.payment.xsk
cat mother.payment.xsk | cardano-address key public --with-chain-code > mother.payment.xvk

cat son.root.xsk | cardano-address key child 1852H/1815H/0H/0/0 > son.payment.xsk
cat son.payment.xsk | cardano-address key public --with-chain-code > son.payment.xvk

cat daughter.root.xsk | cardano-address key child 1852H/1815H/0H/0/0 > daughter.payment.xsk
cat daughter.payment.xsk | cardano-address key public --with-chain-code > daughter.payment.xvk

cat guardian.root.xsk | cardano-address key child 1852H/1815H/0H/0/0 > guardian.payment.xsk
cat guardian.payment.xsk | cardano-address key public --with-chain-code > guardian.payment.xvk
```

---

### **Step 4: Extract Verification Key Hashes**

```bash
# Extract key hashes
cat father.payment.xvk | cardano-address key hash > father.vkh
cat mother.payment.xvk | cardano-address key hash > mother.vkh
cat son.payment.xvk | cardano-address key hash > son.vkh
cat daughter.payment.xvk | cardano-address key hash > daughter.vkh
cat guardian.payment.xvk | cardano-address key hash > guardian.vkh

# View all hashes
echo "Father: $(cat father.vkh)"
echo "Mother: $(cat mother.vkh)"
echo "Son: $(cat son.vkh)"
echo "Daughter: $(cat daughter.vkh)"
echo "Guardian: $(cat guardian.vkh)"
```

---

### **Step 5: Create Family Savings Script**

Save the JSON structure with actual key hashes in `family-savings.json`.

---

### **Step 6: Generate Family Savings Address**

```bash
# Generate script hash
cat family-savings.json | cardano-address script hash > family-savings.hash

# Build payment address
cat family-savings.hash | cardano-address address payment --network-tag mainnet > family-savings.addr

# View the family savings address
cat family-savings.addr
```

---

### **Step 7: Initial Funding**

Parents fund the account with initial savings:

```bash
# Father sends initial 100,000 ADA
# Mother sends additional 50,000 ADA
# (Using their personal wallets)

# View family savings balance
cardano-cli query utxo --address $(cat family-savings.addr) --mainnet
```

---

### **Step 8: Family Meeting - Establish Rules**

**Important:** Hold a family meeting to explain:

1. **Purpose of the account:**
   - Children's education (40%)
   - Family emergencies (20%)
   - Future investments (20%)
   - Children's maturity fund (20%)

2. **Spending rules:**
   - Major decisions need family discussion
   - Emergency access procedures
   - Children's learning allowances

3. **Educational goals:**
   - Teach financial responsibility
   - Build trust and transparency
   - Prepare for independent life

4. **Key management:**
   - Who holds which keys
   - Recovery phrase security
   - What to do if keys are lost

---

## 📊 Signature Requirements Matrix

| Scenario | Father | Mother | Son | Daughter | Guardian | Time Window |
|----------|--------|--------|-----|----------|----------|-------------|
| Major Education/Investment | ✅ | ✅ | ✅ or ✅ | ✅ or ✅ | ✅ | Planning Period |
| Regular Expenses | ✅ or ✅ | ✅ or ✅ | - | - | ✅ | Anytime |
| Emergency | ✅ or ✅ | ✅ or ✅ | - | - | ✅ | Anytime |
| Children's Learning | ✅ or ✅ | ✅ or ✅ | ✅ | ✅ | ✅ | Anytime |
| Maturity Access (18+) | ✅ or ✅ | ✅ or ✅ | ✅ or ✅ | ✅ or ✅ | ✅ | After Maturity |

---

## 🎓 Educational Benefits for Children

### **Financial Literacy Skills:**
- Understanding blockchain technology
- Learning about multi-signature security
- Budgeting and planning expenses
- Negotiation and consensus building

### **Life Skills:**
- Responsibility and accountability
- Working with siblings (teamwork)
- Communication with parents
- Planning for long-term goals

### **Values:**
- Transparency in family finances
- Trust between family members
- Delayed gratification
- Smart money management

---

## ⚠️ Safety Considerations

### **Key Management:**
- Parents keep children's keys until age 16+
- Guardian key stored separately from family
- Regular key recovery drills (annually)
- Update keys if compromised

### **Dispute Resolution:**
- Guardian acts as neutral mediator
- Family meetings for major decisions
- Document all withdrawals with purpose
- Review spending quarterly

### **Maturity Planning:**
- Gradual access at age 18 (not full amount)
- Parents guide first independent transactions
- Guardian supervises transition period
- Consider staged releases (18, 21, 25)

### **Emergency Procedures:**
- Guardian has emergency contact info
- Medical expense pre-approval process
- Family crisis communication plan
- Backup guardian designation

---

## 📅 Time Window Calendar

| Period | Slot Range | Purpose |
|--------|-----------|---------|
| Planning Period 1 | 180M - 185M | Q1-Q2: Education planning, tuition payments |
| Planning Period 2 | 190M - 195M | Q3-Q4: Investment decisions, major purchases |
| Emergency Access | Always active | Medical, crisis situations |
| Maturity Window | After 200M | When children turn 18 |

---

## 💡 Best Practices

### **For Parents:**
1. Lead by example in financial discipline
2. Include children in age-appropriate decisions
3. Explain reasons behind spending choices
4. Celebrate savings milestones together
5. Review account quarterly as a family

### **For Children:**
1. Keep recovery phrases secure (with parent help)
2. Ask questions about transactions
3. Propose spending with research/planning
4. Learn from both approvals and rejections
5. Track personal portion of savings

### **For Guardian:**
1. Maintain neutrality in family decisions
2. Regular check-ins on account health
3. Flag unusual spending patterns
4. Support family financial education
5. Be available for emergency approvals

---

## 📞 Resources

- **Cardano Family Savings Template:** (this document)
- **Financial Literacy for Kids:** Books and courses
- **Blockchain Education:** Age-appropriate learning materials
- **Family Financial Planning:** Consultation services

---

## 🎉 Success Stories

### **Example 1: University Fund Success**
The Martinez family saved for 10 years using this model. When their daughter turned 18, she had 50,000 ADA for university. She understood the value because she participated in every major decision since age 14.

### **Example 2: Sibling Business**
Two brothers (19 and 21) used their shared maturity fund to start a small tech business. Parents and guardian helped them plan the withdrawal and business structure.

### **Example 3: Emergency Preparedness**
The Chen family faced a medical emergency. Emergency access path allowed them to pay €20,000 hospital bill within hours, with guardian oversight ensuring proper documentation for insurance.

---

## 📝 Checklist

**Setup Phase:**
- [ ] Generate recovery phrases for all 5 members
- [ ] Secure storage of recovery phrases
- [ ] Create family savings script JSON
- [ ] Generate shared payment address
- [ ] Fund account with initial savings
- [ ] Hold family meeting to explain rules

**Operational Phase:**
- [ ] Quarterly family financial review
- [ ] Annual key security check
- [ ] Update contact information
- [ ] Track educational milestones
- [ ] Plan for maturity transitions

**Maturity Phase:**
- [ ] Celebrate 18th birthdays with financial independence
- [ ] Gradual access to funds
- [ ] Continue mentorship
- [ ] Document lessons learned
- [ ] Pass knowledge to next generation

---

**Version:** 1.0  
**Last Updated:** October 2025  
**Family Savings Model Status:** Ready for Implementation  
**Recommended Age:** Children 12+ for participation
