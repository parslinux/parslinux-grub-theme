#!/usr/bin/env bash
# ==============================================================================
#  ParsLinux GRUB Teması — Çalıştırma, Test ve Yönetim Aracı (run.sh)
#  Telif Hakkı (C) 2026 ParsLinux Geliştirici Ekibi <dev@parslinux.org>
# ==============================================================================

set -e

# Renk tanımları
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="$SCRIPT_DIR/parslinux"

function print_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║       🐆 ParsLinux GRUB Teması — Yönetim ve Test Aracı       ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

function check_theme_integrity() {
    echo -e "\n${BOLD}[1] Tema Bütünlüğü ve Dosya Kontrolü Yapılıyor...${NC}\n"
    local errors=0

    # 1. Ana dosya kontrolleri
    echo -e "${BOLD}Temel Dosyalar:${NC}"
    for f in "background.png" "theme.txt" "select_w.png" "select_c.png" "select_e.png" "progress_bar_c.png" "progress_highlight_c.png"; do
        if [ -f "$THEME_DIR/$f" ]; then
            echo -e "  ${GREEN}✓${NC} $f $(ls -lh "$THEME_DIR/$f" | awk '{print "(" $5 ")"}')"
        else
            echo -e "  ${RED}✗ EKSİK:${NC} $f"
            errors=$((errors + 1))
        fi
    done

    # 2. Font dosyaları
    echo -e "\n${BOLD}Bitmap Yazı Tipleri (.pf2):${NC}"
    local font_count=0
    for font in "$THEME_DIR"/*.pf2; do
        if [ -f "$font" ]; then
            echo -e "  ${GREEN}✓${NC} $(basename "$font")"
            font_count=$((font_count + 1))
        fi
    done
    if [ $font_count -eq 0 ]; then
        echo -e "  ${RED}✗ Hiçbir .pf2 fontu bulunamadı!${NC}"
        errors=$((errors + 1))
    fi

    # 3. İkon kontrolleri
    echo -e "\n${BOLD}İşletim Sistemi İkonları (icons/):${NC}"
    local icon_count=0
    for icon in "$THEME_DIR/icons"/*.png; do
        if [ -f "$icon" ]; then
            icon_count=$((icon_count + 1))
        fi
    done
    echo -e "  ${GREEN}✓${NC} Toplam $icon_count adet OS ikonu mevcut."

    # 4. theme.txt sözdizimi doğrulaması
    echo -e "\n${BOLD}theme.txt Sözdizimi Kontrolü:${NC}"
    if grep -q "desktop-image" "$THEME_DIR/theme.txt" && grep -q "boot_menu" "$THEME_DIR/theme.txt"; then
        echo -e "  ${GREEN}✓${NC} theme.txt temel blokları (desktop-image, boot_menu) tanımlı."
    else
        echo -e "  ${RED}✗ theme.txt içinde zorunlu alanlar eksik!${NC}"
        errors=$((errors + 1))
    fi

    if [ $errors -eq 0 ]; then
        echo -e "\n${GREEN}${BOLD}🎉 Tebrikler! Tema dosyaları eksiksiz ve kullanıma hazır.${NC}\n"
    else
        echo -e "\n${RED}${BOLD}⚠️ Toplam $errors adet hata/eksik tespit edildi!${NC}\n"
    fi
}

function run_grub_emu() {
    echo -e "\n${BOLD}[2] GRUB Emülatörü ile Canlı Test Başlatılıyor...${NC}\n"
    if command -v grub-emu &>/dev/null; then
        echo -e "${CYAN}grub-emu başlatılıyor (Tema: $THEME_DIR)...${NC}"
        grub-emu -d "$THEME_DIR" || grub-emu
    else
        echo -e "${YELLOW}⚠️ Sistemde 'grub-emu' (GRUB Emulator) kurulu değil.${NC}"
        echo -e "Kurulum için:"
        echo -e "  Debian/Ubuntu/ParsLinux : ${CYAN}sudo apt install grub-emu${NC}"
        echo -e "  Arch Linux/CachyOS      : ${CYAN}yay -S grub-emu${NC} veya resmi paket"
        echo -e "\nAlternatif olarak arka plan görseli incelenebilir."
    fi
}

function check_system_grub() {
    echo -e "\n${BOLD}[3] Sistem GRUB Yapılandırma Analizi:${NC}\n"
    local cfg="/etc/default/grub"
    if [ -f "$cfg" ]; then
        echo -e "${BOLD}Yapılandırma Dosyası:${NC} $cfg"
        echo -e "──────────────────────────────────────────────────────"
        grep -E "^(GRUB_THEME|GRUB_GFXMODE|GRUB_TIMEOUT|GRUB_DISTRIBUTOR)" "$cfg" || echo "İlgili anahtar bulunamadı."
        echo -e "──────────────────────────────────────────────────────"
    else
        echo -e "${RED}⚠️ $cfg dosyası bulunamadı!${NC}"
    fi

    echo -e "\n${BOLD}Kurulu GRUB Temaları:${NC}"
    for dir in "/boot/grub/themes" "/boot/grub2/themes" "/usr/share/grub/themes"; do
        if [ -d "$dir" ]; then
            echo -e "  Dizin: ${CYAN}$dir${NC}"
            ls -1 "$dir" 2>/dev/null | sed 's/^/    - /' || echo "    (Boş)"
        fi
    done
    echo ""
}

function open_preview_image() {
    echo -e "\n${BOLD}[4] Tema Arka Plan Görseli Açılıyor...${NC}\n"
    if command -v xdg-open &>/dev/null; then
        xdg-open "$THEME_DIR/background.png" &>/dev/null &
        echo -e "${GREEN}✓ background.png sistem görsel görüntüleyicisinde açıldı.${NC}\n"
    else
        echo -e "${YELLOW}xdg-open bulunamadı. Dosya yolu: $THEME_DIR/background.png${NC}\n"
    fi
}

function show_menu() {
    print_banner
    echo -e "${BOLD}Lütfen yapmak istediğiniz işlemi seçin:${NC}"
    echo -e "  ${CYAN}1)${NC} Tema Bütünlüğü ve Dosyalarını Doğrula (Check)"
    echo -e "  ${CYAN}2)${NC} GRUB Simülatöründe Önizle (grub-emu)"
    echo -e "  ${CYAN}3)${NC} Sistem GRUB Durumunu İncele (/etc/default/grub)"
    echo -e "  ${CYAN}4)${NC} Arka Plan Görselini Aç (xdg-open)"
    echo -e "  ${CYAN}5)${NC} Temayı Sisteme Kur (sudo ./install.sh)"
    echo -e "  ${CYAN}6)${NC} Temayı Sistemden Kaldır (sudo ./uninstall.sh)"
    echo -e "  ${CYAN}7)${NC} Dağıtım Paketi İnşa Et (./package.sh)"
    echo -e "  ${CYAN}0)${NC} Çıkış"
    echo ""
}

# Parametreli kullanım kontrolü
case "$1" in
    check|test)
        print_banner
        check_theme_integrity
        exit 0
        ;;
    preview|emu)
        print_banner
        run_grub_emu
        exit 0
        ;;
    status)
        print_banner
        check_system_grub
        exit 0
        ;;
    image|bg)
        open_preview_image
        exit 0
        ;;
    install)
        sudo "$SCRIPT_DIR/install.sh"
        exit 0
        ;;
    uninstall)
        sudo "$SCRIPT_DIR/uninstall.sh"
        exit 0
        ;;
    package)
        "$SCRIPT_DIR/package.sh"
        exit 0
        ;;
    --help|-h)
        echo "Kullanım: $0 [check|preview|status|image|install|uninstall|package]"
        exit 0
        ;;
esac

# İnteraktif Menü
while true; do
    show_menu
    read -rp "Seçiminiz [0-7]: " choice
    case "$choice" in
        1) check_theme_integrity ;;
        2) run_grub_emu ;;
        3) check_system_grub ;;
        4) open_preview_image ;;
        5) sudo "$SCRIPT_DIR/install.sh" ;;
        6) sudo "$SCRIPT_DIR/uninstall.sh" ;;
        7) "$SCRIPT_DIR/package.sh" ;;
        0) echo -e "\n${GREEN}Görüşmek üzere!${NC}"; exit 0 ;;
        *) echo -e "\n${RED}Geçersiz seçim! Lütfen 0 ile 7 arasında bir değer girin.${NC}\n" ;;
    esac
    echo -e "${YELLOW}Devam etmek için [ENTER] tuşuna basın...${NC}"
    read -r
    clear
done
