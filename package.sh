#!/bin/bash
# ==============================================================================
#  ParsLinux GRUB Teması Paketleme Betiği
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

echo "🐆 ParsLinux GRUB Teması Paketi Hazırlanıyor..."
mkdir -p build

if command -v dpkg-buildpackage >/dev/null 2>&1; then
    dpkg-buildpackage -us -uc -b
    mv ../parslinux-grub-theme_* build/ 2>/dev/null || true
    echo "✓ Paket başarıyla build/ içerisine inşa edildi."
else
    PKG_NAME="parslinux-grub-theme"
    PKG_VER="1.0.0"
    PKG_DIR="build/${PKG_NAME}_${PKG_VER}_all"
    rm -rf "${PKG_DIR}"
    mkdir -p "${PKG_DIR}/DEBIAN"
    mkdir -p "${PKG_DIR}/usr/share/grub/themes"
    mkdir -p "${PKG_DIR}/boot/grub/themes"

    cp -r parslinux "${PKG_DIR}/usr/share/grub/themes/"
    cp -r parslinux "${PKG_DIR}/boot/grub/themes/"

    cp debian/postinst "${PKG_DIR}/DEBIAN/postinst"
    cp debian/postrm "${PKG_DIR}/DEBIAN/postrm"
    chmod 755 "${PKG_DIR}/DEBIAN/postinst" "${PKG_DIR}/DEBIAN/postrm"

    cat <<EOF > "${PKG_DIR}/DEBIAN/control"
Package: ${PKG_NAME}
Version: ${PKG_VER}
Section: utils
Priority: optional
Architecture: all
Maintainer: ParsLinux Dev Team <dev@parslinux.org>
Depends: grub2-common
Description: ParsLinux GRUB Theme
 A modern, sleek and elegant GRUB bootloader theme featuring the
 ParsLinux Anatolian leopard branding, high-contrast dark aesthetic,
 and comprehensive operating system icons.
EOF

    if command -v dpkg-deb >/dev/null 2>&1; then
        dpkg-deb --build "${PKG_DIR}" "build/${PKG_NAME}_${PKG_VER}_all.deb"
        echo "✓ Paket oluşturuldu: build/${PKG_NAME}_${PKG_VER}_all.deb"
    else
        echo "✓ Paket ağacı hazırlandı: ${PKG_DIR}"
    fi
fi
