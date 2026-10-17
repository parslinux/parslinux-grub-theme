# 🏛️ ParsLinux GRUB Teması Mimari Belgesi (`ARCHITECTURE.md`)

Bu belge, **ParsLinux GRUB2 Teması** (`parslinux-grub-theme`) bileşenlerinin teknik mimarisini, dosya yapısını, grafik motorunun çalışma mekanizmasını ve sistem entegrasyonunu açıklamaktadır.

---

## 1. Genel Bakış ve GRUB2 Gfxmenu Motoru

GRUB2 önyükleyicisi, metin modunun yanı sıra zengin grafiksel kullanıcı arayüzleri sunabilen **`gfxmenu`** modülünü içerir. Bu modül:
- VBE (Video BIOS Extensions) ve GOP (Graphics Output Protocol - UEFI) grafik kiplerini kullanır.
- PNG, TGA ve JPEG formatındaki görselleri işler.
- `theme.txt` dosyasındaki bildirimsel hiyerarşik yapılandırmaya göre görsel bileşenleri ekrana çizer.
- Özel sıkıştırılmış `.pf2` bitmap yazı tipi dosyalarını yükler.

---

## 2. Dizin ve Dosya Mimarisi

```
parslinux-grub-theme/
├── parslinux/                         # GRUB Tema Çekirdeği
│   ├── background.png                 # 1920x1080 Full HD ana arka plan
│   ├── theme.txt                      # Arayüz yerleşim ve bileşen tanımları
│   │
│   ├── select_w.png                   # Seçim kapsülü sol ucu (16x38 px)
│   ├── select_c.png                   # Seçim kapsülü orta uzama gövdesi (16x38 px)
│   ├── select_e.png                   # Seçim kapsülü sağ ucu (16x38 px)
│   │
│   ├── progress_bar_c.png             # Zaman aşımı arka plan yuvası (480x14 px)
│   ├── progress_highlight_c.png       # Zaman aşımı ilerleme dolgusu (480x14 px)
│   │
│   ├── terminal_box_*.png             # 9 parçalı konsol/düzenleme çerçevesi
│   │   ├── terminal_box_c.png         # Orta zemin
│   │   ├── terminal_box_[n|s|e|w].png # Kenar şeritleri
│   │   └── terminal_box_[nw|ne|sw|se].png # Yuvarlatılmış köşeler
│   │
│   ├── *.pf2                          # GRUB uyumlu bitmap fontlar
│   │   ├── ashbury_tr.pf2             # Başlık fontu
│   │   ├── dejavu_14.pf2              # Alternatif sistem fontu
│   │   ├── terminus-14.pf2            # Küçük arayüz metinleri
│   │   └── terminus-16.pf2            # Menü satırları fontu
│   │
│   └── icons/                         # İşletim sistemi sınıfları ikonları (32x32)
│       ├── parslinux.png              # ParsLinux (Varsayılan)
│       ├── pars.png                   # Pars takma adı
│       ├── linux.png                  # Linux çekirdeği / Genel Linux
│       ├── gnu-linux.png              # GNU/Linux
│       ├── debian.png                 # Debian
│       ├── arch.png                   # Arch Linux
│       ├── ubuntu.png                 # Ubuntu
│       ├── fedora.png                 # Fedora
│       ├── windows.png                # Windows Boot Manager
│       ├── uefi.png                   # UEFI Firmware Ayarları
│       ├── reboot.png                 # Yeniden Başlat
│       ├── shutdown.png               # Sistemi Kapat
│       ├── recovery.png               # Kurtarma modu
│       └── memtest.png                # RAM testi
│
├── debian/                            # Debian Paketleme Katmanı
├── install.sh                         # Bağımsız evrensel kurulum betiği
├── uninstall.sh                       # Temiz kaldırma betiği
├── package.sh                         # Paket oluşturucu
└── .github/workflows/build.yml        # CI doğrulama hattı
```

---

## 3. Grafiksel Ölçekleme ve Yerleşim Sistemi

### A. 3 Parçalı Yatay Kapsül (3-Slice Horizontal Box)
Menüde seçili olan satır, sabit genişlikte bir görsel yerine 3 parçalı yatay birleştirme ile çizilir:
```
[ select_w.png ] === [ select_c.png (yatayda yinelenir/uzar) ] === [ select_e.png ]
```
Bu yöntem sayesinde menü genişliği ne olursa olsun köşe ovalliği ve neon vurgu çizgisi bozulmaz.

### B. 9 Parçalı Çerçeve (9-Slice Grid Box)
Uçbirim kutusu (`terminal_box`), GRUB komut satırı (`c`) ve çekirdek parametre düzenleme (`e`) modunda 9 parça kullanılarak çizilir:
```
[nw] [     n     ] [ne]
[ w] [     c     ] [ e]
[sw] [     s     ] [se]
```

### C. Yüzdesel Koordinasyon (Responsive Scaling)
`parslinux/theme.txt` içerisindeki koordinatlar yüzdesel (`%`) ve mutlak piksel matematik formülleriyle tanımlanmıştır:
```ini
left = 22%
top = 32%
width = 56%
height = 46%
```
Bu sayede ekran çözünürlüğü 1366x768, 1920x1080 veya 2560x1440 olsa bile menü, arka plan görselindeki kılavuz çerçeveye tam oturur.

---

## 4. İkon Sınıflandırma Mantığı (GRUB Class System)

GRUB, menü girdilerindeki `--class` bayrağına göre tema klasöründeki `icons/<class>.png` dosyasını arar:

```
menuentry 'ParsLinux GNU/Linux' --class parslinux --class gnu-linux --class os { ... }
```

Arama önceliği:
1. `icons/parslinux.png` bulunur -> Ekrana basılır.
2. Bulunamazsa `icons/gnu-linux.png` aranır.
3. Bulunamazsa varsayılan genel ikon kullanılır.

`parslinux-grub-theme`, tüm yaygın dağıtımları ve sistem araçlarını kapsayan 16 adet modern 32x32 piksel şeffaf ikon barındırır.
