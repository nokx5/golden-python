#!/usr/bin/env python
"""The setup and build script for the golden library."""

import codecs
import os
from golden import __version__

from setuptools import setup, find_packages


def requirements():
    """Build the requirements list for this project"""
    requirements_list = []

    with open("requirements.txt") as requirements:
        for install in requirements:
            requirements_list.append(install.strip())

    return requirements_list


packages = find_packages(exclude=["tests*"])
requirements = requirements()

with codecs.open("README.rst", "r", "utf-8") as fd:
    fn = os.path.join("golden", "version.py")
    with open(fn) as fh:
        code = compile(fh.read(), fn, "exec")
        exec(code)

    setup(
        name="golden-python",
        version=__version__,
        author="nokx",
        author_email="info@nokx.ch",
        license="MIT",
        url="https://nokx5.github.io/golden-python",
        keywords="python golden project pure skeleton",
        description="Golden project in pure python",
        long_description=fd.read(),
        scripts=["scripts/silver-python.py"],
        entry_points={
            "console_scripts": [
                "cli_golden = golden.__main__:cli_entrypoint",
            ],
        },
        packages=packages,
        package_data={"golden": ["py.typed"]},
        install_requires=requirements,
        # extras_require={"json": "ujson"},
        include_package_data=True,
    )
