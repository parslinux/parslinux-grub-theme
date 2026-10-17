#!/usr/bin/env bash
# ==============================================================================
#  ParsLinux GRUB Teması — Kurulum Betiği (install.sh)
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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_SRC="${SCRIPT_DIR}/parslinux"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║       🐆 ParsLinux GRUB Teması — Kurulum Sihirbazı           ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Root yetkisi kontrolü
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}${BOLD}HATA:${NC} Bu betik root (yönetici) hakları ile çalıştırılmalıdır."
    echo -e "Lütfen şu komutla çalıştırın: ${CYAN}sudo $0${NC}\n"
    exit 1
fi

if [ ! -d "${THEME_SRC}" ]; then
    echo -e "${RED}${BOLD}HATA:${NC} Tema kaynak klasörü (${THEME_SRC}) bulunamadı!\n"
    exit 1
fi

# GRUB ana dizini tespiti
if [ -d "/boot/grub2" ]; then
    GRUB_DIR="/boot/grub2"
elif [ -d "/boot/grub" ]; then
    GRUB_DIR="/boot/grub"
else
    echo -e "${RED}${BOLD}HATA:${NC} Sistemde /boot/grub veya /boot/grub2 dizini tespit edilemedi."
    exit 1
fi

THEMES_DIR="${GRUB_DIR}/themes"
TARGET_DIR="${THEMES_DIR}/${THEME_NAME}"
USR_SHARE_THEMES="/usr/share/grub/themes/${THEME_NAME}"

echo -e "${BOLD}[1/4] Tema dosyaları kopyalanıyor...${NC}"
mkdir -p "${THEMES_DIR}"
mkdir -p "/usr/share/grub/themes"

rm -rf "${TARGET_DIR}" "${USR_SHARE_THEMES}"
cp -r "${THEME_SRC}" "${TARGET_DIR}"
cp -r "${THEME_SRC}" "${USR_SHARE_THEMES}"
echo -e "  ${GREEN}✓${NC} Hedef dizin oluşturuldu: ${TARGET_DIR}"
echo -e "  ${GREEN}✓${NC} Paylaşılan dizin oluşturuldu: ${USR_SHARE_THEMES}"

echo -e "\n${BOLD}[2/4] /etc/default/grub yapılandırması güncelleniyor...${NC}"
GRUB_CFG_FILE="/etc/default/grub"
if [ -f "${GRUB_CFG_FILE}" ]; then
    # Yedek al
    BACKUP_FILE="${GRUB_CFG_FILE}.bak.$(date +%Y%m%d%H%M%S)"
    cp "${GRUB_CFG_FILE}" "${BACKUP_FILE}"
    echo -e "  ${GREEN}✓${NC} Yedek oluşturuldu: ${BACKUP_FILE}"

    # Eski GRUB_THEME satırlarını temizle
    sed -i '/^GRUB_THEME=/d' "${GRUB_CFG_FILE}"
    sed -i '/^#GRUB_THEME=/d' "${GRUB_CFG_FILE}"

    # Yeni GRUB_THEME tanımını ekle
    echo "GRUB_THEME=\"${TARGET_DIR}/theme.txt\"" >> "${GRUB_CFG_FILE}"
    echo -e "  ${GREEN}✓${NC} GRUB_THEME=\"${TARGET_DIR}/theme.txt\" eklendi."

    # GFXMODE kontrolü / optimizasyonu (Full HD 1080p öncelikli)
    if grep -q "^GRUB_GFXMODE=" "${GRUB_CFG_FILE}"; then
        sed -i 's/^GRUB_GFXMODE=.*/GRUB_GFXMODE="1920x1080,auto"/' "${GRUB_CFG_FILE}"
    else
        echo 'GRUB_GFXMODE="1920x1080,auto"' >> "${GRUB_CFG_FILE}"
    fi
    echo -e "  ${GREEN}✓${NC} GRUB_GFXMODE=\"1920x1080,auto\" ayarlandı."
else
    echo -e "  ${YELLOW}UYARI:${NC} ${GRUB_CFG_FILE} bulunamadı, doğrudan tema dosyaları kopyalandı."
fi

echo -e "\n${BOLD}[3/4] GRUB önyükleme yapılandırması güncelleniyor...${NC}"
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
else
    echo -e "  ${YELLOW}UYARI:${NC} Otomatik grub-mkconfig / update-grub komutu bulunamadı."
fi

echo -e "\n${BOLD}[4/4] Kurulum Doğrulaması:${NC}"
if [ -f "${TARGET_DIR}/theme.txt" ]; then
    echo -e "  ${GREEN}✓${NC} Tema dosyası doğrulandı: ${TARGET_DIR}/theme.txt"
fi

echo -e "\n${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════╗"
echo "║          🎉 ParsLinux GRUB Teması Başarıyla Kuruldu!         ║"
echo "╚══════════════════════════════════════════════════════════════╝${NC}"
echo -e "  ${CYAN}• Tema Konumu  :${NC} ${TARGET_DIR}"
echo -e "  ${CYAN}• Yapılandırma :${NC} ${GRUB_CFG_FILE}"
echo -e "  ${CYAN}• Durum        :${NC} Bir sonraki sistem açılışında aktif olacaktır.\n"
