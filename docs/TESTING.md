# 🧪 Tema Test ve Doğrulama Kılavuzu (`TESTING.md`)

Bilgisayarı yeniden başlatmadan GRUB temasını test etmek ve görsel hataları doğrulamak için kullanılan yöntemler bu belgede açıklanmıştır.

---

## 1. `grub-emu` ile Masaüstünde Canlı Test

`grub-emu` (GRUB Emulator), Linux masaüstünüzde bir pencere açarak gerçek GRUB ortamını ve temasını simüle etmenizi sağlar:

```bash
# Arch tabanlı sistemlerde:
sudo pacman -S grub (grub-emu genellikle paketle birlikte gelir)

# Debian / Ubuntu tabanlı sistemlerde:
sudo apt install grub-emu

# Simülatörü çalıştırma:
grub-emu
```

Simülatör açıldığında:
- Arka plan görselinin doğru hizalanıp hizalanmadığını,
- Seçim kapsülünün (`select_*.png`) düzgün uzayıp uzamadığını,
- İkonların menü satırlarında görünürlüğünü,
- `e` tuşuyla açılan düzenleme ve `c` tuşuyla açılan uçbirim kutusunun yerleşimini kontrol edebilirsiniz.

---

## 2. QEMU / KVM Sanal Makine Testi

Tam önyükleme döngüsünü test etmek için:

```bash
# Geçici bir EFI test diskiyle QEMU başlatma
qemu-system-x86_64 -enable-kvm -m 2048 -vga std \
  -drive file=/dev/sdX,format=raw
```

---

## 3. CI Doğrulama Kontrolleri

GitHub Actions hattı (`.github/workflows/build.yml`) her push ve pull request işleminde:
- Tüm betiklerin çalıştırılabilirlik izinlerini,
- `.deb` paketinin hatasız inşa edildiğini,
- Tema dosyalarının hedef dizinlere eksiksiz yerleştiğini otomatik test eder.
