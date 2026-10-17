# 💻 Komut Satırı Başvuru Kılavuzu (`CLI_REFERENCE.md`)

Bu kılavuz, ParsLinux GRUB temasının yönetiminde kullanılan tüm komut dosyalarını ve ilgili GRUB komut satırı araçlarını belgeler.

---

## 1. Proje Betikleri

### `install.sh`
Temayı sisteme yükleyen ana betik.
- **Yetki**: Root (`sudo`) gereklidir.
- **Çalışma Şekli**:
  ```bash
  sudo ./install.sh
  ```
- **İşlev**: Dağıtımın GRUB yolunu (`/boot/grub` veya `/boot/grub2`) otomatik algılar, `/etc/default/grub` dosyasını yapılandırır ve `update-grub` / `grub-mkconfig` çalıştırır.

### `uninstall.sh`
Temayı sistemden kaldıran temizleme betiği.
- **Yetki**: Root (`sudo`) gereklidir.
- **Çalışma Şekli**:
  ```bash
  sudo ./uninstall.sh
  ```
- **İşlev**: Tema dosyalarını siler, `/etc/default/grub` içindeki referansları temizler ve GRUB konfigürasyonunu günceller.

### `package.sh`
Debian `.deb` paketi üreten derleme betiği.
- **Yetki**: Normal kullanıcı ile çalıştırılabilir.
- **Çalışma Şekli**:
  ```bash
  ./package.sh
  ```
- **İşlev**: `dpkg-buildpackage` veya doğrudan `dpkg-deb` kullanarak `build/parslinux-grub-theme_1.0.0_all.deb` oluşturur.

---

## 2. Sistem GRUB Komutları

| Komut | Açıklama |
| :--- | :--- |
| `sudo update-grub` | Debian/Ubuntu türevlerinde `grub.cfg` dosyasını günceller. |
| `sudo grub-mkconfig -o /boot/grub/grub.cfg` | Arch/Manjaro sistemlerinde önyükleme yapılandırmasını yeniden oluşturur. |
| `sudo grub2-mkconfig -o /boot/grub2/grub.cfg` | Fedora/RHEL sistemlerinde önyükleme yapılandırmasını yeniden oluşturur. |
| `grub-emu` | Yeniden başlatmadan GRUB arayüzünü masaüstü penceresinde simüle eder. |
