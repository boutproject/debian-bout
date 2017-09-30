#!/bin/bash
#
# Make a Debian .deb package
#
# Build depends: git, python (NumPy)


# Package name
PKGNAME=bout++

# Fetch BOUT++, including the googletest unit testing framework

git clone --recursive https://github.com/boutproject/BOUT-dev.git -b master

# Get the version number
cd BOUT-dev
# Find most recent un-annotated tag reachable from the last commit
VERSION=`git describe --long --tags | sed "s/v\([0-9][.0-9]*\).*/\1/"`

# We can now discard history
rm -rf .git

cd ..

echo "Code version: ${VERSION}"

# Rename source directory
# Should be package hyphen version

SOURCEDIR=${PKGNAME}-${VERSION}
TARBALL=${PKGNAME}_${VERSION}.orig.tar.gz

mv BOUT-dev ${SOURCEDIR}

# Make a tarball of original source code
tar -czf ${TARBALL} ${SOURCEDIR}

# Copy the debian configuration files into the source directory
cp -r debian ${SOURCEDIR}

# Set the PYTHONPATH so the test suite can run
export PYTHONPATH=${PWD}/${SOURCEDIR}/tools/pylib

# Build the source package
# Note: debuild removes environment variables unless preserved
#       The --preserve-envvar setting needs to come before -us
cd ${SOURCEDIR}
debuild --preserve-envvar PYTHONPATH -us -uc 


