https://slothytech.com/world-of-warcraft-best-nvidia-settings/

## midnight edit mode import settings

https://www.luxthos.com/cooldown-manager-profiles-world-of-warcraft-midnight/

https://www.youtube.com/watch?v=hvSz3sNEm10

# make things sharper

/console set ResampleAlwaysSharpen 1

# faster loading wow

/console worldpreloadnoncritical 0

# macos fix naga mouse

`defaults write com.blizzard.worldofwarcraft disable-expose-fix -bool YES`

# console settings/macros

- 𝗭𝗢𝗢𝗠 𝗛𝗔𝗖𝗞 ►
  /console cameraDistanceMaxZoomFactor 2.6

- 𝗭𝗢𝗢𝗠 𝗦𝗠𝗢𝗢𝗧𝗛𝗜𝗡𝗚 ►
  /console CameraReduceUnexpectedMovement 1
- 𝗦𝗛𝗔𝗥𝗣𝗘𝗡 𝗙𝗜𝗟𝗧𝗘𝗥 𝗛𝗔𝗖𝗞 ►
  /console set ResampleAlwaysSharpen 1

FSR /console set renderscale 0.999

Fix overly saturated worl

/console ffxglow 0
/console ffxglow 1 (to disable)

# macro

-- these settings should be applied any time cvars are reset
/console CameraReduceUnexpectedMovement 1
/console set renderscale 0.999
/console set ResampleAlwaysSharpen 1
/console UnitNamePlayerGuild 0
/console UnitNamePlayerPVPTitle 0

# nvidia control panel options for wow

## Must haves

1. Particle density (max)
2. Projected textures (enabled)
3. Texture resolution (max)
4. Contrast (70% - 75%)

## Graphics

- Render Scale - 99% (or 91%) + FSR
- Veritcal Sync - Disabled (on on MacOS)
- Low latency - Nvidia Reflex + Boost
- Anti-Aliasing - off
- Camara FOV = 90/max

## Base Game Quality 10

- Shadow Quality = low
- Liquid Detail = fair
- Particle Density = Ultra
- SSAO = disable
- Depth Effects = disabled
- Compute Effects = disabled
- Outline mode = good
- Texture Resolution = High
- Spell Density = Essential
- Projected Textures = Enabled
- View distance = 3
- Environmental Detail = 1
- Ground Clutter = 1

## Advanced

- Triple Buffering (unchecked)
- Texture filtering = 18x Anisotropic
- Ray tracing = disabled
- Resample Quaility = Fidelity
- VRS Mode = Disabled
- Graphics API = Dirextx12
- Physical Interactions = None
- Graphics card = Auto
- Max foreground FPS (unchecked)
- Max Background = 60
- Target FPS (unchecked)
- Resample Sharpness = 0
- Contrast (75%)
- Brightness %50 (default)
- Gamma = 1

## Compatability Settings

- all checked

## other settings

- Disable friendly name plates

## Old settings for nvidia control panel

Image Scaling – Off
Ambient Occlusion – Off
Anisotropic Filtering – Off
Antialiasing – Off
Antialiasing – Off
Antialiasing Mode – Off
Antialiasing Transparency – Off
Background Application Max Frame Rate: Off
CUDA GPUs – All
DSR Factors – Off
Low Latency Mode – Depends
Max Frame Rate – Off
Preferred Refresh Rate: Highest Available
Multi-Frame Sampled AA – Off
OpenGL Rendering GPU – Main GPU
Power-Management Mode – Prefer Maximum Performance
Shader Cache Size – Driver Default
Texture Filtering -Anisotropic sample optimization – On
Texture Filtering – Negative LOD Bias – Allow
Texture Filtering – Quality – High Performance
Texture Filtering – Trilinear Optimization – On
Threaded optimization – On
Triple buffering – Off
Vertical Sync – Off
