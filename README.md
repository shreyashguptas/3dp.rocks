# 3dp.rocks — Image to Lithophane

A browser-based tool that turns a photo into a 3D-printable lithophane (an STL file).
Everything happens inside the browser: the image never leaves your machine, and
nothing is uploaded anywhere.

This is a **fork** of [MarkDurbin104/3dp.rocks](https://github.com/MarkDurbin104/3dp.rocks)
(MIT, © 2015 Mark Durbin), the source behind <http://3DP.Rocks>. All credit for the
original work is his. See [What this fork changes](#what-this-fork-changes) below.

---

## Running it on macOS

### The one-command way

```bash
cd ~/Documents/Github/3dp.rocks
./run.sh
```

That starts a local web server and opens the app in your default browser.
Press `Ctrl+C` in the terminal to stop it. If port 8777 is busy, pass another
one: `./run.sh 8888`.

The server is bound to `127.0.0.1`, so it is reachable from this Mac only and
never appears on your network, and it serves only the `lithophane` folder, so
the `.git` directory is never exposed.

### The manual way

```bash
cd ~/Documents/Github/3dp.rocks
python3 -m http.server 8777 --bind 127.0.0.1 --directory lithophane
```

Then open <http://127.0.0.1:8777/index.html> and press `Ctrl+C` when done.

Both flags matter, so don't drop them:

- `--bind 127.0.0.1` keeps the server visible to **this Mac only**. Without it,
  Python serves to every network interface, meaning anyone on the same Wi-Fi —
  a cafe, a hotel, a shared office — can open it.
- `--directory lithophane` serves only the app folder. Without it you serve the
  whole repository, which hands out a browsable listing of everything including
  the `.git` folder and its config.

> `python3` here is only acting as a static file server — this is not a Python
> project and there are no dependencies to install. macOS ships with `python3`
> already, so there is nothing to set up.

### Important: you cannot just double-click the HTML file

Opening `lithophane/index.html` straight from Finder gives you a **blank or broken
page**. The app reads its own settings from `lithophane/data/layout.json`, and
browsers block a `file://` page from loading files off the disk that way. It has to
be served over `http://`, which is all `run.sh` is doing.

### Requirements

- A browser with WebGL (Safari, Brave, Chrome, Firefox — anything current is fine)
- Nothing else. No Node, no npm, no build step, no internet connection.

---

## How to use it

1. **Images tab** — drag a photo onto the drop area, or click to browse. JPG, PNG,
   GIF and BMP are accepted.
2. Click the thumbnail of the image you want to use.
3. **Model tab** — pick a shape (flat, inner/outer curve, cylinder, heart, dome…)
   and hit **Refresh** to rebuild the 3D preview. Drag in the preview to orbit.
4. **Settings** — adjust physical size, thickness, border, and how bright or dark
   the result comes out.
5. **Download** — saves an `.stl` you can drop straight into PrusaSlicer.

### Printing notes

A lithophane works by varying thickness: thick where the image is dark, thin where
it is bright. Print it with a light background material, no infill gaps, and a fine
layer height (0.1mm or below) — then hold it up to a light.

---

## What this fork changes

Only one change to the original code:

- **Removed Google AdSense and Google Analytics from `lithophane/index.html`.**
  The upstream file loaded an ad script and reported every page view to the original
  author's analytics account, which makes sense for a public website but not for a
  tool running on your own machine. With those gone, the app makes **zero network
  requests** and works entirely offline. The now-empty `<footer>` element is kept
  deliberately — `css/style.css` uses its 100px height for the sticky-footer layout.

Everything else is untouched upstream code.

### Security review

Before running any of this, the full repository was audited — all 41 files:

- The author's own code (`main.js`, `app.js`) does nothing but geometry math. Images
  are read locally in the browser and the STL is generated and saved locally. There
  are no uploads, no tracking, no dynamic code execution, no obfuscation, no install
  scripts and no git hooks.
- The bundled third-party libraries were compared against their official releases:
  - **jQuery 1.11.1** and **AngularJS 1.3.14** — byte-for-byte identical to upstream.
  - **Three.js r69** — 99.99% identical to the official r69 release. The only
    difference is that two `console.log` lines were deleted. Nothing was added.
  - **Bootstrap 3.3.x** — an official "Bootstrap Customizer" build; the only
    differences from the official dist are version strings and minifier formatting.

**Caveat worth knowing:** these libraries date from 2015 and no longer receive
security updates. That is fine for a local tool you feed your own photos. Do not
deploy this to a public server without updating them first.

---

## Staying in sync with the original

This fork keeps a link to the upstream repo, so you can pull in any future changes:

```bash
git fetch upstream
git merge upstream/master
```

`origin` points at your fork; `upstream` points at MarkDurbin104's original.

---

## Layout

```
lithophane/
  index.html        entry point — the page you open
  js/main.js        the engine: image → height map → 3D mesh → STL
  js/app.js         the UI wiring (AngularJS)
  data/layout.json  all on-screen text and slider ranges (English)
  data/layout_it.json   the Italian equivalent
  js/libs/, js/three/   vendored third-party libraries
run.sh              local launcher (this fork)
```

To switch languages, change the `localeFile` line near the top of
`lithophane/index.html` to point at a different file in `lithophane/data/`.

---

## License

MIT, © 2015 Mark Durbin. See [LICENSE](LICENSE). Uses
[three.js](https://github.com/mrdoob/three.js/) and
[FileSaver.js](https://github.com/eligrey/FileSaver.js/); binary STL output derived
from an example by [Paul Kaplan](https://gist.github.com/paulkaplan).

## Code of Conduct

The original project's Contributor Covenant is preserved in
[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
