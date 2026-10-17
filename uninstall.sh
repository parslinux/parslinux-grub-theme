#!/usr/bin/env bash
# ==============================================================================
#  ParsLinux GRUB Teması — Kaldırma Betiği (uninstall.sh)
#  Telif Hakkı (C) 2026 ParsLinux Geliştirici Ekibi <dev@parslinux.org>
# ==============================================================================

set -e

# Renk tanımları
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

THEME_NAME="parslinux"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║       🐆 ParsLinux GRUB Teması — Kaldırma Sihirbazı          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}${BOLD}HATA:${NC} Bu betik root (yönetici) hakları ile çalıştırılmalıdır."
    echo -e "Lütfen şu komutla çalıştırın: ${CYAN}sudo $0${NC}\n"
    exit 1
fi

if [ -d "/boot/grub2" ]; then
    GRUB_DIR="/boot/grub2"
elif [ -d "/boot/grub" ]; then
    GRUB_DIR="/boot/grub"
else
    GRUB_DIR="/boot/grub"
fi

echo -e "${BOLD}[1/3] Tema dosyaları siliniyor...${NC}"
rm -rf "${GRUB_DIR}/themes/${THEME_NAME}"
rm -rf "/usr/share/grub/themes/${THEME_NAME}"
echo -e "  ${GREEN}✓${NC} ${GRUB_DIR}/themes/${THEME_NAME} kaldırıldı."
echo -e "  ${GREEN}✓${NC} /usr/share/grub/themes/${THEME_NAME} kaldırıldı."

echo -e "\n${BOLD}[2/3] /etc/default/grub yapılandırması temizleniyor...${NC}"
GRUB_CFG_FILE="/etc/default/grub"
if [ -f "${GRUB_CFG_FILE}" ]; then
    sed -i '/parslinux\/theme\.txt/d' "${GRUB_CFG_FILE}"
    echo -e "  ${GREEN}✓${NC} ${GRUB_CFG_FILE} içindeki tema referansı kaldırıldı."
fi

echo -e "\n${BOLD}[3/3] GRUB yapılandırması güncelleniyor...${NC}"
if command -v update-grub &>/dev/null; then
    echo -e "  ${CYAN}update-grub çalıştırılıyor...${NC}"
    update-grub
elif command -v grub-mkconfig &>/dev/null; then
    echo -e "  ${CYAN}grub-mkconfig çalıştırılıyor...${NC}"
    if [ -f "${GRUB_DIR}/grub.cfg" ]; then
        grub-mkconfig -o "${GRUB_DIR}/grub.cfg"
    else
        grub-mkconfig -o /boot/grub/grub.cfg
    fi
elif command -v grub2-mkconfig &>/dev/null; then
    echo -e "  ${CYAN}grub2-mkconfig çalıştırılıyor...${NC}"
    grub2-mkconfig -o "${GRUB_DIR}/grub.cfg"
fi

echo -e "\n${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════╗"
echo "║      ✓ ParsLinux GRUB Teması Sistemden Başarıyla Kaldırıldı   ║"
echo "╚══════════════════════════════════════════════════════════════╝${NC}\n"
