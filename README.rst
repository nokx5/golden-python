
=======
Welcome
=======
This is a skeleton for a python project template (called a golden project).

Development tools
-----------------

- nix <3

- black (formatting)

- vscode (IDE) with
  
    - ms-python.vscode-pylance
      
    - ms-python.python

    - njpwerner.autodocstring (sphinx)

    - littlefoxteam.vscode-python-test-adapter (pytest)

- pytest (tests)

- sphinx (docs)

Nix
---

Enter the nix shell with

.. code:: shell

    $ nix-shell -I nixpkgs=https://nixos.org/channels/nixpkgs-unstable --pure default.shell.nix

==========
Installing
==========

You can install or upgrade the project with:

.. code:: shell

    $ pip install project_name --upgrade

Or you can install from source with:

.. code:: shell

    $ python setup.py install
    

=============
Documentation
=============

Further documentation can be searched.

=======
License
=======

You may copy, distribute and modify the software provided that
modifications are described and licensed for free under the `MIT
<https://opensource.org/licenses/MIT>`_.
