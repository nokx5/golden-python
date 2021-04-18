"""project.py"""
# import shutil
# import shlex
from typing import Optional

# import numpy

from .subfolder.silver import Bye


class Hello:
    """Hello class for the world

    It is a bit overloaded
    """

    def __init__(self, name: Optional[str] = "nokx") -> None:
        """construct a hello world attribute with the given argument

        :param name: a name
        :return: None
        """
        super().__init__()
        self.msg = Hello.pretty(name)

    @staticmethod
    def pretty(name: Optional[str] = "nokx") -> str:
        """pretty print an hello world with the given argument

        :param name: a name
        """
        return f"hello {name}"

    def dummy_bye(self) -> str:
        """pretty dummy_bye"""
        dummy_bye = Bye()
        return self.msg + " and " + dummy_bye.pretty.decode()
