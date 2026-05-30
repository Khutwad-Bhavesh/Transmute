<div align="center">

# Transmute

**A free, offline, open-source file converter for everyone.**
No ads. No watermarks. No sign-in. No internet required.

![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows%20%7C%20macOS-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-v1.0.0-brightgreen)

</div>

---

## What is Transmute?

Transmute is the WinRAR of file conversion — install it once, use it forever, completely free. No cloud, no tracking, no nonsense. Everything runs locally on your machine.

---

## Supported Conversions

| Category | Formats |
|----------|---------|
| 🖼 Images | JPG ↔ PNG ↔ WEBP ↔ BMP, Images → PDF |
| 📊 Data | CSV ↔ XLSX |
| 📄 Documents | DOCX → PDF, TXT → PDF, PDF → DOCX |
| 🔧 PDF Tools | Merge PDFs, Split by range / every N pages / odd-even |
| 🎬 Video | MP4 ↔ AVI ↔ MKV ↔ GIF |

---

## Features

- **Batch queue** — add multiple files, set per-file formats, convert all at once
- **Progress tracking** — live status dots and progress bar per conversion
- **History** — searchable log of every conversion with open-folder shortcut
- **Output folder** — choose exactly where converted files go
- **Engine picker** — choose how Transmute works on first launch
- **Auto light/dark theme** — follows your system
- **100% offline** — nothing ever leaves your machine

---

## Engine Options

On first launch, you choose how Transmute works:

| Engine | Size | Description |
|--------|------|-------------|
| ⚡ Lightweight | ~50MB | Dart-only libs, no setup needed |
| 🔧 Powerful | ~200MB | Bundles ffmpeg + tools automatically |
| 🎛️ Manual | Smallest | Use your own installed tools |

You can change this anytime in Settings.

---

## Setup

### Linux

```bash
# Dependencies
sudo apt install git flutter ffmpeg libreoffice

# Clone
git clone https://github.com/Khutwad-Bhavesh/Transmute.git
cd Transmute

# Run
flutter pub get
flutter run -d linux
```

### Windows

```bash
git clone https://github.com/Khutwad-Bhavesh/Transmute.git
cd Transmute
flutter pub get
flutter run -d windows
```

### macOS

```bash
git clone https://github.com/Khutwad-Bhavesh/Transmute.git
cd Transmute
flutter pub get
flutter run -d macos
```

---

## Project Structure

```
lib/
├── core/
│   ├── constants/        # Colors, typography
│   ├── converters/       # Image, PDF, data, video, document logic
│   ├── models/           # ConversionJob
│   └── services/         # History, output folder
├── features/
│   ├── onboarding/       # Engine picker
│   ├── converter/        # Main conversion screen
│   ├── pdf_tools/        # Merge + split
│   ├── history/          # Conversion log
│   └── settings/         # Engine + output preferences
└── shared/
    └── widgets/          # Sidebar, reusable components
```

---

## Contributing

Pull requests welcome.

To add a new format:
1. Create `lib/core/converters/yourformat_converter.dart`
2. Add formats to `availableFormats` in `conversion_job.dart`
3. Add routing in `converter_dispatcher.dart`

The UI picks it up automatically.

---

## License

MIT © 2026 Bhavesh Khutwad

---

<div align="center">
<sub>Built with Flutter · No enemies · Just convert</sub>
</div>