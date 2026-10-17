# 🤖 Claude & Yapay Zeka Asistan Yönergeleri (`CLAUDE.md`)

Bu belge, Claude ve diğer yapay zeka kodlama asistanlarının **parslinux-grub-theme** projesinde çalışırken uyması gereken temel kuralları tanımlar.

---

## 1. Proje Özeti
- **Ad:** `parslinux-grub-theme`
- **Hedef:** GRUB2 gfxmenu önyükleme teması
- **Paket Türü:** Debian paketi (`Architecture: all`) ve bağımsız kabuk betikleri
- **Hedef Dizin:** `/boot/grub/themes/parslinux` ve `/usr/share/grub/themes/parslinux`

---

## 2. Temel Kurallar ve Kısıtlamalar
1. **Pardus Referansı Bırakmama**: Kod, metin veya dosya adlarında eski "pardus" veya "bilge" referansı bırakılmamalıdır (yalnızca telif/lisans atıfları hariç).
2. **Çözünürlük ve Oran Uyumu**: Tema koordinatları (`theme.txt`) her zaman yüzdesel veya esnek orantılı tutulmalı, ekran çözünürlüğü değişimlerinde bozulmamalıdır.
3. **Format Uyumluluğu**: GRUB sadece `.pf2` formatındaki bitmap fontları okur. TTF/OTF doğrudan eklenmemelidir.
4. **Debian Standartları**: Paketleme dosyaları `debian/` dizini altında debhelper v13 standardında korunmalıdır.
