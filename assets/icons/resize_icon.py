from PIL import Image

src = Image.open('assets/icons/icon.png').convert('RGBA')

sizes = [16, 32, 48, 64, 128, 256, 512]
for s in sizes:
    resized = src.resize((s, s), Image.LANCZOS)
    resized.save(f'assets/icons/icon_{s}.png')
    print(f'Generated icon_{s}.png')