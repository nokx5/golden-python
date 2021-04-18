import pytest


def test_silver():
    from golden.project import Bye

    msg = Bye()
    msg += "visitor"
    with pytest.raises(TypeError) as e:
        msg + "aie"
    assert "can't concat str to bytes" in str(e)
    assert msg.decode() == "bye visitor"
