.. _golden python: https://nokx5.github.io/golden_python/

========================================
Welcome to the `golden python`_ template
========================================
This is a skeleton for a python project template (called a golden project).


Development tools
=================

- nix ❄️ (packaging from hell ❤️)

- black (formatter)

- vscode (IDE) with
  
  - ms-python.vscode-pylance
  - ms-python.python
  - lextudio.restructuredtext

- pytest (tests)

- Sphinx (docs)

Develop with Nix
================

Use a classic Nix overlay
-------------------------

Enter the nix shell with

.. code:: shell

    # deprecated
    nix-shell -I nixpkgs=https://nixos.org/channels/nixpkgs-unstable --pure 


Use the experimental flake feature
----------------------------------

.. warning:: this section requires the experimental `flake` and `nix-command` features. Please refer to the official documentation for nix flakes. We highly recommand you to have a look to nix flakes since the issue of channel pinning is fixed with the `flake.lock` file.

Option 1: use the software
..........................

The package can be used easily with flakes.

.. code:: shell

    nix shell github:nokx5/golden_python --command cli_golden_python

Option 2: build and develop the software
........................................

You can enter the shell or build the project with flakes in a very convenient way.


.. code:: shell

    # option a: develop the local software
    nix develop

    # option b: build the local software
    nix build .#golden_python
    unlink result


Installation with pip
=====================

You can install or upgrade the project with:

.. code:: shell

    pip install golden_python --upgrade

Or you can install from source with:

.. code:: shell

    python setup.py install

=======
License
=======

You may copy, distribute and modify the software provided that
modifications are described and licensed for free under the `MIT
<https://opensource.org/licenses/MIT>`_.
