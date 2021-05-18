# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS  :=
SPHINXBUILD := sphinx-build
BUILDPREFIX := build
SOURCEDIR   := $(BUILDPREFIX)-source
TARGETDIR   := $(BUILDPREFIX)-target
CURRENTDIR  := $(shell pwd)

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(TARGETDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: importsrc Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(TARGETDIR)" $(SPHINXOPTS) $(O)

# import all documentation easily
importsrc:
	cp -rp $(CURRENTDIR)/content $(SOURCEDIR)
	cp -p $(CURRENTDIR)/../README.rst $(SOURCEDIR)
	# import notebook examples
	mkdir -p $(SOURCEDIR)/examples
	for notebooks in $(CURRENTDIR)/../examples/*.ipynb; do \
	    jupyter nbconvert $$notebooks --to rst  --output-dir=$(SOURCEDIR)/examples ; \
	done
	cp -p $(CURRENTDIR)/../examples/index.rst $(SOURCEDIR)/examples.rst

clean:
	rm -rf $(TARGETDIR)
	rm -rf $(SOURCEDIR)
