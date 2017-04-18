# Maintainer: Boohbah <boohbah at gmail.com>
# Contributor: Eric Belanger <eric at archlinux.org>
# Contributor: Daniel J Griffiths <ghost1227 at archlinux.us>
# Contributor: Wesley Merkel <ooesili at gmail.com>
# Contributor: sekret <sekret at posteo.se>

pkgname=htop
pkgver=2.0.2
pkgrel=1
pkgdesc="Interactive process viewer with solarized patch"
arch=('i686' 'x86_64' 'armv7h')
url="http://htop.sourceforge.net/"
license=('GPL')
depends=('ncurses')
makedepends=('python2')
optdepends=('lsof: show files opened by a process'
            'strace: attach to a running process')
options=('!emptydirs')
source=("http://hisham.hm/$pkgname/releases/$pkgver/$pkgname-$pkgver.tar.gz"
        'htop.patch')
sha512sums=('1c9bf71a36c56b301667aa6d03756fc757fbcb63e848d9581d10db3df6193cdeb00e55ceb6e2392794ac03ea034b04459a8fe550b3ac2318cd86263a74c78cda'
SKIP)

prepare() {
  wget "${source[0]}"
  tar xf $(basename ${source[0]})
  cd "$pkgname-$pkgver"

  sed -i 's|ncursesw/curses.h|curses.h|' RichString.[ch] configure
  sed -i 's|python|python2|' scripts/MakeHeader.py

  # fix gray patch
  patch -p1 -N -i "../htop.patch"
}

build() {
  ./configure \
      --prefix=/usr \
      --enable-unicode \
      --enable-openvz \
      --enable-vserver \
      --enable-cgroup \

  make
}

package() {
  cp htop $HOME/bin/
}

cleanup() {
  cd ..
  rm -r "$pkgname-$pkgver"
  rm $(basename ${source[0]})
}

prepare
build
package
cleanup

# vim:set ts=2 sw=2 et: