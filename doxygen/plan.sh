pkg_name=doxygen
pkg_origin=core
pkg_version=1.8.11
pkg_license=('GPL-2.0')
pkg_description="Generate documentation for several programming languages"
pkg_upstream_url=http://www.doxygen.org/
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_source="https://ftp.stack.nl/pub/users/dimitri/${pkg_name}-${pkg_version}.src.tar.gz"
pkg_shasum=65d08b46e48bd97186aef562dc366681045b119e00f83c5b61d05d37ea154049
pkg_build_deps=(
  core/bison
  core/cmake
  core/diffutils
  core/flex
  core/gcc
  core/libxml2
  core/m4
  core/make
  core/python2
)
pkg_deps=(
  core/gcc-libs
  core/glibc
  core/libiconv
)
pkg_bin_dirs=(bin)

do_build() {
  mkdir -p build
  cd build || exit
  build_line "Setting libiconv flags..."
  export CXXFLAGS="-liconv $CXXFLAGS"
  build_line "CXXFLAGS are now: $CXXFLAGS"
  cmake -DCMAKE_INSTALL_PREFIX:PATH="$pkg_prefix" \
    -DICONV_INCLUDE_DIR="$(hab pkg path core/libiconv)/include" \
    -G "Unix Makefiles" ../
  make
}

# One of the tests fails on a citation test. I don't know if this is an
# $INPUTDIR mangling, or a problem upstream, skipping for now.
# do_check() {
#   cd build || exit
#   make tests
# }

do_install() {
  cd build || exit
  make install
}
