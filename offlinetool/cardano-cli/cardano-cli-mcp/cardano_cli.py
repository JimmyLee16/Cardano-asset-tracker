"""Wrapper utility for calling cardano-cli.exe via subprocess."""

import subprocess
import shutil
from pathlib import Path
from typing import Optional

from config import CARDANO_CLI, resolve_path


def run_cli(args: list[str], *, timeout: int = 120) -> dict:
    """
    Execute cardano-cli.exe with the given arguments.

    Returns a dict with:
      - success: bool
      - stdout: str
      - stderr: str
      - returncode: int
    """
    cmd = [CARDANO_CLI] + args

    # Verify the binary exists
    if not Path(CARDANO_CLI).exists():
        # Try finding it in PATH
        found = shutil.which("cardano-cli") or shutil.which("cardano-cli.exe")
        if found:
            cmd[0] = found
        else:
            return {
                "success": False,
                "stdout": "",
                "stderr": f"cardano-cli not found at {CARDANO_CLI}. Set CARDANO_CLI_PATH env var.",
                "returncode": -1,
            }

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=timeout,
        )
        return {
            "success": result.returncode == 0,
            "stdout": result.stdout.strip(),
            "stderr": result.stderr.strip(),
            "returncode": result.returncode,
        }
    except subprocess.TimeoutExpired:
        return {
            "success": False,
            "stdout": "",
            "stderr": f"Command timed out after {timeout}s",
            "returncode": -1,
        }
    except Exception as e:
        return {
            "success": False,
            "stdout": "",
            "stderr": str(e),
            "returncode": -1,
        }


def run_cli_with_files(
    args: list[str],
    *,
    output_files: Optional[list[str]] = None,
    timeout: int = 120,
) -> dict:
    """
    Execute cardano-cli and also read back any output files.

    Returns the run_cli result plus a 'files' dict mapping filename -> content.
    """
    result = run_cli(args, timeout=timeout)

    files = {}
    if output_files and result["success"]:
        for fname in output_files:
            p = resolve_path(fname)
            if p.exists():
                files[fname] = p.read_text()

    result["files"] = files
    return result
