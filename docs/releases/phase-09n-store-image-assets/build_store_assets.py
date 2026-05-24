"""Phase 09N — Build Amazon Appstore image deliverables from the brand master.

Inputs:
    assets/branding/app_icon.png  (512x512 RGBA — brand master)

Outputs (relative to this script's directory):
    icons/VerseLight-icon-512.png   — 512x512 RGBA, Amazon large icon
    icons/VerseLight-icon-114.png   — 114x114 RGBA, Amazon small icon
    promo/VerseLight-promo-1024x500.png — optional Amazon small banner

Run:
    python build_store_assets.py

Safe to re-run; outputs are overwritten deterministically.
"""

from __future__ import annotations

import hashlib
import os
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[3]
MASTER = ROOT / "assets" / "branding" / "app_icon.png"
OUT_DIR = Path(__file__).resolve().parent
ICONS = OUT_DIR / "icons"
PROMO = OUT_DIR / "promo"

# Brand colors (lib/utils/theme.dart)
CREAM = (250, 247, 240, 255)        # #FAF7F0 — AppColors.ivory / brand_cream
DEEP_NAVY = (29, 38, 54, 255)        # #1D2636 — AppColors.deepNavy
WARM_GOLD = (201, 164, 92, 255)      # #C9A45C — AppColors.warmGold
SAGE_GREEN = (111, 143, 114, 255)    # #6F8F72 — AppColors.sageGreen


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def load_master() -> Image.Image:
    if not MASTER.exists():
        sys.exit(f"FATAL: brand master not found at {MASTER}")
    im = Image.open(MASTER).convert("RGBA")
    if im.size != (512, 512):
        sys.exit(f"FATAL: expected 512x512 master, got {im.size}")
    return im


def build_icon_512(master: Image.Image) -> Path:
    """Amazon large icon — straight copy of the 512x512 master."""
    out = ICONS / "VerseLight-icon-512.png"
    master.save(out, format="PNG", optimize=True)
    return out


def build_icon_114(master: Image.Image) -> Path:
    """Amazon small icon — Lanczos downscale to 114x114 RGBA."""
    out = ICONS / "VerseLight-icon-114.png"
    small = master.resize((114, 114), Image.Resampling.LANCZOS)
    small.save(out, format="PNG", optimize=True)
    return out


def _find_font(candidates: list[str], size: int) -> ImageFont.FreeTypeFont:
    win_fonts = Path(r"C:\Windows\Fonts")
    for name in candidates:
        for ext in (".ttf", ".otf"):
            p = win_fonts / f"{name}{ext}"
            if p.exists():
                return ImageFont.truetype(str(p), size)
    return ImageFont.load_default()


def build_promo_1024x500(master: Image.Image) -> Path:
    """Optional Amazon small banner — icon left, wordmark + tagline right.

    Layout:
      1024x500 canvas, cream fill.
      Icon: 400x400 placed at x=60, vertical-centered.
      Right column: x=520..980, contains:
        - "VerseLight" wordmark (serif, deep navy, ~84pt)
        - underline accent (warm gold, 6px) below wordmark
        - tagline "Daily devotionals · Verse of the day" (sans, deep navy, ~30pt)
    """
    canvas = Image.new("RGBA", (1024, 500), CREAM)

    # Icon — keep the master's existing rounded artwork; downscale to 400x400.
    icon = master.resize((400, 400), Image.Resampling.LANCZOS)
    canvas.alpha_composite(icon, dest=(60, 50))

    draw = ImageDraw.Draw(canvas)

    # Wordmark — Lora-like serif. On Windows, Georgia is the closest preinstalled.
    # Auto-shrink to fit the right column (x=520..1000, width=480).
    wordmark = "VerseLight"
    right_col_left = 520
    right_col_right = 1000
    max_width = right_col_right - right_col_left
    wordmark_size = 84
    while wordmark_size >= 40:
        wordmark_font = _find_font(
            ["georgiab", "georgia", "times", "timesbd"], wordmark_size
        )
        probe = draw.textbbox((0, 0), wordmark, font=wordmark_font)
        if (probe[2] - probe[0]) <= max_width:
            break
        wordmark_size -= 4
    wm_bbox = draw.textbbox((0, 0), wordmark, font=wordmark_font)
    wm_width = wm_bbox[2] - wm_bbox[0]
    wm_height = wm_bbox[3] - wm_bbox[1]
    wordmark_x = right_col_left + (max_width - wm_width) // 2
    wordmark_y = 170
    draw.text((wordmark_x, wordmark_y), wordmark, font=wordmark_font, fill=DEEP_NAVY)

    # Gold underline accent below wordmark.
    underline_y = wordmark_y + wm_height + 24
    underline_w = min(wm_width // 2, 200)
    underline_x = wordmark_x + (wm_width - underline_w) // 2
    draw.rectangle(
        [(underline_x, underline_y), (underline_x + underline_w, underline_y + 6)],
        fill=WARM_GOLD,
    )

    # Tagline — Inter-like sans. Segoe UI ships on Windows. Auto-shrink to fit.
    tagline = "Daily Bible devotionals  ·  Verse of the day"
    tagline_size = 30
    while tagline_size >= 18:
        tagline_font = _find_font(["segoeui", "segoeuib", "arial"], tagline_size)
        probe = draw.textbbox((0, 0), tagline, font=tagline_font)
        if (probe[2] - probe[0]) <= max_width:
            break
        tagline_size -= 2
    tg_bbox = draw.textbbox((0, 0), tagline, font=tagline_font)
    tagline_x = right_col_left + (max_width - (tg_bbox[2] - tg_bbox[0])) // 2
    draw.text(
        (tagline_x, underline_y + 28),
        tagline,
        font=tagline_font,
        fill=DEEP_NAVY,
    )

    # Subtle sage accent dot to echo the in-app secondary color.
    draw.ellipse(
        [(960, 50), (980, 70)],
        fill=SAGE_GREEN,
    )

    out = PROMO / "VerseLight-promo-1024x500.png"
    canvas.save(out, format="PNG", optimize=True)
    return out


def main() -> None:
    ICONS.mkdir(parents=True, exist_ok=True)
    PROMO.mkdir(parents=True, exist_ok=True)

    master = load_master()
    print(f"master: {MASTER}  {master.size}  {master.mode}")

    outputs = [
        build_icon_512(master),
        build_icon_114(master),
        build_promo_1024x500(master),
    ]

    print("\nOUTPUTS")
    for p in outputs:
        im = Image.open(p)
        print(
            f"  {p.relative_to(OUT_DIR)}  "
            f"{im.size}  {im.mode}  "
            f"{p.stat().st_size:>8} bytes  "
            f"sha256={sha256(p)[:16]}…"
        )


if __name__ == "__main__":
    main()
