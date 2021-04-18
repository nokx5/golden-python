import pytest


def test_pretty():
    from golden.project import Hello

    msg = Hello.pretty("visitor")
    assert msg == "hello visitor"

    new = Hello("guest")
    assert new.dummy_bye() == "hello guest and byebye"
