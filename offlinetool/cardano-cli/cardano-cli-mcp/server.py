"""
Cardano CLI MCP Server

Wraps cardano-cli.exe as MCP tools for use by AI assistants.
Exposes all "no node required" commands: address, key, transaction,
stake address, governance, hash, and CIP-129 commands.

Setup:
  pip install mcp
  python server.py

Configure in your MCP client (e.g. Windsurf/Claude Desktop):
  {
    "mcpServers": {
      "cardano-cli": {
        "command": "python",
        "args": ["d:/Blockchain/tooldev/cardano-cli-win64/cardano-cli-11.0.0.0-win64/cardano-cli-mcp/server.py"],
        "env": {
          "CARDANO_CLI_PATH": "d:/Blockchain/tooldev/cardano-cli-win64/cardano-cli-11.0.0.0-win64/cardano-cli.exe",
          "CARDANO_NETWORK": "mainnet"
        }
      }
    }
  }
"""

import json
from mcp.server.fastmcp import FastMCP

from config import get_network_args, resolve_path, ensure_workspace, WORKSPACE_DIR
from cardano_cli import run_cli, run_cli_with_files

mcp = FastMCP("cardano-cli", instructions=(
    "Cardano CLI MCP Server — wraps cardano-cli.exe for offline operations. "
    "All tools work WITHOUT a running node. Use for key generation, address "
    "building, transaction building/signing, staking certificates, governance, "
    "and hash computation. Files are saved in the workspace directory."
))


# ─── Address Commands ────────────────────────────────────────────────

