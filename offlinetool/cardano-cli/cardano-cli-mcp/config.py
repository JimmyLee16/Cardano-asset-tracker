"""Configuration for Cardano CLI MCP Server."""

import os
from pathlib import Path

# Path to cardano-cli.exe — auto-detect from common locations
DEFAULT_CLI_DIR = Path(__file__).parent.parent

CARDANO_CLI = os.environ.get(
    "CARDANO_CLI_PATH",
    str(DEFAULT_CLI_DIR / "cardano-cli.exe"),
)

# Default network: "mainnet" or "testnet"
DEFAULT_NETWORK = os.environ.get("CARDANO_NETWORK", "mainnet")

# Default testnet magic (preview = 2, preprod = 1)
DEFAULT_TESTNET_MAGIC = int(os.environ.get("CARDANO_TESTNET_MAGIC", "2"))

# Working directory for key/tx files (defaults to a "workspace" subfolder)
WORKSPACE_DIR = Path(
    os.environ.get(
        "CARDANO_WORKSPACE",
        str(DEFAULT_CLI_DIR / "workspace"),
    )
)


def get_network_args(network: str | None = None) -> list[str]:
    """Return --mainnet or --testnet-magic N based on network choice."""
    net = network or DEFAULT_NETWORK
    if net == "mainnet":
        return ["--mainnet"]
    else:
        return ["--testnet-magic", str(DEFAULT_TESTNET_MAGIC)]


def ensure_workspace() -> Path:
    """Create workspace directory if it doesn't exist."""
    WORKSPACE_DIR.mkdir(parents=True, exist_ok=True)
    return WORKSPACE_DIR


def resolve_path(filename: str) -> Path:
    """Resolve a filename to an absolute path inside the workspace."""
    p = Path(filename)
    if p.is_absolute():
        return p
    return ensure_workspace() / filename
