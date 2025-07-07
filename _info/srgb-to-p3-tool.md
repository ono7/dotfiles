this tool will convert srgb colors to better match the saturation of colors
p3 provides, this will make colors in themes more accurate to what i like :)

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>P3 to sRGB Color Converter</title>
    <style>
      body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
        background: #1d2433;
        color: #e3ded7;
      }
      .converter {
        background: #2d3343;
        padding: 20px;
        border-radius: 8px;
        margin: 20px 0;
      }
      input[type="text"] {
        background: #364156;
        border: 1px solid #8087a2;
        color: #e3ded7;
        padding: 8px 12px;
        border-radius: 4px;
        width: 120px;
        font-family: monospace;
      }
      button {
        background: #8ca7be;
        color: #1d2433;
        border: none;
        padding: 8px 16px;
        border-radius: 4px;
        cursor: pointer;
        margin: 0 8px;
      }
      button:hover {
        background: #a4bcce;
      }
      .color-preview {
        width: 60px;
        height: 60px;
        border-radius: 4px;
        border: 2px solid #8087a2;
        display: inline-block;
        margin: 0 10px;
      }
      .results {
        background: #364156;
        padding: 15px;
        border-radius: 4px;
        margin-top: 10px;
        font-family: monospace;
      }
    </style>
  </head>
  <body>
    <h1>P3-to-sRGB Color Enhancer</h1>
    <p>
      Enter your hex colors to get enhanced versions that look more vibrant in
      sRGB (closer to P3 appearance):
    </p>

    <div class="converter">
      <label>
        Original Color:
        <input
          type="text"
          id="hexInput"
          placeholder="#C49A9A"
          value="#C49A9A"
        />
      </label>
      <div class="color-preview" id="originalPreview"></div>

      <button onclick="enhanceColor()">Enhance for sRGB</button>

      <div class="color-preview" id="enhancedPreview"></div>

      <div class="results" id="results"></div>
    </div>

    <div class="converter">
      <h3>Quick Convert Your Theme:</h3>
      <button onclick="convertTheme()">Convert All Theme Colors</button>
      <div class="results" id="themeResults"></div>
    </div>

    <script>
      function hexToRgb(hex) {
        const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result
          ? {
              r: parseInt(result[1], 16),
              g: parseInt(result[2], 16),
              b: parseInt(result[3], 16),
            }
          : null;
      }

      function rgbToHex(r, g, b) {
        return (
          "#" +
          [r, g, b]
            .map((x) => {
              const hex = Math.round(Math.max(0, Math.min(255, x))).toString(
                16,
              );
              return hex.length === 1 ? "0" + hex : hex;
            })
            .join("")
        );
      }

      function enhanceSaturation(r, g, b, factor = 1.15) {
        // Convert to HSL, increase saturation, convert back
        r /= 255;
        g /= 255;
        b /= 255;

        const max = Math.max(r, g, b);
        const min = Math.min(r, g, b);
        const diff = max - min;

        // Calculate lightness
        const l = (max + min) / 2;

        if (diff === 0)
          return [
            Math.round(r * 255),
            Math.round(g * 255),
            Math.round(b * 255),
          ];

        // Calculate saturation
        const s = l > 0.5 ? diff / (2 - max - min) : diff / (max + min);

        // Calculate hue
        let h;
        switch (max) {
          case r:
            h = (g - b) / diff + (g < b ? 6 : 0);
            break;
          case g:
            h = (b - r) / diff + 2;
            break;
          case b:
            h = (r - g) / diff + 4;
            break;
        }
        h /= 6;

        // Enhance saturation, but cap it
        const newS = Math.min(1, s * factor);

        // Convert back to RGB
        const c = (1 - Math.abs(2 * l - 1)) * newS;
        const x = c * (1 - Math.abs(((h * 6) % 2) - 1));
        const m = l - c / 2;

        let newR, newG, newB;
        if (h < 1 / 6) {
          newR = c;
          newG = x;
          newB = 0;
        } else if (h < 2 / 6) {
          newR = x;
          newG = c;
          newB = 0;
        } else if (h < 3 / 6) {
          newR = 0;
          newG = c;
          newB = x;
        } else if (h < 4 / 6) {
          newR = 0;
          newG = x;
          newB = c;
        } else if (h < 5 / 6) {
          newR = x;
          newG = 0;
          newB = c;
        } else {
          newR = c;
          newG = 0;
          newB = x;
        }

        return [
          Math.round((newR + m) * 255),
          Math.round((newG + m) * 255),
          Math.round((newB + m) * 255),
        ];
      }

      function enhanceColor() {
        const hex = document.getElementById("hexInput").value;
        const rgb = hexToRgb(hex);

        if (!rgb) {
          document.getElementById("results").innerHTML = "Invalid hex color!";
          return;
        }

        // Show original
        document.getElementById("originalPreview").style.backgroundColor = hex;

        // Enhance - use higher factor for greens and cyans
        let factor = 1.15;
        if (rgb.g > rgb.r && rgb.g > rgb.b) factor = 1.25; // Green dominant
        if (rgb.g > 150 && rgb.b > 150 && rgb.r < 150) factor = 1.25; // Cyan-ish

        const enhanced = enhanceSaturation(rgb.r, rgb.g, rgb.b, factor);
        const enhancedHex = rgbToHex(enhanced[0], enhanced[1], enhanced[2]);

        // Show enhanced
        document.getElementById("enhancedPreview").style.backgroundColor =
          enhancedHex;

        document.getElementById("results").innerHTML = `
                Original: ${hex}<br>
                Enhanced: ${enhancedHex}<br>
                RGB: rgb(${enhanced[0]}, ${enhanced[1]}, ${enhanced[2]})
            `;
      }

      function convertTheme() {
        const colors = {
          red: "#C49A9A",
          green: "#8CBBAD",
          yellow: "#D4B97E",
          blue: "#8CA7BE",
          magenta: "#B097B6",
          cyan: "#93B5B3",
          white: "#C9C2B8",
          bright_red: "#D5AFAF",
          bright_green: "#A2CFBF",
          bright_yellow: "#E1CA97",
          bright_blue: "#A4BCCE",
          bright_magenta: "#C4AFC8",
          bright_cyan: "#A9C9C7",
        };

        let output = "# Enhanced colors for Alacritty\n\n[colors.normal]\n";

        Object.entries(colors).forEach(([name, hex]) => {
          const rgb = hexToRgb(hex);
          if (rgb) {
            let factor = 1.15;
            if (name.includes("green") || name.includes("cyan")) factor = 1.25;

            const enhanced = enhanceSaturation(rgb.r, rgb.g, rgb.b, factor);
            const enhancedHex = rgbToHex(enhanced[0], enhanced[1], enhanced[2]);

            const colorName = name.replace("bright_", "").replace("_", " ");
            if (name.startsWith("bright_")) {
              if (name === "bright_red") output += "\n[colors.bright]\n";
              output += `${colorName} = "${enhancedHex}"\n`;
            } else {
              output += `${name} = "${enhancedHex}"\n`;
            }
          }
        });

        document.getElementById("themeResults").innerHTML =
          `<pre>${output}</pre>`;
      }

      // Initialize with default
      document
        .getElementById("hexInput")
        .addEventListener("input", enhanceColor);
      enhanceColor();
    </script>
  </body>
</html>
```
