# 🚀 Kurulum ve Yapılandırma Kılavuzu (`INSTALL.md`)

Bu belge, **ParsLinux GRUB Teması**'nın farklı Linux dağıtımlarına kurulumu, yapılandırılması ve sorun giderme adımlarını içerir.

---

## 1. Otomatik Kurulum (Tavsiye Edilen)

Depoyu yerel bilgisayarınıza indirin ve kurulum betiğini çalıştırın:

```bash
git clone https://github.com/parslinux/parslinux-grub-theme.git
cd parslinux-grub-theme
sudo ./install.sh
```

Betiğin yaptığı adımlar:
1. Temayı `/boot/grub/themes/parslinux` ve `/usr/share/grub/themes/parslinux` dizinlerine kopyalar.
2. `/etc/default/grub` dosyasının yedeğini alır.
3. `GRUB_THEME="/boot/grub/themes/parslinux/theme.txt"` satırını ekler.
4. `GRUB_GFXMODE="1920x1080,auto"` değerini ayarlar.
5. `update-grub` veya `grub-mkconfig` komutunu çalıştırarak yapılandırmayı tamamlar.

---

## 2. Dağıtım Tabanlı Kurulum Yöntemleri

### A. Debian / Ubuntu / ParsLinux (.deb Paketi)

```bash
# Paketi inşa edin
./package.sh

# Paketi yükleyin
sudo dpkg -i build/parslinux-grub-theme_1.0.0_all.deb
```

### B. Arch Linux / CachyOS / Manjaro

```bash
sudo mkdir -p /boot/grub/themes
sudo cp -r parslinux /boot/grub/themes/
echo 'GRUB_THEME="/boot/grub/themes/parslinux/theme.txt"' | sudo tee -a /etc/default/grub
echo 'GRUB_GFXMODE="1920x1080,auto"' | sudo tee -a /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### C. Fedora / RHEL

```bash
sudo mkdir -p /boot/grub2/themes
sudo cp -r parslinux /boot/grub2/themes/
echo 'GRUB_THEME="/boot/grub2/themes/parslinux/theme.txt"' | sudo tee -a /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

---

## 3. Güvenli Önyükleme (Secure Boot) ve Çözünürlük Notları

- **UEFI GOP / Çözünürlük**: Ekranınız 1920x1080'den farklıysa, GRUB görüntüyü en boy oranına göre otomatik uyarlar. Belirli bir çözünürlüğü zorlamak için `/etc/default/grub` içinde:
  ```ini
  GRUB_GFXMODE=1920x1080,1366x768,auto
  GRUB_GFXPAYLOAD_LINUX=keep
  ```
- **Siyah Ekran Durumunda**: Ekran kartınız UEFI altında yüksek çözünürlük desteklemiyorsa `c` tuşuna basarak GRUB konsoluna girip `vbeinfo` veya `videoinfo` komutu ile desteklenen modları görebilirsiniz.
