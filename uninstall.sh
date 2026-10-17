#!/bin/bash
# ==============================================================================
#  ParsLinux GRUB Teması Kaldırma Betiği
#  Telif Hakkı (C) 2026 ParsLinux Geliştirici Ekibi <dev@parslinux.org>
# ==============================================================================

set -e

THEME_NAME="parslinux"

echo "=========================================================="
echo "      🐆 ParsLinux GRUB2 Teması Kaldırma Sihirbazı        "
echo "=========================================================="

if [ "$EUID" -ne 0 ]; then
    echo "HATA: Bu betik root (yönetici) hakları ile çalıştırılmalıdır."
    echo "Kullanım: sudo $0"
    exit 1
fi

if [ -d "/boot/grub2" ]; then
    GRUB_DIR="/boot/grub2"
elif [ -d "/boot/grub" ]; then
    GRUB_DIR="/boot/grub"
else
    GRUB_DIR="/boot/grub"
fi

echo "[1/3] Tema dosyaları siliniyor..."
rm -rf "${GRUB_DIR}/themes/${THEME_NAME}"
rm -rf "/usr/share/grub/themes/${THEME_NAME}"

echo "[2/3] /etc/default/grub yapılandırması temizleniyor..."
GRUB_CFG_FILE="/etc/default/grub"
if [ -f "${GRUB_CFG_FILE}" ]; then
    sed -i '/parslinux\/theme\.txt/d' "${GRUB_CFG_FILE}"
fi

echo "[3/3] GRUB yapılandırması güncelleniyor..."
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
fi

echo "=========================================================="
echo "  ✓ ParsLinux GRUB teması sistemden başarıyla kaldırıldı."
echo "=========================================================="
