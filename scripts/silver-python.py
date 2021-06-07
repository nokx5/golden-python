#!/usr/bin/env nix-shell
#! nix-shell -i python -p python3Packages.black

import argparse

parser = argparse.ArgumentParser(description="cmdline arguments")

parser.add_argument("--name", default="world")

parser.add_argument("--foo", default=False, action="store_true")
parser.add_argument("--no-foo", dest="foo", action="store_false")

args = parser.parse_args([])

print(f"Silver Python: Hello {args.name}")
