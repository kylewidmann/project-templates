#!/usr/bin/env python3
"""Sync VERSION files into each package's pyproject.toml [tool.poetry] version field.

Run from repo root:  python scripts/sync_pyproject_versions.py
"""

import re
import sys
from pathlib import Path


SRC_DIR = Path("src")


def read_version(package_dir: Path) -> str | None:
    version_file = package_dir / "VERSION"
    if version_file.exists():
        return version_file.read_text().strip()
    return None


def update_pyproject_version(pyproject_path: Path, version: str) -> bool:
    content = pyproject_path.read_text()
    new_content, count = re.subn(
        r'(?m)(^\[tool\.poetry\].*?^version\s*=\s*")[^"]+(")',
        lambda m: f'{m.group(1)}{version}{m.group(2)}',
        content,
        flags=re.DOTALL,
    )
    if count == 0:
        # Try simple replacement in [tool.poetry] section
        new_content = re.sub(
            r'^(version\s*=\s*)["\'][^"\']*["\']',
            f'\\g<1>"{version}"',
            content,
            count=1,
            flags=re.MULTILINE,
        )
    if new_content == content:
        return False
    pyproject_path.write_text(new_content)
    return True


def main() -> int:
    if not SRC_DIR.exists():
        print(f"ERROR: {SRC_DIR} does not exist. Run from repo root.", file=sys.stderr)
        return 1

    packages = [d for d in SRC_DIR.iterdir() if d.is_dir()]
    if not packages:
        print(f"No packages found under {SRC_DIR}.")
        return 0

    errors = 0
    for package_dir in sorted(packages):
        version = read_version(package_dir)
        if version is None:
            print(f"  SKIP  {package_dir.name}: no VERSION file")
            continue

        pyproject = package_dir / "pyproject.toml"
        if not pyproject.exists():
            print(f"  SKIP  {package_dir.name}: no pyproject.toml")
            continue

        changed = update_pyproject_version(pyproject, version)
        status = "UPDATED" if changed else "OK    "
        print(f"  {status} {package_dir.name}: {version}")

    return errors


if __name__ == "__main__":
    sys.exit(main())
