### PYCRYPTO ###
_build_pycrypto() {
local VERSION="2.6.1"
local FOLDER="pycrypto-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/${FILE}"
local XPYTHON="${HOME}/xtools/python2/${DROBO}"
local BASE="${PWD}"
export QEMU_LD_PREFIX="${TOOLCHAIN}/${HOST}/libc"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
sed -e "39ifrom setuptools import setup" -i setup.py
PKG_CONFIG_PATH="${XPYTHON}/lib/pkgconfig" \
  LDFLAGS="${LDFLAGS:-} -Wl,-rpath,/mnt/DroboFS/Share/DroboApps/python2/lib -L${XPYTHON}/lib" \
  "${XPYTHON}/bin/python" setup.py \
    build_ext --include-dirs="${XPYTHON}/include" --library-dirs="${XPYTHON}/lib" --force \
    build --force \
    build_scripts --executable="/mnt/DroboFS/Share/DroboApps/python2/bin/python" --force \
    bdist_egg --dist-dir "${BASE}"
popd
}

### BUILD ###
_build() {
  _build_pycrypto
}

_clean() {
  rm -v -fr *.egg
  rm -vfr "${DEPS}"
  rm -vfr "${DEST}"
  rm -v -fr target/*
}
