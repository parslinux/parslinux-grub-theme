# 📦 Flatpak ve Sandbox Kapsamı Değerlendirmesi (`FLATPAK_PACKAGING.md`)

Bu belge, bir GRUB önyükleme temasının neden doğrudan bir Flatpak paketi olamayacağını ve olası GUI tema yöneticisi çözümlerini değerlendirir.

---

## 1. Mimari Sınırlar

- **Kök Dizin ve Önyükleyici Erişimi**: GRUB temaları `/boot/grub/` ve `/etc/default/grub` dosyalarına doğrudan erişim ve `update-grub` çalıştırma yetkisi gerektirir.
- **Flatpak İzolasyonu**: Flatpak uygulamaları kullanıcı alanında korumalı bir sanal ortamda (sandbox) çalışır ve çekirdek seviyesindeki önyükleme yapılandırmalarına erişemez.

---

## 2. Olası Entegrasyon: "Pars Tema Yöneticisi" Flatpak'i

Gelecekte geliştirilebilecek bir grafiksel GRUB tema seçici Flatpak uygulaması:
- Flatpak içinde çalışır.
- `org.freedesktop.Flatpak.SystemHelper` veya D-Bus/Polkit portali üzerinden yetki alarak temayı `/boot/grub/themes` altına kurabilir.
