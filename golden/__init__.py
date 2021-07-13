# A library that provides a golden project
# Copyright (C) 202X
"""A library that provides a golden project"""

from .project import Hello
from .subfolder.silver import Bye
from .version import __version__

__author__ = "nokx"
__all__ = ["Hello", "Bye"]
