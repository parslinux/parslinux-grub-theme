# 🌍 Çeviri ve Yerelleştirme Kılavuzu (`TRANSLATION_GUIDE.md`)

Bu rehber, GRUB teması üzerindeki yönlendirici metinlerin ve menü girdilerinin çoklu dil desteğine nasıl katkı sağlanacağını açıklar.

---

## 1. GRUB Tema Metinleri

GRUB arayüzündeki statik yönlendirme ipuçları `parslinux/background.png` üzerinde doğrudan işlenmiş olup Türkçe standart kılavuz sunar:
- `[ ↑ / ↓ ] Seçim Yap`
- `[ ENTER ] Başlat`
- `[ E ] Parametreleri Düzenle`
- `[ C ] GRUB Komut Satırı`

---

## 2. Geri Sayım ve Sistem Etiketleri

`theme.txt` içerisindeki etiketler GRUB2'nin yerel gettext değişkenlerini kullanır:
- `@TIMEOUT_NOTIFICATION_SHORT@`: Sistem diline göre "x saniye içinde başlatılıyor" metnini dinamik basar.
- `@KEYMAP_SHORT@`: Klavye düzeni kodunu görüntüler.

GRUB'un sistem çevirilerine katkı sağlamak için `po/` dosyaları upstream GNU GRUB projesi üzerinden yönetilir.
