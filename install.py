#!/usr/bin/env python3
import argparse
import os
import subprocess
from pathlib import Path

ROOT_DIR = Path(__file__).parent.absolute()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--overwrite",
        "-o",
        action="store_true",
        help="Overrwite files with symlinks if they already exist",
    )
    args = parser.parse_args()
    symlink_files(args.overwrite)
    touch_private_zsh()
    install_pip_requirements()


def symlink_files(overwrite: bool):
    local_home = ROOT_DIR / "home"
    true_home = Path("~").expanduser()
    for dir, _, files in os.walk(local_home):
        for filename in files:
            real_path = Path(dir) / filename
            if real_path.is_dir():
                continue
            link_path = true_home / real_path.relative_to(local_home)
            if link_path.exists():
                if overwrite:
                    link_path.unlink()
                else:
                    print(f"Target already exists, skipping {link_path}")
                    continue
            print(f"Linking {real_path} -> {link_path}")
            link_path.parent.mkdir(exist_ok=True, parents=True)
            link_path.unlink(missing_ok=True)
            os.symlink(real_path, link_path)


def touch_private_zsh():
    path = Path("~/.private.zsh").expanduser()
    if not path.exists():
        path.touch()


def install_pip_requirements():
    req = ROOT_DIR / "requirements.txt"
    print(f"Installing {req}")
    subprocess.check_call(f"pip install -r {req}", shell=True)


if __name__ == "__main__":
    main()
