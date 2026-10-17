# 🔗 Sistem ve Dağıtım Entegrasyonu (`UYGULAMA_BAGLAMA.md`)

Bu belge, `parslinux-grub-theme` paketinin ParsLinux dağıtım ekosistemindeki diğer bileşenlerle nasıl bağlandığını açıklar.

---

## 1. `live-build` ISO Entegrasyonu

Canlı kurulum kalıbı (`ParsLinux-1.0-gnome-amd64.iso`) oluşturulurken:
1. `parslinux-grub-theme` paketi `auto/config` içerisindeki paket listesine eklenir:
   ```bash
   # config/package-lists/desktop.list.chroot
   parslinux-grub-theme
   ```
2. Canlı sistem açılışında GRUB konfigürasyonu otomatik olarak bu temayı referans alır.

---

## 2. `calamares-settings-parslinux` (Kurulum Sihirbazı) Entegrasyonu

Kullanıcı sistemi diske kurduğunda Calamares kurulum sihirbazının `bootloader` modülü:
- Hedef sisteme GRUB önyükleyicisini kurar.
- `/target/etc/default/grub` dosyasına:
  ```ini
  GRUB_THEME="/usr/share/grub/themes/parslinux/theme.txt"
  GRUB_GFXMODE="1920x1080,auto"
  ```
  tanımlarını yazar ve `chroot /target update-grub` komutunu işletir.

---

## 3. `parslinux-boot-repair` (Önyükleme Kurtarma) Entegrasyonu

Kullanıcı önyükleyici çöktüğünde `parslinux-boot-repair` uygulamasını çalıştırdığında:
- Kurtarma aracı EFI ve MBR kayıtlarını onarırken ParsLinux temasını kontrol eder ve varsayılan tema olarak yeniden bağlar.
