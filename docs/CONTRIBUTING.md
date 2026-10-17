# 🤝 Katkıda Bulunma Kılavuzu (`CONTRIBUTING.md`)

ParsLinux GRUB temasına katkıda bulunmak istediğiniz için teşekkür ederiz!

---

## 1. Katkı Alanları

- **Yeni İkonlar**: Henüz listede bulunmayan Linux dağıtımları veya donanım araçları için 32x32 piksel şeffaf PNG ikonlar ekleyebilirsiniz.
- **Yüksek Çözünürlüklü Vektörler**: Arka plan ve görsel varlıkların SVG kaynaklarını geliştirebilirsiniz.
- **Yazı Tipleri**: Türkçe karakterleri eksiksiz destekleyen açık kaynaklı yeni bitmap yazı tipleri (`.pf2`) önerebilirsiniz.
- **Hata Bildirimleri**: Farklı ekran çözünürlükleri veya anakart UEFI/BIOS modlarındaki görüntü kaymalarını bildirebilirsiniz.

---

## 2. Geliştirme ve Gönderim Kuralları

1. Depoyu forklayın ve yeni bir dal oluşturun:
   ```bash
   git checkout -b feature/yeni-ikonlar
   ```
2. Değişikliklerinizi yapıp `grub-emu` ile test edin.
3. Anlamlı commit mesajları yazın (Conventional Commits standardı):
   - `feat: add gentoo and freebsd icons`
   - `fix: adjust progress bar position for 4K displays`
4. GitHub üzerinden `main` dalına Pull Request açın.
