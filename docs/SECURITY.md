# 🔒 Güvenlik Politikası ve Değerlendirmesi (`SECURITY.md`)

Bu belge, **ParsLinux GRUB Teması**'nın sistem güvenliği açısından etkilerini ve güvenlik standartlarını açıklar.

---

## 1. Yetki ve Dosya Erişim Güvenliği

- **Önyükleyici Dosyaları**: GRUB tema dosyaları `/boot/grub/themes/parslinux` dizinine yazılır. Bu dizine yazma işlemi yalnızca `root` kullanıcısına aittir (`chmod 755 / 644`).
- **`/etc/default/grub` Değişiklikleri**: `install.sh` betiği, mevcut yapılandırmayı değiştirmeden önce her zaman zaman damgalı bir yedek (`.bak.YYYYMMDDHHMMSS`) oluşturur.
- **Zararlı Kod İçermeme**: GRUB tema dosyaları salt statik varlıklardan (metin, PNG görseller ve PF2 yazı tipleri) oluşur. Herhangi bir ikili çalıştırılabilir veya dinamik betik çalıştırma kabiliyeti yoktur.

---

## 2. Güvenlik Açığı Bildirimi

Bir güvenlik sorunu tespit ettiğinizde lütfen doğrudan **security@parslinux.org** adresine e-posta gönderin.
