class Bye(object):
    """Bye class

    say Bye in bytes
    """

    bye: bytes = b"bye"

    def __add__(self, name: str) -> bytes:
        """add name

        :param name: a name
        :type name: str
        :return: the bye name
        :rtype: bytes
        """
        return self.bye + b" " + name.encode("utf-8")

    @property  # getter
    def pretty(self) -> bytes:
        return self.bye + self.bye
