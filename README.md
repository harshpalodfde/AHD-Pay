# AHD | Landing Page

Static, zero-dependency marketing site for AHD. No build step, no framework: just HTML/CSS/JS served as-is.

This branch (`gh-pages`) holds only the site, deployed via GitHub Pages. The source lives alongside the Android app on `master` under `website/`.

## Structure

```
.
├── index.html          Main landing page
├── about.html          About / story page
├── faq.html            FAQ page
├── terms.html          Terms of use
├── privacy.html         Privacy policy
├── styles.css          Gilroy + NeoPOP dark theme
├── shader.js           WebGL2 hero background (fBm + chrome streak)
├── haptics.js          Vibration API on data-haptic elements
├── main.js             Scroll-reveal, pointer parallax, nav highlight
└── assets/
    ├── logos/          icon.svg (nav/favicon mark), icon.png, logo1.png
    ├── screenshots/    demo photo + flow diagram, plus legacy app screenshots
    ├── cat_aesthetic.png
    ├── pwa-mockup.png  iPhone 14 Pro gold frame mockup
    └── pwa-screen.png  Raw PWA screenshot
```

## Run locally

```sh
python3 -m http.server 5500
# → http://localhost:5500
```

## Deploy

Served via GitHub Pages from this branch's root. Any push to `gh-pages` updates the live site automatically — see repo Settings → Pages for the URL.

## Design

- **Type:** Gilroy (all weights, from `web-assets.cred.club`) + JetBrains Mono for kickers/code.
- **Palette:** `#0d0d0d` canvas, `#C5F542` lime accent, no purple, no serif.
- **Buttons:** Real NeoPOP plunk geometry: skewed parallelogram edges (`skewX/Y(45deg)`), front face translates `+6px` on press so the box collapses into the page.
- **Hero shader:** WebGL2 domain-warped fBm + diagonal chrome streak + pointer-following lime light + film grain. Caps DPR at 1.5, pauses via IntersectionObserver when off-screen.
- **Reduced motion:** All animations respect `prefers-reduced-motion: reduce`.

## Links

- **Ankit**
- **Harsh:** [github.com/harshtripathi272](https://github.com/harshtripathi272/)
- **Dipam**
