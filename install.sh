#!/bin/bash
# ==============================================================================
#  ParsLinux GRUB Teması Kurulum Betiği
#  Telif Hakkı (C) 2026 ParsLinux Geliştirici Ekibi <dev@parslinux.org>
# ==============================================================================

set -e

THEME_NAME="parslinux"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_SRC="${SCRIPT_DIR}/parslinux"

echo "=========================================================="
echo "       🐆 ParsLinux GRUB2 Teması Kurulum Sihirbazı        "
echo "=========================================================="

if [ "$EUID" -ne 0 ]; then
    echo "HATA: Bu betik root (yönetici) hakları ile çalıştırılmalıdır."
    echo "Kullanım: sudo $0"
    exit 1
fi

if [ ! -d "${THEME_SRC}" ]; then
    echo "HATA: Tema kaynak klasörü (${THEME_SRC}) bulunamadı!"
    exit 1
fi

# GRUB ana dizini tespiti
if [ -d "/boot/grub2" ]; then
    GRUB_DIR="/boot/grub2"
elif [ -d "/boot/grub" ]; then
    GRUB_DIR="/boot/grub"
else
    echo "HATA: Sistemde /boot/grub veya /boot/grub2 dizini tespit edilemedi."
    exit 1
fi

THEMES_DIR="${GRUB_DIR}/themes"
TARGET_DIR="${THEMES_DIR}/${THEME_NAME}"
USR_SHARE_THEMES="/usr/share/grub/themes/${THEME_NAME}"

echo "[1/4] Tema dosyaları kopyalanıyor..."
mkdir -p "${THEMES_DIR}"
mkdir -p "/usr/share/grub/themes"

rm -rf "${TARGET_DIR}" "${USR_SHARE_THEMES}"
cp -r "${THEME_SRC}" "${TARGET_DIR}"
cp -r "${THEME_SRC}" "${USR_SHARE_THEMES}"

echo "[2/4] /etc/default/grub yapılandırması güncelleniyor..."
GRUB_CFG_FILE="/etc/default/grub"
if [ -f "${GRUB_CFG_FILE}" ]; then
    # Yedek al
    cp "${GRUB_CFG_FILE}" "${GRUB_CFG_FILE}.bak.$(date +%Y%m%d%H%M%S)"

    # Eski GRUB_THEME satırlarını temizle
    sed -i '/^GRUB_THEME=/d' "${GRUB_CFG_FILE}"
    sed -i '/^#GRUB_THEME=/d' "${GRUB_CFG_FILE}"

    # Yeni GRUB_THEME tanımını ekle
    echo "GRUB_THEME=\"${TARGET_DIR}/theme.txt\"" >> "${GRUB_CFG_FILE}"

    # GFXMODE kontrolü / optimizasyonu (Full HD öncelikli)
    if grep -q "^GRUB_GFXMODE=" "${GRUB_CFG_FILE}"; then
        sed -i 's/^GRUB_GFXMODE=.*/GRUB_GFXMODE="1920x1080,auto"/' "${GRUB_CFG_FILE}"
    else
        echo 'GRUB_GFXMODE="1920x1080,auto"' >> "${GRUB_CFG_FILE}"
    fi
fi

echo "[3/4] GRUB önyükleme yapılandırması güncelleniyor..."
if command -v update-grub >/dev/null 2>&1; then
    update-grub
elif command -v grub-mkconfig >/dev/null 2>&1; then
    if [ -f "${GRUB_DIR}/grub.cfg" ]; then
        grub-mkconfig -o "${GRUB_DIR}/grub.cfg"
    else
        grub-mkconfig -o /boot/grub/grub.cfg
    fi
elif command -v grub2-mkconfig >/dev/null 2>&1; then
    grub2-mkconfig -o "${GRUB_DIR}/grub.cfg"
else
    echo "UYARI: Otomatik grub-mkconfig / update-grub komutu bulunamadı. Lütfen elle çalıştırın."
fi

echo "[4/4] Kurulum tamamlandı!"
echo "=========================================================="
echo "  ✓ ParsLinux GRUB teması başarıyla uygulandı."
echo "  ✓ Tema yolu: ${TARGET_DIR}/theme.txt"
echo "  ✓ Sistem bir sonraki açılışta ParsLinux teması ile başlayacaktır."
echo "=========================================================="
