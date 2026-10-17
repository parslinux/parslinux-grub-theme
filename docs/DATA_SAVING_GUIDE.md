# 🛡️ Önyükleyici Bütünlüğü ve Veri Koruma Kılavuzu (`DATA_SAVING_GUIDE.md`)

Bu kılavuz, önyükleme yapılandırması sırasında olası sistem kilitlenmelerini önleme ve yedekten geri dönme yollarını açıklar.

---

## 1. Otomatik Yedekleme Mekanizması

`install.sh` betiği her çalıştığında `/etc/default/grub` dosyasının zaman damgalı kopyasını alır:
```bash
/etc/default/grub.bak.YYYYMMDDHHMMSS
```

## 2. Geri Alma (Rollback) Adımları

Herhangi bir grafik uyuşmazlığı nedeniyle GRUB ekranı açılmazsa:
1. Bilgisayarı açarken `Shift` (BIOS) veya `Esc` (UEFI) tuşuna basarak GRUB metin moduna girin.
2. Açılış parametresine `nomodeset` ekleyin.
3. Sistem açıldığında yedeği geri yükleyin:
   ```bash
   sudo cp /etc/default/grub.bak.* /etc/default/grub
   sudo update-grub
   ```
