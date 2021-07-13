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
        description="Golden project in pure python",
        long_description=fd.read(),
        url="https://nokx5.github.io/golden-python",
        author="nokx",
        author_email="info@nokx.ch",
        license="MIT",
        keywords="python golden project pure skeleton",
        install_requires=requirements,
        python_requires=">=3",
        packages=packages,
        include_package_data=True,
        scripts=["scripts/silver-python.py"],
        entry_points={
            "console_scripts": [
                "cli_golden = golden.__main__:cli_entrypoint",
            ],
        },
    )
