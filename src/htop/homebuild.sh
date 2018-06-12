# Maintainer: Boohbah <boohbah at gmail.com>
# Contributor: Eric Belanger <eric at archlinux.org>
# Contributor: Daniel J Griffiths <ghost1227 at archlinux.us>
# Contributor: Wesley Merkel <ooesili at gmail.com>
# Contributor: sekret <sekret at posteo.se>

pkgname=htop
pkgver=2.2.0
pkgrel=2
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
sha512sums=('ec1335bf0e3e0387e5e50acbc508d0effad19c4bc1ac312419dc97b82901f4819600d6f87a91668f39d429536d17304d4b14634426a06bec2ecd09df24adc62e'
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
      --enable-cgroup

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
