.. _golden python: https://nokx5.github.io/golden-python

========================================
Welcome to the `golden python`_ template
========================================

|CILinuxBadge|_ |CIDarwinBadge|_ |DocBadge|_ |LicenseBadge|_

.. |CILinuxBadge| image:: https://github.com/nokx5/golden-python/workflows/CI-linux/badge.svg
.. _CILinuxBadge: https://github.com/nokx5/golden-python/actions/workflows/ci-linux.yml
.. |CIDarwinBadge| image:: https://github.com/nokx5/golden-python/workflows/CI-darwin/badge.svg
.. _CIDarwinBadge: https://github.com/nokx5/golden-python/actions/workflows/ci-darwin.yml
.. |DocBadge| image:: https://github.com/nokx5/golden-python/workflows/doc-api/badge.svg
.. _DocBadge: https://nokx5.github.io/golden-python
.. |LicenseBadge| image:: http://img.shields.io/badge/license-MIT-blue.svg
.. _LicenseBadge: https://github.com/nokx5/golden-python/blob/master/LICENSE

This is a skeleton for a python project template (called a golden project). 
Please find all the documentation `here <https://nokx5.github.io/golden-python>`_ and the source code `there <https://github.com/nokx5/golden-python>`_.

.. warning:: **NOTE:** you may require the experimental flakes commands `nix build` and `nix shell` in the following. If you do not, only classic nix commands `nix-build` and `nix-shell` will be available.

My development tools are
========================

* nix ❄️ (packaging from hell ❤️)
* black (formatter)
* vscode (IDE) with
   *  ms-python.vscode-pylance
   *  ms-python.python
   *  lextudio.restructuredtext
* pytest (tests)
* sphinx (docs)


Use the software
================

The `nokxpkgs <https://github.com/nokx5/nokxpkgs#add-nokxpkgs-to-your-nix-channel>`_ channel and associate overlay can be imported with the ``-I`` command or by setting the ``NIX_PATH`` environment variable.

.. code:: shell

    nix-shell -I nixpkgs=https://github.com/nokx5/nokxpkgs/archive/main.tar.gz -p golden-python --command cli_golden
    # or
    nix shell github:nokx5/golden-python --command cli_golden
    nix shell github:nokx5/nokxpkgs#golden-python --command cli_golden


Develop the software  (depreciated - new hash)
----------------------------------------------

.. warning:: Please note that all commands of this section creates new hashes which means that the evaluation may require additional downloads.

Start by cloning the `git repository <https://github.com/nokx5/golden-python>`_ golden python locally and enter it. 

Option 1: Develop the software (minimal requirements)
.....................................................

You can develop or build the local software easily with the minimal requirements.

.. code:: shell

    # option a: develop with a local shell (depreciated - new hash)
    nix-shell --expr 'with import <nixpkgs> {}; with python3Packages; callPackage ./derivation.nix {src = ./.; }'
    
    # option b: build the local project (depreciated - new hash)
    nix-build --expr 'with import <nixpkgs> {}; with python3Packages; callPackage ./derivation.nix {src = ./.; }' --no-out-link

Note that you can write the nix expression directly to the ``default.nix`` file to avoid typing ``--expr`` each time.

Option 2: Develop the software (supercharged 🛰️)
................................................

You can enter the supercharged environment for development.

.. code:: shell

    nix-shell shell.nix # (depreciated - new hash)


Develop the software
--------------------

.. warning:: **NOTE:** This section requires the experimental *flake* and *nix-command* features. Please refer to the official documentation for nix flakes. The advantage of using nix flakes is that you avoid channel pinning issues.

    After Nix was installed, update to the unstable feature with:
    
    .. code:: shell
    
        nix-env -f '<nixpkgs>' -iA nixUnstable
    
    And enable experimental features with:
    
    .. code:: shell
    
        mkdir -p ~/.config/nix
        echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf

Start by cloning the `git repository <https://github.com/nokx5/golden-python>`_ locally and enter it. 

Option 1: Develop the software
..............................

.. code:: shell

    # option a: develop with a local shell
    nix develop .#golden-python
    # or
    nix-shell . -A packages.x86_64-linux.golden-python

    # option b: build the local project
    nix build .#golden-python
    # or
    nix-build . -A packages.x86_64-linux.golden-python

Option 2: Develop the software (supercharged 🛰️)
................................................

You can enter the supercharged development environment.

.. code:: shell

    nix develop
    # or
    nix-shell . -A devShell.x86_64-linux

Installation with pip
=====================

You can install or upgrade the project with:

.. code:: shell

    pip install golden-python --upgrade

Or you can install from source with:

.. code:: shell

    python setup.py install


===================
Link to derivations
===================

.. code:: shell

    nix-build . -A packages.x86_64-linux.golden-python --out-link result-golden-python
    nix-build . -A packages.x86_64-linux.golden-python.inputDerivation --out-link result-golden-python-dev
    nix-build . -A devShell.x86_64-linux.inputDerivation --out-link result-golden-python-dev-full
    
    nix-build . -A packages.x86_64-linux.golden-python-app --out-link result-golden-python-app
    nix-build . -A packages.x86_64-linux.golden-python-app.inputDerivation --out-link result-golden-python-app-dev


=============
Code Snippets
=============

.. code:: shell

    black .

    nixpkgs-fmt .

    pip install $(cat requirements.txt)

    pip list --format=freeze | sed 's/==/>=/g' > requirements.txt

    python -m pytest -k "not bronze"

=======
License
=======

You may copy, distribute and modify the software provided that
modifications are described and licensed for free under the `MIT
<https://opensource.org/licenses/MIT>`_.
