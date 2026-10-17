# 🎨 GRUB Teması Geliştirme ve Özelleştirme Kılavuzu (`GRUB_THEME_GUIDE.md`)

Bu kılavuz, ParsLinux GRUB temasını özelleştirmek, renkleri değiştirmek veya yeni grafik bileşenleri eklemek isteyen geliştiriciler için hazırlanmıştır.

---

## 1. `theme.txt` Yapılandırma Formatı

GRUB tema motoru, CSS benzeri blok yapısına sahip özel bir sözdizimi kullanır:

```ini
# Küresel Özellikler
desktop-image: "background.png"
desktop-color: "#080b12"

# Bileşen Tanımı
+ boot_menu {
  left = 22%
  top = 32%
  width = 56%
  height = 46%
  item_font = "Terminus Regular 16"
  item_color = "#94a3b8"
  selected_item_color = "#ffffff"
  selected_item_pixmap_style = "select_*.png"
  item_height = 38
  item_padding = 4
  item_spacing = 12
  icon_width = 32
  icon_height = 32
  item_icon_space = 14
  scrollbar = false
}
```

---

## 2. Renk Paleti ve Tasarım Dili

ParsLinux görsel kimliğine sadık kalınarak belirlenen renk kodları:

| Rol | Renk Kodu | Kullanım Alanı |
| :--- | :--- | :--- |
| **Zemin (Obsidian)** | `#080b12` | Arka plan ana dolgusu |
| **Panel Zemin (Dark Slate)** | `#0f172a` | Menü kutusu zemin dolgusu |
| **Vurgu İndigo (Primary)** | `#6366f1` | Pars amblemi, çerçeve köşeleri, seçim kapsülü |
| **Vurgu Camgöbeği (Cyan)** | `#06b6d4` / `#38bdf8` | İlerleme çubuğu, ikon detayları, ışıma aurası |
| **Metin Normal** | `#94a3b8` | Seçili olmayan menü satırları ve kısayol metinleri |
| **Metin Vurgulu** | `#ffffff` | Seçili menü satırı ve başlık |
| **Çerçeve Çizgisi** | `#334155` | Uçbirim ve ilerleme çubuğu sınırları |

---

## 3. Yazı Tipleri (`.pf2`) Oluşturma

GRUB, standart `.ttf` veya `.otf` fontları doğrudan yükleyemez. Bunun yerine GRUB'un kendi formatı olan **`.pf2`** (PFF2 - Paged Font File Format) kullanılır.

Sisteminizde yeni bir yazı tipini GRUB formatına dönüştürmek için:

```bash
# grub-mkfont aracı ile TTF'den PF2 üretme
grub-mkfont --output=parslinux/font_adi.pf2 --size=16 /usr/share/fonts/truetype/custom-font.ttf
```

---

## 4. Yeni İkon Ekleme

Bir dağıtım veya donanım seçeneği için yeni ikon eklemek:
1. `32x32` piksel boyutunda şeffaf PNG hazırlayın.
2. GRUB'un arayacağı sınıf (`class`) ismiyle adlandırın (örneğin: `gentoo.png`, `opensuse.png`, `bsd.png`).
3. `parslinux/icons/` dizinine yerleştirin.
4. Yeniden derleme gerektirmez, doğrudan menüde tanınacaktır.
