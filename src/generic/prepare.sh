#!/bin/sh

. tarball/scripts/versions

IMAGE_DIR="haskell-platform-${PLATFORM_VERSION}"

die () {
  echo
  echo "Error:"
  echo $1 >&2
  exit 2
}

which cabal 2> /dev/null || die "The prepare script needs the cabal program"

echo "Preparing a tarball for ${IMAGE_DIR}"

rm -rf "${IMAGE_DIR}/"
mkdir "${IMAGE_DIR}/"
mkdir "${IMAGE_DIR}/packages"
mkdir "${IMAGE_DIR}/scripts"

runghc Build.hs ../../haskell-platform.cabal "${IMAGE_DIR}/packages"

cp tarball/packages/core.packages     "${IMAGE_DIR}/packages/"
cp tarball/scripts/*.sh               "${IMAGE_DIR}/scripts/"
cp tarball/scripts/config.in          "${IMAGE_DIR}/scripts/"
cp tarball/configure.ac tarball/Makefile "${IMAGE_DIR}/"
chmod +x "${IMAGE_DIR}/scripts/"*.sh
cd "${IMAGE_DIR}/" && autoreconf && cd ..

tar -c "${IMAGE_DIR}" -zf "${IMAGE_DIR}.tar.gz"
echo "Created ${IMAGE_DIR}.tar.gz"