@mcp.tool()
def address_key_gen(
    vkey_file: str = "payment.vkey",
    skey_file: str = "payment.skey",
    key_type: str = "normal",
) -> str:
    """Generate a payment address key pair (verification + signing key).

    Args:
        vkey_file: Output filename for verification key
        skey_file: Output filename for signing key
        key_type: "normal", "extended", or "byron"
    """
    type_flag = {"normal": "--normal-key", "extended": "--extended-key", "byron": "--byron-key"}
    args = [
        "address", "key-gen",
        "--verification-key-file", str(resolve_path(vkey_file)),
        "--signing-key-file", str(resolve_path(skey_file)),
    ]
    if key_type in type_flag:
        args.append(type_flag[key_type])

    result = run_cli_with_files(args, output_files=[vkey_file, skey_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def address_key_hash(
    vkey_file: str | None = None,
    vkey_string: str | None = None,
    out_file: str | None = None,
) -> str:
    """Print the hash of a payment verification key.

    Args:
        vkey_file: Filename of verification key file
        vkey_string: Bech32-encoded verification key (alternative to file)
        out_file: Optional output filename
    """
    args = ["address", "key-hash"]
    if vkey_file:
        args += ["--payment-verification-key-file", str(resolve_path(vkey_file))]
    elif vkey_string:
        args += ["--payment-verification-key", vkey_string]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


@mcp.tool()
def address_build(
    vkey_file: str | None = None,
    vkey_string: str | None = None,
    payment_script_file: str | None = None,
    stake_vkey_file: str | None = None,
    stake_vkey_string: str | None = None,
    stake_key_hash: str | None = None,
    stake_script_file: str | None = None,
    stake_address: str | None = None,
    network: str | None = None,
    out_file: str = "payment.addr",
) -> str:
    """Build a Shelley payment address, optionally with stake delegation.

    This creates a combined address (payment + stake) when any stake parameter
    is provided. At least one payment source is required.

    Payment source (one required):
        vkey_file: Payment verification key file
        vkey_string: Bech32-encoded payment verification key
        payment_script_file: Payment script file (script-based address)

    Stake source (optional, one of):
        stake_vkey_file: Stake verification key file
        stake_vkey_string: Bech32/hex-encoded stake verification key
        stake_key_hash: Hex-encoded stake key hash
        stake_script_file: Stake script file (script-based staking)
        stake_address: Existing stake address (bech32, e.g. stake1...)

    Args:
        network: "mainnet" or "testnet"
        out_file: Output filename for the address
    """
    args = ["address", "build"]
    # Payment source
    if vkey_file:
        args += ["--payment-verification-key-file", str(resolve_path(vkey_file))]
    elif vkey_string:
        args += ["--payment-verification-key", vkey_string]
    elif payment_script_file:
        args += ["--payment-script-file", str(resolve_path(payment_script_file))]
    # Stake source
    if stake_vkey_file:
        args += ["--stake-verification-key-file", str(resolve_path(stake_vkey_file))]
    elif stake_vkey_string:
        args += ["--stake-verification-key", stake_vkey_string]
    elif stake_key_hash:
        args += ["--stake-key-hash", stake_key_hash]
    elif stake_script_file:
        args += ["--stake-script-file", str(resolve_path(stake_script_file))]
    elif stake_address:
        args += ["--stake-address", stake_address]
    # Network
    args += get_network_args(network)
    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def address_info(address: str, out_file: str | None = None) -> str:
    """Print information about a Cardano address.

    Args:
        address: A Cardano address (bech32)
        out_file: Optional output filename
    """
    args = ["address", "info", "--address", address]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


# ─── Key Commands ────────────────────────────────────────────────────

@mcp.tool()
def key_generate_mnemonic(size: int = 24, out_file: str = "mnemonic.txt") -> str:
    """Generate a mnemonic sentence for key derivation.

    Args:
        size: Number of words (12, 15, 18, 21, or 24)
        out_file: Output filename for the mnemonic
    """
    args = [
        "key", "generate-mnemonic",
        "--size", str(size),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def key_derive_from_mnemonic(
    mnemonic_file: str = "mnemonic.txt",
    key_type: str = "payment",
    key_number: int = 0,
    account_number: int = 0,
    out_file: str = "payment.skey",
) -> str:
    """Derive a signing key from a mnemonic sentence.

    Args:
        mnemonic_file: File containing the mnemonic
        key_type: "payment", "stake", "drep", "cc-cold", or "cc-hot"
        key_number: Payment/stake address number in derivation path
        account_number: Account number in derivation path
        out_file: Output filename for the signing key
    """
    args = [
        "key", "derive-from-mnemonic",
        "--mnemonic-from-file", str(resolve_path(mnemonic_file)),
        "--account-number", str(account_number),
        "--signing-key-file", str(resolve_path(out_file)),
    ]
    type_map = {
        "payment": ("--payment-key-with-number", key_number),
        "stake": ("--stake-key-with-number", key_number),
        "drep": ("--drep-key", None),
        "cc-cold": ("--cc-cold-key", None),
        "cc-hot": ("--cc-hot-key", None),
    }
    if key_type in type_map:
        flag, num = type_map[key_type]
        args.append(flag)
        if num is not None:
            args.append(str(num))

    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def key_verification_key(
    skey_file: str = "payment.skey",
    out_file: str = "payment.vkey",
) -> str:
    """Extract verification key from a signing key.

    Args:
        skey_file: Signing key file
        out_file: Output filename for verification key
    """
    args = [
        "key", "verification-key",
        "--signing-key-file", str(resolve_path(skey_file)),
        "--verification-key-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def key_non_extended_key(
    ext_vkey_file: str,
    out_file: str,
) -> str:
    """Get a non-extended verification key from an extended verification key.

    Args:
        ext_vkey_file: Extended verification key file
        out_file: Output filename for non-extended key
    """
    args = [
        "key", "non-extended-key",
        "--extended-verification-key-file", str(resolve_path(ext_vkey_file)),
        "--verification-key-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


# ─── Stake Address Commands ──────────────────────────────────────────

@mcp.tool()
def stake_address_key_gen(
    vkey_file: str = "stake.vkey",
    skey_file: str = "stake.skey",
) -> str:
    """Generate a stake address key pair.

    Args:
        vkey_file: Output filename for stake verification key
        skey_file: Output filename for stake signing key
    """
    args = [
        "conway", "stake-address", "key-gen",
        "--verification-key-file", str(resolve_path(vkey_file)),
        "--signing-key-file", str(resolve_path(skey_file)),
    ]
    result = run_cli_with_files(args, output_files=[vkey_file, skey_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def stake_address_build(
    vkey_file: str = "stake.vkey",
    network: str | None = None,
    out_file: str = "stake.addr",
) -> str:
    """Build a stake address.

    Args:
        vkey_file: Stake verification key file
        network: "mainnet" or "testnet"
        out_file: Output filename for the stake address
    """
    args = [
        "conway", "stake-address", "build",
        "--stake-verification-key-file", str(resolve_path(vkey_file)),
    ]
    args += get_network_args(network)
    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def stake_address_registration_cert(
    vkey_file: str = "stake.vkey",
    out_file: str = "stake.cert",
) -> str:
    """Create a stake address registration certificate.

    Args:
        vkey_file: Stake verification key file
        out_file: Output filename for the certificate
    """
    args = [
        "conway", "stake-address", "registration-certificate",
        "--stake-verification-key-file", str(resolve_path(vkey_file)),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def stake_address_deregistration_cert(
    vkey_file: str = "stake.vkey",
    out_file: str = "stake-dereg.cert",
) -> str:
    """Create a stake address deregistration certificate.

    Args:
        vkey_file: Stake verification key file
        out_file: Output filename for the certificate
    """
    args = [
        "conway", "stake-address", "deregistration-certificate",
        "--stake-verification-key-file", str(resolve_path(vkey_file)),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def stake_delegation_cert(
    vkey_file: str = "stake.vkey",
    pool_id: str = "",
    out_file: str = "delegation.cert",
) -> str:
    """Create a stake delegation certificate (delegate to a stake pool).

    Args:
        vkey_file: Stake verification key file
        pool_id: Stake pool ID (e.g. pool1...)
        out_file: Output filename for the certificate
    """
    args = [
        "conway", "stake-address", "stake-delegation-certificate",
        "--stake-verification-key-file", str(resolve_path(vkey_file)),
        "--stake-pool-id", pool_id,
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def vote_delegation_cert(
    vkey_file: str = "stake.vkey",
    drep_id: str = "",
    out_file: str = "vote-delegation.cert",
) -> str:
    """Create a vote delegation certificate (delegate voting power to a DRep).

    Args:
        vkey_file: Stake verification key file
        drep_id: DRep ID (bech32)
        out_file: Output filename for the certificate
    """
    args = [
        "conway", "stake-address", "vote-delegation-certificate",
        "--stake-verification-key-file", str(resolve_path(vkey_file)),
        "--drep-id", drep_id,
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


# ─── Transaction Commands ────────────────────────────────────────────

@mcp.tool()
def transaction_build(
    tx_in: list[str] | None = None,
    tx_out: list[str] | None = None,
    change_address: str = "",
    cert_files: list[str] | None = None,
    metadata_json_file: str | None = None,
    era: str = "conway-era",
    out_file: str = "tx.raw",
) -> str:
    """Build a balanced transaction (auto-calculates fees).

    This is the recommended way to build transactions. Requires protocol
    parameters — use transaction_build_raw for offline if no node access.

    Args:
        tx_in: List of transaction inputs (e.g. ["hash#index", ...])
        tx_out: List of outputs (e.g. ["addr1...+1000000", ...])
        change_address: Change address
        cert_files: List of certificate files to include
        metadata_json_file: Metadata JSON file
        era: Era flag ("conway-era", "babbage-era", "alonzo-era")
        out_file: Output filename for the transaction body
    """
    args = ["conway", "transaction", "build", f"--{era}"]

    for txin in (tx_in or []):
        args += ["--tx-in", txin]
    for txout in (tx_out or []):
        args += ["--tx-out", txout]
    if change_address:
        args += ["--change-address", change_address]
    for cert in (cert_files or []):
        args += ["--certificate-file", str(resolve_path(cert))]
    if metadata_json_file:
        args += ["--metadata-json-file", str(resolve_path(metadata_json_file))]

    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file], timeout=180)
    return json.dumps(result, indent=2)


@mcp.tool()
def transaction_build_raw(
    tx_in: list[str] | None = None,
    tx_out: list[str] | None = None,
    fee: int = 0,
    cert_files: list[str] | None = None,
    metadata_json_file: str | None = None,
    mint: list[str] | None = None,
    minting_policy_file: str | None = None,
    era: str = "conway-era",
    out_file: str = "tx.raw",
) -> str:
    """Build a raw transaction (manual fee, no node required).

    Use this for fully offline transaction building.

    Args:
        tx_in: List of transaction inputs
        tx_out: List of outputs
        fee: Fee in lovelace
        cert_files: List of certificate files
        metadata_json_file: Metadata JSON file
        mint: List of mint amounts (e.g. ["policyid.tokenname +1000"])
        minting_policy_file: Minting policy script file
        era: Era flag
        out_file: Output filename
    """
    args = ["conway", "transaction", "build-raw", f"--{era}"]

    for txin in (tx_in or []):
        args += ["--tx-in", txin]
    for txout in (tx_out or []):
        args += ["--tx-out", txout]
    args += ["--fee", str(fee)]
    for cert in (cert_files or []):
        args += ["--certificate-file", str(resolve_path(cert))]
    if metadata_json_file:
        args += ["--metadata-json-file", str(resolve_path(metadata_json_file))]
    for m in (mint or []):
        args += ["--mint", m]
    if minting_policy_file:
        args += ["--minting-policy-file", str(resolve_path(minting_policy_file))]

    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def transaction_sign(
    tx_body_file: str = "tx.raw",
    skey_files: list[str] | None = None,
    out_file: str = "tx.signed",
) -> str:
    """Sign a transaction with one or more signing keys.

    Args:
        tx_body_file: Transaction body file
        skey_files: List of signing key files
        out_file: Output filename for the signed transaction
    """
    args = [
        "conway", "transaction", "sign",
        "--tx-body-file", str(resolve_path(tx_body_file)),
    ]
    for skey in (skey_files or ["payment.skey"]):
        args += ["--signing-key-file", str(resolve_path(skey))]
    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def transaction_witness(
    tx_body_file: str = "tx.raw",
    skey_file: str = "payment.skey",
    out_file: str = "tx.witness",
) -> str:
    """Create a transaction witness for a specific signing key (partial signing).

    Args:
        tx_body_file: Transaction body file
        skey_file: Signing key file
        out_file: Output filename for the witness
    """
    args = [
        "conway", "transaction", "witness",
        "--tx-body-file", str(resolve_path(tx_body_file)),
        "--signing-key-file", str(resolve_path(skey_file)),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def transaction_assemble(
    tx_body_file: str = "tx.raw",
    witness_files: list[str] | None = None,
    out_file: str = "tx.signed",
) -> str:
    """Assemble a transaction body and witnesses into a signed transaction.

    Args:
        tx_body_file: Transaction body file
        witness_files: List of witness files
        out_file: Output filename for the assembled transaction
    """
    args = [
        "conway", "transaction", "assemble",
        "--tx-body-file", str(resolve_path(tx_body_file)),
    ]
    for wf in (witness_files or ["tx.witness"]):
        args += ["--witness-file", str(resolve_path(wf))]
    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def transaction_txid(tx_file: str = "tx.signed") -> str:
    """Print the transaction ID of a signed transaction.

    Args:
        tx_file: Signed transaction file
    """
    args = ["conway", "transaction", "txid", "--tx-file", str(resolve_path(tx_file))]
    result = run_cli(args)
    return json.dumps(result, indent=2)


@mcp.tool()
def transaction_policyid(
    script_file: str,
    out_file: str | None = None,
) -> str:
    """Calculate the Policy ID from a monetary policy script.

    Args:
        script_file: Policy script file
        out_file: Optional output filename
    """
    args = [
        "conway", "transaction", "policyid",
        "--script-file", str(resolve_path(script_file)),
    ]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


@mcp.tool()
def transaction_calculate_min_fee(
    tx_body_file: str = "tx.raw",
    tx_in_count: int = 1,
    tx_out_count: int = 1,
    witness_count: int = 1,
    protocol_params_file: str = "protocol-parameters.json",
) -> str:
    """Calculate the minimum fee for a transaction.

    Args:
        tx_body_file: Transaction body file
        tx_in_count: Number of inputs
        tx_out_count: Number of outputs
        witness_count: Number of witnesses
        protocol_params_file: Protocol parameters JSON file
    """
    args = [
        "conway", "transaction", "calculate-min-fee",
        "--tx-body-file", str(resolve_path(tx_body_file)),
        "--tx-in-count", str(tx_in_count),
        "--tx-out-count", str(tx_out_count),
        "--witness-count", str(witness_count),
        "--protocol-parameters-file", str(resolve_path(protocol_params_file)),
    ]
    result = run_cli(args)
    return json.dumps(result, indent=2)


@mcp.tool()
def transaction_calculate_min_required_utxo(
    tx_out: str,
    protocol_params_file: str = "protocol-parameters.json",
) -> str:
    """Calculate the minimum required UTxO for a transaction output.

    Args:
        tx_out: Transaction output string (addr+lovelace)
        protocol_params_file: Protocol parameters JSON file
    """
    args = [
        "conway", "transaction", "calculate-min-required-utxo",
        "--tx-out", tx_out,
        "--protocol-parameters-file", str(resolve_path(protocol_params_file)),
    ]
    result = run_cli(args)
    return json.dumps(result, indent=2)


@mcp.tool()
def transaction_hash_script_data(
    script_data_file: str,
    out_file: str | None = None,
) -> str:
    """Calculate the hash of script data (for Plutus script transactions).

    Args:
        script_data_file: Script data file
        out_file: Optional output filename
    """
    args = [
        "conway", "transaction", "hash-script-data",
        "--script-data-file", str(resolve_path(script_data_file)),
    ]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


# ─── Governance: DRep Commands ───────────────────────────────────────

@mcp.tool()
def drep_key_gen(
    vkey_file: str = "drep.vkey",
    skey_file: str = "drep.skey",
) -> str:
    """Generate DRep (Delegate Representative) verification and signing keys.

    Args:
        vkey_file: Output filename for DRep verification key
        skey_file: Output filename for DRep signing key
    """
    args = [
        "conway", "governance", "drep", "key-gen",
        "--verification-key-file", str(resolve_path(vkey_file)),
        "--signing-key-file", str(resolve_path(skey_file)),
    ]
    result = run_cli_with_files(args, output_files=[vkey_file, skey_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def drep_id(
    vkey_file: str | None = None,
    vkey_string: str | None = None,
    out_file: str | None = None,
) -> str:
    """Generate a DRep ID from a verification key.

    Args:
        vkey_file: DRep verification key file
        vkey_string: Bech32-encoded DRep verification key
        out_file: Optional output filename
    """
    args = ["conway", "governance", "drep", "id"]
    if vkey_file:
        args += ["--verification-key-file", str(resolve_path(vkey_file))]
    elif vkey_string:
        args += ["--verification-key", vkey_string]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


@mcp.tool()
def drep_registration_cert(
    vkey_file: str = "drep.vkey",
    deposit: int = 500000000,
    stake_vkey_file: str = "stake.vkey",
    out_file: str = "drep.cert",
) -> str:
    """Create a DRep registration certificate.

    Args:
        vkey_file: DRep verification key file
        deposit: Deposit amount in lovelace (default 500 ADA)
        stake_vkey_file: Stake verification key file
        out_file: Output filename for the certificate
    """
    args = [
        "conway", "governance", "drep", "registration-certificate",
        "--drep-verification-key-file", str(resolve_path(vkey_file)),
        "--deposit", str(deposit),
        "--stake-verification-key-file", str(resolve_path(stake_vkey_file)),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def drep_retirement_cert(
    vkey_file: str = "drep.vkey",
    deposit: int = 500000000,
    stake_vkey_file: str = "stake.vkey",
    out_file: str = "drep-retirement.cert",
) -> str:
    """Create a DRep retirement certificate.

    Args:
        vkey_file: DRep verification key file
        deposit: Deposit amount to reclaim
        stake_vkey_file: Stake verification key file
        out_file: Output filename
    """
    args = [
        "conway", "governance", "drep", "retirement-certificate",
        "--drep-verification-key-file", str(resolve_path(vkey_file)),
        "--deposit", str(deposit),
        "--stake-verification-key-file", str(resolve_path(stake_vkey_file)),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def drep_update_cert(
    vkey_file: str = "drep.vkey",
    stake_vkey_file: str = "stake.vkey",
    out_file: str = "drep-update.cert",
) -> str:
    """Create a DRep update certificate (update DRep metadata).

    Args:
        vkey_file: DRep verification key file
        stake_vkey_file: Stake verification key file
        out_file: Output filename
    """
    args = [
        "conway", "governance", "drep", "update-certificate",
        "--drep-verification-key-file", str(resolve_path(vkey_file)),
        "--stake-verification-key-file", str(resolve_path(stake_vkey_file)),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def drep_metadata_hash(
    metadata_file: str,
    out_file: str | None = None,
) -> str:
    """Calculate the hash of a DRep metadata file.

    Args:
        metadata_file: DRep metadata file
        out_file: Optional output filename
    """
    args = [
        "conway", "governance", "drep", "metadata-hash",
        "--drep-metadata-file", str(resolve_path(metadata_file)),
    ]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


# ─── Governance: Vote Commands ───────────────────────────────────────

@mcp.tool()
def governance_vote_create(
    governance_action_id: str,
    drep_vkey_file: str = "drep.vkey",
    vote: str = "YES",
    out_file: str = "vote.json",
) -> str:
    """Create a governance vote.

    Args:
        governance_action_id: Governance action ID (txhash#index)
        drep_vkey_file: DRep verification key file
        vote: "YES", "NO", or "ABSTAIN"
        out_file: Output filename for the vote
    """
    args = [
        "conway", "governance", "vote", "create",
        "--governance-action-id", governance_action_id,
        "--drep-verification-key-file", str(resolve_path(drep_vkey_file)),
        "--vote", vote.upper(),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def governance_vote_view(vote_file: str) -> str:
    """View a governance vote file.

    Args:
        vote_file: Vote file to inspect
    """
    args = [
        "conway", "governance", "vote", "view",
        "--vote-file", str(resolve_path(vote_file)),
    ]
    result = run_cli(args)
    return json.dumps(result, indent=2)


# ─── Governance: Action Commands ─────────────────────────────────────

@mcp.tool()
def governance_action_create_info(
    deposit: int = 1000000000,
    stake_vkey_file: str = "stake.vkey",
    url: str = "",
    out_file: str = "gov-info-action.cert",
) -> str:
    """Create an info governance action.

    Args:
        deposit: Action deposit in lovelace
        stake_vkey_file: Stake verification key file
        url: URL for the action metadata
        out_file: Output filename
    """
    args = [
        "conway", "governance", "action", "create-info",
        "--action-deposit", str(deposit),
        "--stake-verification-key-file", str(resolve_path(stake_vkey_file)),
        "--url", url,
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def governance_action_view(action_file: str) -> str:
    """View a governance action file.

    Args:
        action_file: Governance action file to inspect
    """
    args = [
        "conway", "governance", "action", "view",
        "--governance-action-file", str(resolve_path(action_file)),
    ]
    result = run_cli(args)
    return json.dumps(result, indent=2)


# ─── Hash Commands ───────────────────────────────────────────────────

@mcp.tool()
def hash_anchor_data(
    text: str | None = None,
    file_binary: str | None = None,
    file_text: str | None = None,
    url: str | None = None,
    expected_hash: str | None = None,
    out_file: str | None = None,
) -> str:
    """Compute the hash of anchor data (for governance anchors).

    Provide one of: text, file_binary, file_text, or url.

    Args:
        text: Text to hash as UTF-8
        file_binary: Binary file to hash
        file_text: Text file to hash
        url: URL to the file to hash (HTTP(S) and IPFS)
        expected_hash: Expected hash for verification
        out_file: Optional output filename
    """
    args = ["hash", "anchor-data"]
    if text:
        args += ["--text", text]
    elif file_binary:
        args += ["--file-binary", str(resolve_path(file_binary))]
    elif file_text:
        args += ["--file-text", str(resolve_path(file_text))]
    elif url:
        args += ["--url", url]
    if expected_hash:
        args += ["--expected-hash", expected_hash]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


@mcp.tool()
def hash_script(
    script_file: str,
    out_file: str | None = None,
) -> str:
    """Compute the hash of a script file.

    Args:
        script_file: Script file to hash
        out_file: Optional output filename
    """
    args = [
        "hash", "script",
        "--script-file", str(resolve_path(script_file)),
    ]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


@mcp.tool()
def hash_genesis_file(genesis_file: str) -> str:
    """Compute the hash of a genesis file.

    Args:
        genesis_file: Genesis file to hash
    """
    args = ["hash", "genesis-file", "--genesis", str(resolve_path(genesis_file))]
    result = run_cli(args)
    return json.dumps(result, indent=2)


# ─── Node Key Commands ───────────────────────────────────────────────

@mcp.tool()
def node_key_gen(
    cold_vkey_file: str = "cold.vkey",
    cold_skey_file: str = "cold.skey",
    counter_file: str = "op-cert.counter",
) -> str:
    """Generate node operator cold key pair and certificate counter.

    For stake pool operators.

    Args:
        cold_vkey_file: Cold verification key output
        cold_skey_file: Cold signing key output
        counter_file: Operational certificate issue counter output
    """
    args = [
        "node", "key-gen",
        "--cold-verification-key-file", str(resolve_path(cold_vkey_file)),
        "--cold-signing-key-file", str(resolve_path(cold_skey_file)),
        "--operational-certificate-issue-counter-file", str(resolve_path(counter_file)),
    ]
    result = run_cli_with_files(args, output_files=[cold_vkey_file, cold_skey_file, counter_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def node_key_gen_kes(
    vkey_file: str = "kes.vkey",
    skey_file: str = "kes.skey",
) -> str:
    """Generate KES (Key Evolving Signature) operational key pair.

    Args:
        vkey_file: KES verification key output
        skey_file: KES signing key output
    """
    args = [
        "node", "key-gen-KES",
        "--verification-key-file", str(resolve_path(vkey_file)),
        "--signing-key-file", str(resolve_path(skey_file)),
    ]
    result = run_cli_with_files(args, output_files=[vkey_file, skey_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def node_key_gen_vrf(
    vkey_file: str = "vrf.vkey",
    skey_file: str = "vrf.skey",
) -> str:
    """Generate VRF (Verifiable Random Function) key pair.

    Args:
        vkey_file: VRF verification key output
        skey_file: VRF signing key output
    """
    args = [
        "node", "key-gen-VRF",
        "--verification-key-file", str(resolve_path(vkey_file)),
        "--signing-key-file", str(resolve_path(skey_file)),
    ]
    result = run_cli_with_files(args, output_files=[vkey_file, skey_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def node_issue_op_cert(
    kes_vkey_file: str = "kes.vkey",
    cold_skey_file: str = "cold.skey",
    counter_file: str = "op-cert.counter",
    kes_period: int = 0,
    out_file: str = "op.cert",
) -> str:
    """Issue a node operational certificate.

    Args:
        kes_vkey_file: KES verification key file
        cold_skey_file: Cold signing key file
        counter_file: Operational certificate issue counter file
        kes_period: Start of KES key validity period
        out_file: Output filename for the operational certificate
    """
    args = [
        "node", "issue-op-cert",
        "--kes-verification-key-file", str(resolve_path(kes_vkey_file)),
        "--cold-signing-key-file", str(resolve_path(cold_skey_file)),
        "--operational-certificate-issue-counter-file", str(resolve_path(counter_file)),
        "--kes-period", str(kes_period),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


# ─── Stake Pool Commands ─────────────────────────────────────────────

@mcp.tool()
def stake_pool_id(
    cold_vkey_file: str | None = None,
    cold_vkey_string: str | None = None,
    out_file: str | None = None,
) -> str:
    """Build a stake pool ID from the offline cold key.

    Args:
        cold_vkey_file: Cold verification key file
        cold_vkey_string: Bech32-encoded cold verification key
        out_file: Optional output filename
    """
    args = ["conway", "stake-pool", "id"]
    if cold_vkey_file:
        args += ["--cold-verification-key-file", str(resolve_path(cold_vkey_file))]
    elif cold_vkey_string:
        args += ["--cold-verification-key", cold_vkey_string]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


@mcp.tool()
def stake_pool_metadata_hash(
    pool_metadata_file: str,
    out_file: str | None = None,
) -> str:
    """Calculate the hash of a stake pool metadata file.

    Args:
        pool_metadata_file: Pool metadata file
        out_file: Optional output filename
    """
    args = [
        "conway", "stake-pool", "metadata-hash",
        "--pool-metadata-file", str(resolve_path(pool_metadata_file)),
    ]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


# ─── Utility Commands ────────────────────────────────────────────────

@mcp.tool()
def cli_version() -> str:
    """Get the cardano-cli version."""
    result = run_cli(["version"])
    return json.dumps(result, indent=2)


@mcp.tool()
def list_workspace_files() -> str:
    """List all files in the workspace directory."""
    ws = ensure_workspace()
    files = []
    for f in sorted(ws.iterdir()):
        if f.is_file():
            files.append({
                "name": f.name,
                "size": f.stat().st_size,
            })
    return json.dumps({"files": files, "workspace": str(ws)}, indent=2)


@mcp.tool()
def read_workspace_file(filename: str) -> str:
    """Read the contents of a file in the workspace directory.

    Args:
        filename: Name of the file in the workspace
    """
    p = resolve_path(filename)
    if not p.exists():
        return json.dumps({"error": f"File {filename} not found", "path": str(p)})
    content = p.read_text()
    return json.dumps({"filename": filename, "content": content}, indent=2)


@mcp.tool()
def stake_pool_registration_cert(
    cold_vkey_file: str = "cold.vkey",
    vrf_vkey_file: str = "vrf.vkey",
    pledge: int = 0,
    cost: int = 0,
    margin: str = "0.0",
    reward_account_vkey_file: str = "stake.vkey",
    pool_owner_stake_vkey_file: str = "stake.vkey",
    pool_relay_ipv4: str = "",
    pool_relay_port: int = 0,
    metadata_url: str = "",
    metadata_hash: str | None = None,
    out_file: str = "pool-registration.cert",
) -> str:
    """Create a stake pool registration certificate.

    For stake pool operators.

    Args:
        cold_vkey_file: Cold verification key file
        vrf_vkey_file: VRF verification key file
        pledge: Pledge amount in lovelace
        cost: Fixed cost in lovelace
        margin: Margin (fraction, e.g. "0.05" for 5%)
        reward_account_vkey_file: Reward account stake verification key
        pool_owner_stake_vkey_file: Pool owner stake verification key
        pool_relay_ipv4: Relay IPv4 address
        pool_relay_port: Relay port
        metadata_url: Pool metadata URL
        metadata_hash: Pool metadata hash
        out_file: Output filename
    """
    args = [
        "conway", "stake-pool", "registration-certificate",
        "--cold-verification-key-file", str(resolve_path(cold_vkey_file)),
        "--vrf-verification-key-file", str(resolve_path(vrf_vkey_file)),
        "--pledge", str(pledge),
        "--cost", str(cost),
        "--margin", margin,
        "--reward-account-verification-key-file", str(resolve_path(reward_account_vkey_file)),
        "--pool-owner-stake-verification-key-file", str(resolve_path(pool_owner_stake_vkey_file)),
        "--pool-relay-ipv4", pool_relay_ipv4,
        "--pool-relay-port", str(pool_relay_port),
        "--metadata-url", metadata_url,
    ]
    if metadata_hash:
        args += ["--metadata-hash", metadata_hash]
    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def stake_pool_deregistration_cert(
    cold_vkey_file: str = "cold.vkey",
    epoch: int = 0,
    out_file: str = "pool-deregistration.cert",
) -> str:
    """Create a stake pool deregistration certificate.

    Args:
        cold_vkey_file: Cold verification key file
        epoch: Epoch to retire the pool
        out_file: Output filename
    """
    args = [
        "conway", "stake-pool", "deregistration-certificate",
        "--cold-verification-key-file", str(resolve_path(cold_vkey_file)),
        "--epoch", str(epoch),
        "--out-file", str(resolve_path(out_file)),
    ]
    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


# ─── Multi-Sig (Native Scripts) ──────────────────────────────────────

@mcp.tool()
def create_multisig_script(
    key_hashes: list[str],
    required: int | None = None,
    out_file: str = "multisig.json",
) -> str:
    """Create a multi-sig native script (JSON) from a list of key hashes.

    - If required == len(key_hashes): "all" script (everyone must sign)
    - If required == 1: "any" script (anyone can sign)
    - If 1 < required < len: "atLeast" script (M-of-N multi-sig)

    Args:
        key_hashes: List of hex-encoded payment key hashes
        required: Number of required signatures (default: all)
        out_file: Output filename for the script JSON
    """
    n = len(key_hashes)
    if required is None:
        required = n

    if required == n:
        script_type = "all"
    elif required == 1:
        script_type = "any"
    else:
        script_type = "atLeast"

    script: dict
    if script_type in ("all", "any"):
        script = {
            "type": script_type,
            "scripts": [
                {"type": "sig", "keyHash": kh} for kh in key_hashes
            ],
        }
    else:
        script = {
            "type": "atLeast",
            "required": required,
            "scripts": [
                {"type": "sig", "keyHash": kh} for kh in key_hashes
            ],
        }

    p = resolve_path(out_file)
    p.write_text(json.dumps(script, indent=2))
    return json.dumps({
        "success": True,
        "script_type": script_type,
        "required": required,
        "total_keys": n,
        "out_file": str(p),
        "script": script,
    }, indent=2)


@mcp.tool()
def create_time_locked_multisig_script(
    key_hashes: list[str],
    required: int | None = None,
    before_slot: int | None = None,
    after_slot: int | None = None,
    out_file: str = "multisig-timelock.json",
) -> str:
    """Create a time-locked multi-sig native script.

    Combines M-of-N multi-sig with a time-lock constraint.
    Use before_slot for "valid until" or after_slot for "valid from".

    Args:
        key_hashes: List of hex-encoded payment key hashes
        required: Number of required signatures (default: all)
        before_slot: Transaction valid only before this slot
        after_slot: Transaction valid only after this slot
        out_file: Output filename
    """
    n = len(key_hashes)
    if required is None:
        required = n

    inner_scripts: list[dict] = [
        {"type": "sig", "keyHash": kh} for kh in key_hashes
    ]

    if required < n and required > 1:
        multisig = {
            "type": "atLeast",
            "required": required,
            "scripts": inner_scripts,
        }
    elif required == 1:
        multisig = {
            "type": "any",
            "scripts": inner_scripts,
        }
    else:
        multisig = {
            "type": "all",
            "scripts": inner_scripts,
        }

    all_scripts: list[dict] = [multisig]
    if before_slot is not None:
        all_scripts.append({"type": "before", "slot": before_slot})
    if after_slot is not None:
        all_scripts.append({"type": "after", "slot": after_slot})

    script: dict
    if len(all_scripts) == 1:
        script = multisig
    else:
        script = {"type": "all", "scripts": all_scripts}

    p = resolve_path(out_file)
    p.write_text(json.dumps(script, indent=2))
    return json.dumps({
        "success": True,
        "required": required,
        "total_keys": n,
        "before_slot": before_slot,
        "after_slot": after_slot,
        "out_file": str(p),
        "script": script,
    }, indent=2)


@mcp.tool()
def multisig_address_build(
    script_file: str = "multisig.json",
    stake_script_file: str | None = None,
    network: str | None = None,
    out_file: str = "multisig.addr",
) -> str:
    """Build a multi-sig payment address from a native script.

    Args:
        script_file: Payment script JSON file (multi-sig script)
        stake_script_file: Optional stake script file for staking
        network: "mainnet" or "testnet"
        out_file: Output filename for the address
    """
    args = ["address", "build", "--payment-script-file", str(resolve_path(script_file))]
    if stake_script_file:
        args += ["--stake-script-file", str(resolve_path(stake_script_file))]
    args += get_network_args(network)
    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def multisig_transaction_build(
    tx_in: list[str] | None = None,
    tx_in_script_file: str = "multisig.json",
    tx_out: list[str] | None = None,
    change_address: str = "",
    cert_files: list[str] | None = None,
    metadata_json_file: str | None = None,
    era: str = "conway-era",
    out_file: str = "tx.raw",
) -> str:
    """Build a transaction spending from a multi-sig (script) address.

    The script file must match the one used to create the address.
    Each required signer must create a witness separately.

    Args:
        tx_in: List of transaction inputs from the multi-sig address
        tx_in_script_file: The multi-sig script JSON file
        tx_out: List of outputs
        change_address: Change address (usually the multi-sig address itself)
        cert_files: List of certificate files
        metadata_json_file: Metadata JSON file
        era: Era flag
        out_file: Output filename
    """
    args = ["conway", "transaction", "build", f"--{era}"]

    for txin in (tx_in or []):
        args += ["--tx-in", txin, "--tx-in-script-file", str(resolve_path(tx_in_script_file))]
    for txout in (tx_out or []):
        args += ["--tx-out", txout]
    if change_address:
        args += ["--change-address", change_address]
    for cert in (cert_files or []):
        args += ["--certificate-file", str(resolve_path(cert))]
    if metadata_json_file:
        args += ["--metadata-json-file", str(resolve_path(metadata_json_file))]

    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file], timeout=180)
    return json.dumps(result, indent=2)


@mcp.tool()
def multisig_transaction_build_raw(
    tx_in: list[str] | None = None,
    tx_in_script_file: str = "multisig.json",
    tx_out: list[str] | None = None,
    fee: int = 0,
    era: str = "conway-era",
    out_file: str = "tx.raw",
) -> str:
    """Build a raw multi-sig transaction (offline, manual fee).

    Args:
        tx_in: List of transaction inputs from the multi-sig address
        tx_in_script_file: The multi-sig script JSON file
        tx_out: List of outputs
        fee: Fee in lovelace
        era: Era flag
        out_file: Output filename
    """
    args = ["conway", "transaction", "build-raw", f"--{era}"]

    for txin in (tx_in or []):
        args += ["--tx-in", txin, "--tx-in-script-file", str(resolve_path(tx_in_script_file))]
    for txout in (tx_out or []):
        args += ["--tx-out", txout]
    args += ["--fee", str(fee)]
    args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli_with_files(args, output_files=[out_file])
    return json.dumps(result, indent=2)


@mcp.tool()
def get_key_hashes(vkey_files: list[str]) -> str:
    """Get payment key hashes for multiple verification key files at once.

    Useful for collecting key hashes when building a multi-sig script.

    Args:
        vkey_files: List of verification key filenames
    """
    results = {}
    for vf in vkey_files:
        args = ["address", "key-hash", "--payment-verification-key-file", str(resolve_path(vf))]
        r = run_cli(args)
        results[vf] = r["stdout"] if r["success"] else r["stderr"]
    return json.dumps({"key_hashes": results}, indent=2)


@mcp.tool()
def script_hash(script_file: str, out_file: str | None = None) -> str:
    """Compute the hash of a native script file.

    Args:
        script_file: Script JSON file
        out_file: Optional output filename
    """
    args = ["hash", "script", "--script-file", str(resolve_path(script_file))]
    if out_file:
        args += ["--out-file", str(resolve_path(out_file))]

    result = run_cli(args)
    return json.dumps(result, indent=2)


# ─── Server Entry Point ──────────────────────────────────────────────

if __name__ == "__main__":
    ensure_workspace()
    print(f"Cardano CLI MCP Server starting...")
    print(f"  CLI: {CARDANO_CLI}")
    print(f"  Workspace: {WORKSPACE_DIR}")
    mcp.run()
