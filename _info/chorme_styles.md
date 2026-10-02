## styles to be use wit the chrome extension called, Stylus

https://chromewebstore.google.com/detail/clngdbkpkpeebahjckkjfobafhncgmne?utm_source=item-share-cb

```css
/* 1. Global eye-comfort tint that does not trigger GPU text-blur */
html::after {
  content: "";
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 2147483647;
  background-color: #f7eedf;
  mix-blend-mode: multiply;
  opacity: 0.65;
} /* 2. Razor-sharp font weight bump without stroke smudging */
p,
li,
dd,
dt,
label,
td,
th {
  font-weight: 500 !important;
  -webkit-font-smoothing: subpixel-antialiased !important;
} /* 3. Leave pre/code blocks at their native
weight so syntax stays clean */
pre,
code,
pre *,
code * {
  font-weight: revert !important;
}
```

```css
/* 1. Global eye-comfort overlay: eliminates blinding glare without blurring text */
html::after {
  content: "";
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 2147483647;
  background-color: #f2efe9;
  mix-blend-mode: multiply;
  opacity: 0.75;
}

/* 2. Sharp, intermediate font weight for readability without stroke smudging */
p,
li,
dd,
dt,
label,
td,
th {
  font-weight: 500 !important;
  -webkit-font-smoothing: subpixel-antialiased !important;
}

/* 3. Leave pre/code blocks at their native weight so syntax stays clean */
pre,
code,
pre *,
code * {
  font-weight: revert !important;
}
```
